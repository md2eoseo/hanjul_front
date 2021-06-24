import 'dart:async';
import 'package:hanjul_front/config/utils.dart';
import 'package:hanjul_front/splash.dart';
import "package:flutter/material.dart";
import 'package:hanjul_front/login_page.dart';
import "package:hanjul_front/tab_page.dart";

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  bool _splashLoading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    _checkLoggedInUser();
    _loadSplash();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _splashLoading
        ? Splash()
        : _isLoggedIn
            ? TabPage(onLoggedOut: _onLoggedOut)
            : LoginPage(onLoggedIn: _onLoggedIn);
  }

  Future<Timer> _loadSplash() async {
    return Timer(Duration(milliseconds: 1000), onDoneLoading);
  }

  void onDoneLoading() async {
    setState(() {
      _splashLoading = false;
    });
  }

  void _checkLoggedInUser() async {
    final String userId = await getLoggedInUserId();
    if (userId != null) {
      _onLoggedIn();
    }
  }

  void _onLoggedIn() async {
    setState(() {
      _isLoggedIn = true;
    });
  }

  void _onLoggedOut() async {
    setState(() {
      _isLoggedIn = false;
    });
  }
}
