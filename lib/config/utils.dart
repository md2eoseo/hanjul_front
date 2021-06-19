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

Future<String> getToken() async =>
    !kIsWeb ? storage.read(key: 'TOKEN') : html.window.localStorage['TOKEN'];

getLoggedInUserId() async {
  final String token = await getToken();
  if (token != null) {
    final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    if (decodedToken['id'] != null) {
      return decodedToken['id'];
    }
  }
}
