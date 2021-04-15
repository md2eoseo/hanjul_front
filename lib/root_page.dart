import "package:flutter/material.dart";
import 'package:hanjul_front/login_page.dart';
import "package:hanjul_front/tab_page.dart";
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String LOGGED_IN_USER = "loggedInUser";

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
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("token");
    if (token == null) {
      print("There is no loggedInUser!!!");
      setState(() {
        _loggedIn = false;
      });
      return;
    } else {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      // decodedToken에 id가 없는 경우
      if (decodedToken['id'] == null) {
        print("There is no valid ID!!!");
        setState(() {
          _loggedIn = false;
        });
      } else {
        print("decodedToken['id'] : ${decodedToken['id']}");
        setState(() {
          _loggedIn = true;
        });
      }
    }
  }
}
