// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Model/news_model.dart';
import 'package:flutter_application_1/Service/get_news_api_service_.dart';
import 'package:flutter_application_1/screens/signup_screen.dart';
import 'package:flutter_application_1/widgets/country_picker.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../Service/firebase_auth_service.dart';
import '../utils/app_colours.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = '/home-screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void showCountryPicker(BuildContext context) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return const CountryPicker();
        },
      );
    }

    final selectedCountry = Provider.of<NewsProvider>(context).currentCountry;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          "MyNews",
          style: TextStyle(
              color: AppColors.whiteColor,
              fontSize: 14,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.near_me,
              color: AppColors.whiteColor,
            ),
            onPressed: () => showCountryPicker(context),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Text(
              selectedCountry.toUpperCase(),
              style: const TextStyle(
                  color: AppColors.whiteColor, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            onPressed: () async {
              bool success =
                  await context.read<FirebaseAuthMethods>().signOut(context);
              if (success) {
                Navigator.pushReplacementNamed(
                    context, EmailPasswordSignup.routeName);
              }
            },
            icon: const Icon(
              Icons.logout,
              color: AppColors.whiteColor,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 20.0,
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 14.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Top Headlines',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Consumer<NewsProvider>(
                builder: (context, newsProvider, _) {
                  if (newsProvider.articles.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    itemCount: newsProvider.articles.length,
                    itemBuilder: (context, index) {
                      return _buildNewsItem(newsProvider.articles[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildNewsItem(NewsArticle article) {
  String timeAgo = '';
  if (article.publishedAt != null) {
    timeAgo = timeago.format(article.publishedAt!, locale: 'en');
  }

  return Padding(
    padding: const EdgeInsets.only(left: 16.0, right: 16),
    child: Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  article.description ?? "No description available",
                  style: const TextStyle(fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Text(
                  timeAgo,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 160,
                height: 150,
                child: article.urlToImage != null
                    ? CachedNetworkImage(
                        imageUrl: article.urlToImage!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Center(
                          child: CircularProgressIndicator(
                              value: downloadProgress.progress),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      )
                    : Image.asset(
                        'assets/image/breaking.jpg',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
