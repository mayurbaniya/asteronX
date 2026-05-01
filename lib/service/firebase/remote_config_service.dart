import 'package:asteron_x/config/environment.dart';
import 'package:asteron_x/service/firebase/remote_data.dart';
import 'package:asteron_x/utils/colors.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> fetchAndSaveConfig() async {
    try {
      print('Environment: ${EnvironmentConfig.environmentName}');
      print('Base URL key: ${EnvironmentConfig.baseUrlKey}');

      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(seconds: 10)));

      await _remoteConfig.fetchAndActivate();

      // Pick the env-scoped values: backend URL, target version, download
      // URL — all keyed by EnvironmentConfig so test/uat/prod can diverge.
      String baseURL = _remoteConfig.getString(EnvironmentConfig.baseUrlKey);
      String underMn = _remoteConfig.getString('maintenance_x');
      String adminMail = _remoteConfig.getString('admin_email');
      String adminPhone = _remoteConfig.getString('admin_phone');
      String partnerAppVersion =
          _remoteConfig.getString(EnvironmentConfig.versionKey);
      String partnerAppDownloadUrl =
          _remoteConfig.getString(EnvironmentConfig.downloadUrlKey);
      print('fetched remote data : '
          '$baseURL $underMn $adminMail $adminPhone $partnerAppVersion');

      String privacyIntro = _remoteConfig.getString('p_policy_brief_intro');
      String privacyGrievance = _remoteConfig.getString('p_policy_grievances');
      String privacyInfoStored =
          _remoteConfig.getString('p_policy_information_stored');
      String privacyObligations =
          _remoteConfig.getString('p_policy_obligations');
      String updateMessage = _remoteConfig.getString('update_popup_details');

      RemoteData().setBaseURL(baseURL);
      RemoteData().setUnderMaintenence(underMn);
      RemoteData().setAdminEmail(adminMail);
      RemoteData().setAdminPhone(adminPhone);
      RemoteData().setPartnerAppVersion(partnerAppVersion);
      RemoteData().setPartnerAppDownloadUrl(partnerAppDownloadUrl);
      RemoteData().setPrivacyOverview(privacyIntro);
      RemoteData().setPrivacyGrevience(privacyGrievance);
      RemoteData().setPrivacyInformationStored(privacyInfoStored);
      RemoteData().setPrivacyObligations(privacyObligations);
      RemoteData().setUpdateMessage(updateMessage);
    } catch (e) {
      Get.snackbar('error', 'Failed to Fetch Configurations',
          icon: Icon(Icons.error_outline_sharp), colorText: textPrimaryColor);
    }
  }
}
