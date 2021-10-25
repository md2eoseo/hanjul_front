import 'dart:async';

import "package:universal_html/html.dart" as html;

import 'package:flutter/foundation.dart';
import 'package:hanjul_front/config/client.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

String getTodaysDate() {
  var now = DateTime.now();
  var formattedDate = "";
  formattedDate += now.year.toString().substring(2);
  formattedDate += now.month.toString().padLeft(2, '0');
  formattedDate += now.day.toString().padLeft(2, '0');
  return formattedDate;
}

FutureOr<String?> getToken() async {
  if (!kIsWeb) {
    return storage.read(key: 'TOKEN');
  }
  return html.window.localStorage['TOKEN'];
}

Future<int?> getLoggedInUserId() async {
  final String? token = await getToken();
  if (token == null) {
    return null;
  }
  final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
  if (decodedToken['id'] == null) {
    return null;
  }
  return decodedToken['id'];
}

void saveToken(String token) async {
  if (!kIsWeb) {
    await storage.write(key: 'TOKEN', value: token);
  } else {
    html.window.localStorage['TOKEN'] = token;
  }
}

void deleteToken() async {
  if (!kIsWeb) {
    await storage.delete(key: 'TOKEN');
  } else {
    html.window.localStorage.remove('TOKEN');
  }
}
