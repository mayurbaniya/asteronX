import 'dart:convert';

import 'package:asteron_x/service/getx/controller/leads_controller.dart';
import 'package:asteron_x/service/models/leads_model.dart';
import 'package:asteron_x/utils/constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LeadsService {
  LeadsController leadsController = Get.put(LeadsController());

  static Future<MyLeadsModel?> fetchAllLeads(
      int prtID, int page, int size, String sortBy, String sortDir) async {
    try {
      final Uri url = Uri.parse(
          '${url_allLeads}?partnerID=$prtID&page=$page&size=$size&sortBy=$sortBy&sortDir=$sortDir');

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
            return MyLeadsModel.fromJson(responseBody['data']);
          case 'FAILED':
          case 'EMPTY':
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

  static Future<MyLeadsModel?> saveLead(
    int prtID,
    String name,
    String vehicle,
    String phone,
    String city,
    String finance,
    String notes,
  ) async {
    // Prepare the request payload
    final request = {
      "leadProviderID": prtID, // Include prtID in the request
      "clientName": name,
      "vehicle": vehicle,
      "phoneNumber": phone,
      "altPhoneNumber": "",
      "city": city,
      "isFinanceInterested": finance,
      "notes": notes,
    };
    final Uri url = Uri.parse(url_addNewLead);

    try {
      // Perform the HTTP POST request
      final response = await http.post(
        url,
        body: json.encode(request), // Convert the request map to a JSON string
        headers: {'Content-Type': 'application/json'},
      );

      // Check the HTTP response status code
      if (response.statusCode == 200) {
        // Parse the JSON response body
        final Map<String, dynamic> responseBody = json.decode(response.body);
        print('Response: $responseBody');

        // Check the status in the response body
        final String status = responseBody['status'] ?? 'ERROR';
        final String message = responseBody['msg'] ?? 'An error occurred';

        if (status == 'SUCCESS') {
          // Return the deserialized model on success
          return MyLeadsModel.fromJson(responseBody);
        } else {
          // Log the error for other statuses
          print('Error while saving lead: $message');
        }
      } else {
        // Handle unexpected HTTP response codes
        print('Unexpected HTTP response: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that occur
      print('Error occurred: $e');
    }

    // Return null in case of failure
    return null;
  }
}
