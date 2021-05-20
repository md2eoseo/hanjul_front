import "package:universal_html/html.dart";

import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hanjul_front/config.dart';
import 'package:hanjul_front/login_page.dart';
import "package:hanjul_front/tab_page.dart";
import 'package:jwt_decoder/jwt_decoder.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    _checkLoggedInUser();
    super.initState();
  }

  void _onLoggedIn() {
    setState(() {
      _isLoggedIn = true;
    });
  }

  void _onLoggedOut() {
    setState(() {
      _isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoggedIn
        ? TabPage(onLoggedOut: _onLoggedOut)
        : LoginPage(onLoggedIn: _onLoggedIn);
  }

  void _checkLoggedInUser() async {
    final String token = !kIsWeb
        ? await Config.storage.read(key: env['TOKEN'])
        : window.localStorage['TOKEN'];
    if (token == null) {
      print("토큰이 없습니다!");
    } else {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      if (decodedToken['id'] == null) {
        print("토큰의 id가 유효하지 않습니다!");
      } else {
        print("로그인 사용자 id : ${decodedToken['id']}");
        _onLoggedIn();
      }
    }
  }
}
