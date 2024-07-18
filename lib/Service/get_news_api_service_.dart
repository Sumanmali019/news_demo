import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Model/news_model.dart';
import 'package:http/http.dart' as http;

class NewsProvider with ChangeNotifier {
  List<NewsArticle> _articles = [];
  String currentCountry = 'in';
  bool isLoading = false;

  List<NewsArticle> get articles => _articles;

  NewsProvider({String country = 'in'}) {
    currentCountry = country;
    fetchTopHeadlines();
  }

  set country(String newCountry) {
    if (newCountry != currentCountry) {
      currentCountry = newCountry;
      fetchTopHeadlines(); // This should re-fetch the data
    }
  }

  Future<void> fetchTopHeadlines() async {
    isLoading = true;
    notifyListeners();

    String url =
        'https://newsapi.org/v2/top-headlines?country=$currentCountry&category=business&apiKey=64324e1463c346e18edeff32cb33c33f';

    print("Fetching URL: $url");
    var response = await http.get(Uri.parse(url));
    isLoading = false;
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      _articles = List<NewsArticle>.from(
          data['articles'].map((article) => NewsArticle.fromJson(article)));
    } else {
      print('Failed to load news: ${response.statusCode}');
      _articles = [];
    }
    notifyListeners();
  }
}

