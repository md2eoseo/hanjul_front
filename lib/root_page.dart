import 'dart:convert';

import "package:flutter/material.dart";
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hanjul_front/login_page.dart';
import "package:hanjul_front/tab_page.dart";

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

  void _checkLoggedInUser() {
    const String LOGGED_IN_USER = "loggedInUser";
    final storage = new FlutterSecureStorage();
    Future<String> _getLoggedInUser = new Future(() async {
      // await storage.write(key: LOGGED_IN_USER, value: '{ "id":1 }');
      // await storage.deleteAll();
      return storage.read(key: LOGGED_IN_USER);
    });

    _getLoggedInUser.then((data) {
      // storage에 loggedInUser key가 없는 경우
      if (data == null) {
        print("There is no loggedInUser!!!");
        setState(() {
          _loggedIn = false;
        });
      }

      // storage에 loggedInUser key가 있는 경우
      Map loggedInUser = json.decode(data);
      // id key가 없는 경우
      if (loggedInUser['id'] == null) {
        print("There is no valid ID!!!");
        setState(() {
          _loggedIn = false;
        });
      }
      // id key가 있는 경우
      else {
        print("loggedInUser['id'] : ${loggedInUser['id']}");
        setState(() {
          _loggedIn = true;
        });
      }
    });
  }
}
