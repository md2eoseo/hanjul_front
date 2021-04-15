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
  bool _loggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoggedInUser();
  }

  void _onLoggedIn() {
    setState(() {
      _loggedIn = true;
    });
  }

  void _onLoggedOut() {
    setState(() {
      _loggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loggedIn
        ? TabPage(onLoggedOut: _onLoggedOut)
        : LoginPage(onLoggedIn: _onLoggedIn);
  }

  void _checkLoggedInUser() async {
    final String token = await storage.read(key: env['TOKEN']);
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
