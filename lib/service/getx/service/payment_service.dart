import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:asteron_x/service/models/PaymentModel.dart';
import 'package:asteron_x/utils/constants.dart';
import 'package:http_parser/http_parser.dart';

class PaymentService {
  static Future<PaymentModel?> addPaymentDetails(
      int partnerID, String upiID, File qrCode) async {
    final Uri url = Uri.parse(url_addPaymentInfo);

    try {
      final request = http.MultipartRequest('POST', url);

      // Add fields
      request.fields['partnerID'] = partnerID.toString();
      request.fields['upiID'] = upiID;

      // Get file extension
      String fileExtension = qrCode.path.split('.').last.toLowerCase();

      // Determine the content type
      MediaType? mediaType;
      if (fileExtension == 'jpg' || fileExtension == 'jpeg') {
        mediaType = MediaType('image', 'jpeg');
      } else if (fileExtension == 'png') {
        mediaType = MediaType('image', 'png');
      } else {
        throw Exception(
            'Unsupported file format. Only JPG, JPEG, and PNG are allowed.');
      }

      // Add file
      request.files.add(
        await http.MultipartFile.fromPath(
          'file', // Key as expected by the server
          qrCode.path,
          contentType: mediaType,
        ),
      );

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("Response Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);

        final String status = responseBody['status'] ?? 'ERROR';
        final String message = responseBody['msg'] ?? 'An error occurred';

        if (status == 'SUCCESS') {
          return PaymentModel.fromJson(responseBody['data']);
        } else {
          throw Exception(message);
        }
      } else {
        throw Exception('Unexpected HTTP response: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
      rethrow;
    }
  }

  static Future<PaymentModel?> updatePaymentDetails(
      int partnerID, String upiID, File qrCode) async {
    final Uri url = Uri.parse(url_updatePaymentInfo);

    try {
      final request = http.MultipartRequest('PUT', url);

      // Add fields
      request.fields['partnerID'] = partnerID.toString();
      request.fields['upiID'] = upiID;

      // Get file extension
      String fileExtension = qrCode.path.split('.').last.toLowerCase();

      // Determine the content type
      MediaType? mediaType;
      if (fileExtension == 'jpg' || fileExtension == 'jpeg') {
        mediaType = MediaType('image', 'jpeg');
      } else if (fileExtension == 'png') {
        mediaType = MediaType('image', 'png');
      } else {
        throw Exception(
            'Unsupported file format. Only JPG, JPEG, and PNG are allowed.');
      }

      // Add file
      request.files.add(
        await http.MultipartFile.fromPath(
          'file', // Key as expected by the server
          qrCode.path,
          contentType: mediaType,
        ),
      );

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("Response Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);

        final String status = responseBody['status'] ?? 'ERROR';
        final String message = responseBody['msg'] ?? 'An error occurred';

        if (status == 'SUCCESS') {
          return PaymentModel.fromJson(responseBody['data']);
        } else {
          throw Exception(message);
        }
      } else {
        throw Exception('Unexpected HTTP response: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
      rethrow;
    }
  }

  static Future<PaymentModel?> getPaymentDetails(int partnerID) async {
    final Uri url = Uri.parse('${url_getPaymentInfo}?partnerID=$partnerID');

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
            return PaymentModel.fromJson(responseBody);
          case 'USER_NOT_FOUND':
          case 'NOT_FOUND':
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
