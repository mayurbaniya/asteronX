import 'dart:convert';

import 'package:asteron_x/service/firebase/remote_data.dart';
import 'package:asteron_x/widgets/x_dialog.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateController extends GetxController {
  RxString oldVersion = "".obs;
  RxString currentVersion = "".obs;
  RxString newAppURL = "".obs;

  @override
  void onInit() async {
    super.onInit();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    currentVersion.value = packageInfo.version;
    print('package version : $currentVersion');
  }

  Future<void> checkLatestVersion() async {
    const String repositoryOwner = "mayurbaniya";
    const String repositoryName = "asteronX";
    const String url =
        "https://api.github.com/repos/$repositoryOwner/$repositoryName/releases/latest";
    final Uri uri = Uri.parse(url);

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final tagName = data['tag_name'];
        // assigning tagName to oldVersion
        oldVersion.value = tagName;
        final assets = data['assets'] as List<dynamic>;
        for (final asset in assets) {
          final assetDownloadURL = asset['browser_download_url'];
          newAppURL.value = assetDownloadURL;
        }
        if (oldVersion.value != currentVersion.value) {
          checkUpdate();
        }
      }
    } catch (e) {
      showCustomCupertinoAlertDialog(
        title: 'Oops!!',
        message: 'Something went wrong while checking for the update',
        isForced: false,
      );
    }
  }

  void checkUpdate() {
    String updateMessage = RemoteData().updateMessage;
    showCustomCupertinoAlertDialog(
      title: 'Update Required',
      message: updateMessage,
      actionButtonText: 'Download',
      onActionPressed: () {
        launchUrl(Uri.parse(newAppURL.value),
            mode: LaunchMode.externalApplication);
      },
      isForced: true,
    );
  }
}
