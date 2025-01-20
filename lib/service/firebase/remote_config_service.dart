import 'package:asteron_x/service/firebase/remote_data.dart';
import 'package:asteron_x/utils/colors.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> fetchAndSaveConfig() async {
    try {
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(seconds: 10)));

      await _remoteConfig.fetchAndActivate();

      String baseURL = _remoteConfig.getString("BASE_URL");
      String underMn = _remoteConfig.getString('maintenance_x');
      String adminMail = _remoteConfig.getString('admin_email');
      print('fetched remote data : $baseURL $underMn $adminMail');

      String privacyIntro = _remoteConfig.getString('p_policy_brief_intro');
      String privacyGrievance = _remoteConfig.getString('p_policy_grievances');
      String privacyInfoStored =
          _remoteConfig.getString('p_policy_information_stored');
      String privacyObligations =
          _remoteConfig.getString('p_policy_obligations');

      RemoteData().setBaseURL(baseURL);
      RemoteData().setUnderMaintenence(underMn);
      RemoteData().setAdminEmail(adminMail);
      RemoteData().setPrivacyOverview(privacyIntro);
      RemoteData().setPrivacyGrevience(privacyGrievance);
      RemoteData().setPrivacyInformationStored(privacyInfoStored);
      RemoteData().setPrivacyObligations(privacyObligations);
    } catch (e) {
      Get.snackbar('error', 'Failed to Fetch Configurations',
          icon: Icon(Icons.error_outline_sharp), colorText: textPrimaryColor);
    }
  }
}
