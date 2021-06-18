import "package:universal_html/html.dart" as html;

import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:hanjul_front/client.dart';
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

  @override
  Widget build(BuildContext context) {
    return _isLoggedIn
        ? TabPage(onLoggedOut: _onLoggedOut)
        : LoginPage(onLoggedIn: _onLoggedIn);
  }

  void _checkLoggedInUser() async {
    final String token = await _getToken();
    if (token != null) {
      final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      if (decodedToken['id'] != null) {
        _onLoggedIn(token);
      }
    }
  }

  Future<String> _getToken() async {
    final String token = !kIsWeb
        ? await storage.read(key: 'TOKEN')
        : html.window.localStorage['TOKEN'];
    return token;
  }

  void _onLoggedIn(String token) async {
    if (!kIsWeb) {
      await storage.write(key: 'TOKEN', value: token);
    } else {
      html.window.localStorage['TOKEN'] = token;
    }
    setState(() {
      _isLoggedIn = true;
    });
  }

  void _onLoggedOut() async {
    if (!kIsWeb) {
      await storage.delete(key: 'TOKEN');
    } else {
      html.window.localStorage.remove('TOKEN');
    }
    setState(() {
      _isLoggedIn = false;
    });
  }
}
