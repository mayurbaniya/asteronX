import 'package:flutter/foundation.dart';

/// Build-time environment for the partner app. Picks which Firebase Remote
/// Config keys we read for the backend URL (and any other env-scoped values).
enum AppEnvironment {
  /// Local dev / debug builds. Reads `PRT_URL_TEST`.
  test,

  /// Internal / beta testing. Reads `PRT_URL_UAT`.
  uat,

  /// Play Store / public release. Reads `PRT_URL_PROD`.
  production,
}

/// Single source of truth for the active environment.
///
/// Update [_releaseEnvironment] before cutting a release build:
///   - `production` for Play Store / public APK
///   - `uat` for internal testing builds
///
/// Debug builds always run as [AppEnvironment.uat] regardless of the
/// `_releaseEnvironment` value, so day-to-day `flutter run` always hits TEST.
class EnvironmentConfig {
  // IMPORTANT: change this for release builds before `flutter build apk`.
  static const AppEnvironment _releaseEnvironment = AppEnvironment.production;

  /// Resolved environment for this build.
  static AppEnvironment get current {
    if (kDebugMode) return AppEnvironment.test;
    return _releaseEnvironment;
  }

  /// Short human-readable name (used by the in-app environment badge).
  static String get environmentName {
    switch (current) {
      case AppEnvironment.test:
        return 'TEST';
      case AppEnvironment.uat:
        return 'UAT';
      case AppEnvironment.production:
        return 'PRODUCTION';
    }
  }

  /// Remote Config key the partner app reads its backend URL from.
  static String get baseUrlKey {
    switch (current) {
      case AppEnvironment.test:
        return 'PRT_URL_TEST';
      case AppEnvironment.uat:
        return 'PRT_URL_UAT';
      case AppEnvironment.production:
        return 'PRT_URL_PROD';
    }
  }

  /// Remote Config key for the target version this build should ship to.
  /// Per-env so a UAT beta target doesn't nag prod users (and vice versa).
  static String get versionKey {
    switch (current) {
      case AppEnvironment.test:
        return 'PRT_APP_VER_TEST';
      case AppEnvironment.uat:
        return 'PRT_APP_VER_UAT';
      case AppEnvironment.production:
        return 'PRT_APP_VER_PROD';
    }
  }

  /// Remote Config key for the APK / install URL surfaced in the update
  /// dialog. Typically a GitHub release asset for test/uat and the Play
  /// Store URL for production.
  static String get downloadUrlKey {
    switch (current) {
      case AppEnvironment.test:
        return 'PRT_APP_DOWNLOAD_URL_TEST';
      case AppEnvironment.uat:
        return 'PRT_APP_DOWNLOAD_URL_UAT';
      case AppEnvironment.production:
        return 'PRT_APP_DOWNLOAD_URL_PROD';
    }
  }

  static bool get isDebug => kDebugMode;
  static bool get isRelease => kReleaseMode;
  static bool get isTest => current == AppEnvironment.test;
  static bool get isUat => current == AppEnvironment.uat;
  static bool get isProduction => current == AppEnvironment.production;
}
