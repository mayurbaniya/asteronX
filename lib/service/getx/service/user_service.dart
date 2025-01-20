import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:asteron_x/service/models/user_model.dart';
import 'package:asteron_x/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static Future<UserModel?> fetchUser(String email, String password) async {
    // await Future.delayed(Duration(seconds: 2));
    final request = {
      "email": email,
      "password": password,
    };

    final Uri url = Uri.parse(url_signIn);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(request),
      );

      print("Response Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);

        final String status = responseBody['status'] ?? 'ERROR';
        final String message = responseBody['msg'] ?? 'An error occurred';

        switch (status) {
          case 'SUCCESS':
            return UserModel.fromJson(responseBody['data']);
          case 'INVALID_PASSWORD':
          case 'INVALID_EMAIL':
          case 'USER_NOT_FOUND':
          case 'ERROR':
            throw Exception(message); // Include server message in Exception
          default:
            throw Exception('Unknown error: $status');
        }
      } else {
        throw Exception('Unexpected HTTP response: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
      rethrow;
    }
  }

  static Future<UserModel?> getUserDataFromSF() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool loggedIn = prefs.getBool('loggedIn') ?? false;
    print('fetched user data from sf');

    if (!loggedIn) {
      print('No user data found');
      return null;
    }

    // Retrieve stored user data
    int id = prefs.getInt('userID') ?? 0;
    String name = prefs.getString('name') ?? '';
    String email = prefs.getString('email') ?? '';
    int pinCode = prefs.getInt('pincode') ?? 0;
    String phone = prefs.getString('phone') ?? '';
    String createdStr = prefs.getString('created') ?? '';
    String city = prefs.getString('city') ?? '';
    int age = prefs.getInt('age') ?? 0;

    DateTime? created =
        createdStr.isNotEmpty ? DateTime.tryParse(createdStr) : null;

    return UserModel(
      id: id,
      name: name,
      email: email,
      pinCode: pinCode,
      phone: phone,
      created: created,
      city: city,
      age: age,
    );
  }
}
