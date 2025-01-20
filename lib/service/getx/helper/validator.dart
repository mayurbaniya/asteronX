class Validation {
  static bool isValidEmail(String email) {
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return false;
    }
    return true;
  }

  static bool isValidPass(String password) {
    if (password.length < 6) {
      return false;
    }
    return true;
  }

  static bool isEmpty(String query) {
    if (query.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  static bool isValidUPI(String query) {
    RegExp regExp = RegExp(r'^[a-zA-Z0-9.\-_]{2,256}@[a-zA-Z]{2,64}$');
    return regExp.hasMatch(query);
  }

  static bool isValidName(String query) {
    RegExp regExp = RegExp(r'^[A-Za-z]+( [A-Za-z]+){0,2}$');
    return regExp.hasMatch(query);
  }

  static bool isValidPhone(String phone) {
    if (!RegExp(r'^(?:\+91|91)?[789]\d{9}$').hasMatch(phone)) {
      return false;
    }
    return true;
  }

  static bool isVehicleNameValid(String vehicleName) {
    if (vehicleName.length < 3 || vehicleName.length > 20) {
      return false;
    }
    return true;
  }

  static bool isFinanceValid(String finance) {
    if (finance.length < 3 || finance.length > 20) {
      return false;
    }
    return true;
  }

  static bool isNotesValid(String notes) {
    if (notes.length < 3 || notes.length > 100) {
      return false;
    }
    return true;
  }
}
