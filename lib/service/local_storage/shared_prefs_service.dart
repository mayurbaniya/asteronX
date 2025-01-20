import 'dart:convert';
import 'package:asteron_x/service/getx/controller/payment_controller.dart';
import 'package:asteron_x/utils/constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:asteron_x/service/models/user_model.dart';
import 'package:asteron_x/service/models/leaderboard_model.dart';

class SharedPrefService {
  // Keys
  static const String _loggedInKey = 'loggedIn';
  static const String _userIDKey = 'userID';
  static const String _nameKey = 'name';
  static const String _emailKey = 'email';
  static const String _pincodeKey = 'pincode';
  static const String _phoneKey = 'phone';
  static const String _cityKey = 'city';
  static const String _createdKey = 'created';
  static const String _ageKey = 'age';

  static const String _leaderboardKey = 'leaderboardData';
  static const String _leaderboardTimestampKey = 'leaderboardTimestamp';

  // Store user data
  static Future<void> storeDada(UserModel user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, true);
    await prefs.setInt(_userIDKey, user.id ?? 0);
    await prefs.setString(_nameKey, user.name ?? '');
    await prefs.setString(_emailKey, user.email ?? '');
    await prefs.setInt(_pincodeKey, user.pinCode ?? 0);
    await prefs.setString(_phoneKey, user.phone ?? '');
    await prefs.setString(_cityKey, user.city ?? '');
    await prefs.setString(_createdKey, user.created.toString());
    await prefs.setInt(_ageKey, user.age ?? 0);

    print('User data saved to SharedPreferences');
  }

  // Remove user data (on logout)
  static Future<void> removeData() async {
    PaymentController paymentController = Get.put(PaymentController());

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, false);
    await prefs.remove(_userIDKey);
    await prefs.remove(_nameKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_pincodeKey);
    await prefs.remove(_phoneKey);
    await prefs.remove(_cityKey);
    await prefs.remove(_createdKey);
    await prefs.remove(_ageKey);
    await prefs.remove(paymentDetailsKey);
    // Clear leaderboard data
    await prefs.remove(_leaderboardKey);
    await prefs.remove(_leaderboardTimestampKey);

    paymentController.paymentDetails.value = null;

    print('All user data and leaderboard data cleared from SharedPreferences');
  }

  // Store leaderboard data
  static Future<void> storeLeaderBoardData(
      LeaderBoardModel leaderBoardData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String jsonData = jsonEncode(leaderBoardData.toJson());
    final int timestamp = DateTime.now().millisecondsSinceEpoch;

    await prefs.setString(_leaderboardKey, jsonData);
    await prefs.setInt(_leaderboardTimestampKey, timestamp);

    print('Leaderboard data saved to SharedPreferences');
  }

  // Fetch leaderboard data
  static Future<LeaderBoardModel?> getLeaderBoardData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jsonData = prefs.getString(_leaderboardKey);
    final int? timestamp = prefs.getInt(_leaderboardTimestampKey);

    if (jsonData != null && timestamp != null) {
      final int currentTime = DateTime.now().millisecondsSinceEpoch;
      const int fourHoursInMillis = 4 * 60 * 60 * 1000;

      if ((currentTime - timestamp) < fourHoursInMillis) {
        return LeaderBoardModel.fromJson(jsonDecode(jsonData));
      }
    }

    return null; // Data is either expired or not found
  }

  // Clear leaderboard data manually
  static Future<void> clearLeaderBoardData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_leaderboardKey);
    await prefs.remove(_leaderboardTimestampKey);

    print('Leaderboard data cleared from SharedPreferences');
  }
}
