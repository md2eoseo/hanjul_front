import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const String TOKEN = "token";
final storage = new FlutterSecureStorage();

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "MY",
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              fontFamily: "Nanum Myeongjo"),
        ),
      ),
      body: ElevatedButton(
        child: Text("로그아웃"),
        onPressed: () async {
          await storage.delete(key: TOKEN);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('로그아웃!')));
        },
      ),
    );
  }
}
