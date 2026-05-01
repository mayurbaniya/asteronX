class RemoteData {
  static final RemoteData _instance = RemoteData._internal();

  String _baseURL = '';
  String _underMaintenence = '';
  String _adminEmail = '';
  String _adminPhone = '';

  // privacy related
  String _privacyOverview = '';
  String _privacyInformationStored = '';
  String _privacyObligations = '';
  String _privacyGrevience = '';

  // update related — partner-app version + download URL come from
  // Remote Config so we don't have to ship a new build to bump them.
  String _updateMessage = '';
  String _partnerAppVersion = '';
  String _partnerAppDownloadUrl = '';

  RemoteData._internal();

  factory RemoteData() {
    return _instance;
  }

  void setBaseURL(String baseURL) {
    _baseURL = baseURL;
  }

  void setUnderMaintenence(String value) {
    _underMaintenence = value;
  }

  // Privacy setters
  void setAdminEmail(String email) {
    _adminEmail = email;
  }

  void setAdminPhone(String phone) {
    _adminPhone = phone;
  }

  void setPrivacyOverview(String overview) {
    _privacyOverview = overview;
  }

  void setPrivacyInformationStored(String information) {
    _privacyInformationStored = information;
  }

  void setPrivacyObligations(String obligations) {
    _privacyObligations = obligations;
  }

  void setPrivacyGrevience(String grevience) {
    _privacyGrevience = grevience;
  }

  void setUpdateMessage(String updateMessage) {
    _updateMessage = updateMessage;
  }

  void setPartnerAppVersion(String version) {
    _partnerAppVersion = version;
  }

  void setPartnerAppDownloadUrl(String url) {
    _partnerAppDownloadUrl = url;
  }

  // Privacy getters
  String get adminEmail => _adminEmail;
  String get adminPhone => _adminPhone;
  String get privacyOverview => _privacyOverview;
  String get privacyInformationStored => _privacyInformationStored;
  String get privacyObligations => _privacyObligations;
  String get privacyGrevience => _privacyGrevience;

  // update related
  String get updateMessage => _updateMessage;
  String get partnerAppVersion => _partnerAppVersion;
  String get partnerAppDownloadUrl => _partnerAppDownloadUrl;

  // Existing getters
  String get baseURL => _baseURL;
  String get underMaintanence => _underMaintenence;
}
