import "package:flutter/material.dart";
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hanjul_front/login_page.dart';
import "package:hanjul_front/tab_page.dart";
import 'package:jwt_decoder/jwt_decoder.dart';

const String TOKEN = "token";
const String LOGGED_IN_USER = "loggedInUser";
final storage = new FlutterSecureStorage();

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

  @override
  Widget build(BuildContext context) {
    return _loggedIn ? TabPage() : LoginPage();
  }

  void _checkLoggedInUser() async {
    final String token = await storage.read(key: TOKEN);
    if (token == null) {
      print("토큰이 없습니다!");
      setState(() {
        _loggedIn = false;
      });
      return;
    } else {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      // decodedToken에 id가 없는 경우
      if (decodedToken['id'] == null) {
        print("토큰의 id가 유효하지 않습니다!");
        setState(() {
          _loggedIn = false;
        });
      } else {
        print("로그인 사용자 id : ${decodedToken['id']}");
        setState(() {
          _loggedIn = true;
        });
      }
    }
  }
}
