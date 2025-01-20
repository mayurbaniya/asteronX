class RemoteData {
  static final RemoteData _instance = RemoteData._internal();

  String _baseURL = '';
  String _underMaintenence = '';
  String _adminEmail = '';

  // privacy related
  String _privacyOverview = '';
  String _privacyInformationStored = '';
  String _privacyObligations = '';
  String _privacyGrevience = '';

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

  // Privacy getters
  String get adminEmail => _adminEmail;
  String get privacyOverview => _privacyOverview;
  String get privacyInformationStored => _privacyInformationStored;
  String get privacyObligations => _privacyObligations;
  String get privacyGrevience => _privacyGrevience;

  // Existing getters
  String get baseURL => _baseURL;
  String get underMaintanence => _underMaintenence;
}
