import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:asteron_x/service/getx/helper/api_client.dart';
import 'package:asteron_x/service/models/PaymentModel.dart';
import 'package:asteron_x/utils/constants.dart';
import 'package:http_parser/http_parser.dart';

class PaymentService {
  static MediaType _resolveMediaType(File file) {
    final String fileExtension = file.path.split('.').last.toLowerCase();
    if (fileExtension == 'jpg' || fileExtension == 'jpeg') {
      return MediaType('image', 'jpeg');
    } else if (fileExtension == 'png') {
      return MediaType('image', 'png');
    } else {
      throw Exception(
          'Unsupported file format. Only JPG, JPEG, and PNG are allowed.');
    }
  }

  static Future<PaymentModel?> addPaymentDetails(
      int partnerID, String upiID, File qrCode) async {
    final Uri url = Uri.parse(url_addPaymentInfo);
    final MediaType mediaType = _resolveMediaType(qrCode);

    try {
      final response = await ApiClient.instance.sendMultipart(() {
        final req = http.MultipartRequest('POST', url);
        req.fields['partnerID'] = partnerID.toString();
        req.fields['upiID'] = upiID;
        req.files.add(http.MultipartFile.fromBytes(
          'file',
          qrCode.readAsBytesSync(),
          filename: qrCode.path.split(Platform.pathSeparator).last,
          contentType: mediaType,
        ));
        return req;
      });

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
    final MediaType mediaType = _resolveMediaType(qrCode);

    try {
      final response = await ApiClient.instance.sendMultipart(() {
        final req = http.MultipartRequest('PUT', url);
        req.fields['partnerID'] = partnerID.toString();
        req.fields['upiID'] = upiID;
        req.files.add(http.MultipartFile.fromBytes(
          'file',
          qrCode.readAsBytesSync(),
          filename: qrCode.path.split(Platform.pathSeparator).last,
          contentType: mediaType,
        ));
        return req;
      });

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
      final response = await ApiClient.instance.get(url);

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
