import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig remoteConfig;

  RemoteConfigService(this.remoteConfig);

  Future<List<String>> fetchCountryCodes() async {
    try {
      await remoteConfig.fetchAndActivate();
      String countryCodes = remoteConfig.getString('country_codes');
      return countryCodes.split(',');
    } catch (e) {
      print('Failed to fetch country codes: $e');
      return [];
    }
  }
}
