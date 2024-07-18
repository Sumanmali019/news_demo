import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Service/get_news_api_service_.dart';
import '../Service/remote_config_service.dart';

class CountryPicker extends StatelessWidget {
  const CountryPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final remoteConfigService = Provider.of<RemoteConfigService>(context);

    return FutureBuilder<List<String>>(
      future: remoteConfigService.fetchCountryCodes(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            String countryCode = snapshot.data![index];
            return ListTile(
              title: Text(countryCode.toUpperCase()),
              onTap: () {
                Provider.of<NewsProvider>(context, listen: false).country =
                    countryCode;
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }
}
