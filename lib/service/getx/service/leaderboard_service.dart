import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:asteron_x/service/models/leaderboard_model.dart';
import 'package:asteron_x/utils/constants.dart';

class LeaderboardService {
  static Future<LeaderBoardModel?> fetchLeaderBoardData(int prtID) async {
    final Uri url = Uri.parse('${url_leaderBoard}?leadProviderId=$prtID');

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      print("Response Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);

        final String status = responseBody['status'] ?? 'ERROR';
        final String message = responseBody['msg'] ?? 'An error occurred';

        switch (status) {
          case 'SUCCESS':
            return LeaderBoardModel.fromJson(responseBody['data']);
          case 'USER_NOT_FOUND':
          case 'ERROR':
            throw Exception(message);
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
}
