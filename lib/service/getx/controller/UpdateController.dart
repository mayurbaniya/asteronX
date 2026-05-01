import 'package:asteron_x/service/firebase/remote_data.dart';
import 'package:asteron_x/widgets/x_dialog.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Update check driven by Firebase Remote Config.
///
/// Two keys:
///  - `PRT_APP_VER`            → e.g. "1.1.1" (the version we want users on)
///  - `PRT_APP_DOWNLOAD_URL`   → direct download URL (any host — typically a
///                                GitHub release asset).
///
/// Comparison is dotted-numeric semver (1.0.10 > 1.0.9). Missing or
/// non-numeric values are treated as "no update needed" so a misconfigured
/// remote value can never lock users out.
class UpdateController extends GetxController {
  RxString currentVersion = "".obs;

  @override
  void onInit() {
    super.onInit();
    _loadCurrentVersion();
  }

  Future<void> _loadCurrentVersion() async {
    final info = await PackageInfo.fromPlatform();
    currentVersion.value = info.version;
  }

  /// Read both values from RemoteData (already fetched at app launch by
  /// [RemoteConfigService]) and surface the update dialog if needed.
  Future<void> checkLatestVersion() async {
    if (currentVersion.value.isEmpty) {
      await _loadCurrentVersion();
    }

    final remote = RemoteData().partnerAppVersion.trim();
    final current = currentVersion.value.trim();

    if (remote.isEmpty) return;
    if (!_isOutdated(current, remote)) return;

    _showUpdateDialog();
  }

  void _showUpdateDialog() {
    final message = RemoteData().updateMessage.isNotEmpty
        ? RemoteData().updateMessage
        : 'A newer version of the Asteron Partner app is available. '
            'Please update to keep using all features.';
    final downloadUrl = RemoteData().partnerAppDownloadUrl.trim();

    showCustomCupertinoAlertDialog(
      title: 'Update Required',
      message: message,
      actionButtonText: downloadUrl.isEmpty ? null : 'Download',
      onActionPressed: downloadUrl.isEmpty
          ? null
          : () => launchUrl(
                Uri.parse(downloadUrl),
                mode: LaunchMode.externalApplication,
              ),
      isForced: true,
    );
  }

  /// Returns true when [remote] is strictly greater than [current] using
  /// segment-by-segment numeric comparison. Bails out (returns false) on any
  /// parse failure or empty input — we never want a typo to block the user.
  bool _isOutdated(String current, String remote) {
    if (current.isEmpty || remote.isEmpty) return false;

    final cur = current.split('.').map(int.tryParse).toList();
    final rem = remote.split('.').map(int.tryParse).toList();
    if (cur.contains(null) || rem.contains(null)) return false;

    final maxLen = cur.length > rem.length ? cur.length : rem.length;
    for (int i = 0; i < maxLen; i++) {
      final c = i < cur.length ? cur[i]! : 0;
      final r = i < rem.length ? rem[i]! : 0;
      if (r > c) return true;
      if (r < c) return false;
    }
    return false; // equal versions
  }
}
