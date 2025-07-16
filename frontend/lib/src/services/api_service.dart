import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static String? _jwt;

  static void setJwt(String? token) {
    _jwt = token;
  }

  static String? getJwt() {
    return _jwt;
  }

  static Map<String, String> _headers({Map<String, String>? extra}) {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (_jwt != null) headers['Authorization'] = 'Bearer $_jwt';
    if (extra != null) headers.addAll(extra);
    return headers;
  }

  static Future<http.Response> get(String url, {Map<String, String>? headers}) {
    return http.get(Uri.parse(url), headers: _headers(extra: headers));
  }

  static Future<http.Response> post(String url, {Object? body, Map<String, String>? headers}) {
    return http.post(Uri.parse(url), headers: _headers(extra: headers), body: jsonEncode(body));
  }

  static Future<http.Response> put(String url, {Object? body, Map<String, String>? headers}) {
    return http.put(Uri.parse(url), headers: _headers(extra: headers), body: jsonEncode(body));
  }

  static Future<http.Response> patch(String url, {Object? body, Map<String, String>? headers}) {
    return http.patch(Uri.parse(url), headers: _headers(extra: headers), body: jsonEncode(body));
  }
}
