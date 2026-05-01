import 'dart:convert';

import 'package:asteron_x/service/getx/helper/manage_auth.dart';
import 'package:asteron_x/service/local_storage/shared_prefs_service.dart';
import 'package:asteron_x/utils/constants.dart';
import 'package:http/http.dart' as http;

/// Singleton HTTP client that:
///  - attaches `Authorization: Bearer <accessToken>` to every request
///  - on a 401, calls `/user/auth/refresh-token`, retries the request once
///  - if refresh also fails, clears local auth and bounces to login
class ApiClient {
  ApiClient._internal();
  static final ApiClient _instance = ApiClient._internal();
  static ApiClient get instance => _instance;

  Future<Map<String, String>> authHeaders({bool json = true}) async {
    final String? token = await SharedPrefService.getAccessToken();
    return {
      if (json) 'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<http.Response> _send(
    Future<http.Response> Function(Map<String, String> headers) sendFn,
  ) async {
    final headers = await authHeaders();
    http.Response response = await sendFn(headers);

    if (response.statusCode == 401) {
      print('ApiClient: 401 received, attempting refresh');
      final refreshed = await _refreshToken();
      if (refreshed) {
        final retryHeaders = await authHeaders();
        response = await sendFn(retryHeaders);
      } else {
        print('ApiClient: refresh failed, logging out');
        await ManageAuth.logout();
        throw Exception('Session expired. Please login again.');
      }
    }

    return response;
  }

  Future<bool> _refreshToken() async {
    final String? refreshToken = await SharedPrefService.getRefreshToken();
    if (refreshToken == null) return false;

    try {
      final response = await http.post(
        Uri.parse(url_refreshToken),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'refreshToken': refreshToken}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);
        if (body['status'] == 'SUCCESS' && body['data'] != null) {
          final data = body['data'];
          final String? newAccess = data['accessToken'];
          final String newRefresh =
              (data['refreshToken'] as String?) ?? refreshToken;
          if (newAccess != null) {
            await SharedPrefService.saveTokens(newAccess, newRefresh);
            return true;
          }
        }
      }
    } catch (e) {
      print('ApiClient: error refreshing token: $e');
    }
    return false;
  }

  Future<http.Response> get(Uri url) {
    return _send((h) => http.get(url, headers: h));
  }

  Future<http.Response> post(Uri url, {Object? body}) {
    return _send((h) => http.post(url, headers: h, body: body));
  }

  Future<http.Response> put(Uri url, {Object? body}) {
    return _send((h) => http.put(url, headers: h, body: body));
  }

  Future<http.Response> delete(Uri url, {Object? body}) {
    return _send((h) => http.delete(url, headers: h, body: body));
  }

  /// Multipart helpers — same Bearer/refresh/retry contract as JSON requests.
  Future<http.Response> sendMultipart(http.MultipartRequest Function() build) {
    return _send((h) async {
      final req = build();
      // Don't set Content-Type — multipart sets its own with boundary.
      final tokenHeader = Map<String, String>.from(h)..remove('Content-Type');
      req.headers.addAll(tokenHeader);
      final streamed = await req.send();
      return http.Response.fromStream(streamed);
    });
  }
}
