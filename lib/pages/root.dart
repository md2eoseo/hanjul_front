import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:hanjul_front/config/utils.dart';
import 'package:hanjul_front/pages/splash.dart';
import "package:flutter/material.dart";
import 'package:hanjul_front/pages/login.dart';
import 'package:hanjul_front/pages/tab.dart';

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
    return kIsWeb
        ? _isLoggedIn
            ? TabPage(onLoggedOut: _onLoggedOut)
            : LoginPage(onLoggedIn: _onLoggedIn)
        : _splashLoading
            ? SplashPage()
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
    final int userId = await getLoggedInUserId();
    if (userId != null) {
      _onLoggedIn();
    }
  }

  void _onLoggedIn() async {
    setState(() {
      _isLoggedIn = true;
    });
  }

  void _onLoggedOut() {
    deleteToken();
    setState(() {
      _isLoggedIn = false;
    });
  }
}
