import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hanjul_front/config.dart';

class MyPage extends StatefulWidget {
  const MyPage({this.onLoggedOut});
  final VoidCallback onLoggedOut;

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
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
          await Config.storage.delete(key: env['TOKEN']);
          widget.onLoggedOut();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('로그아웃!')));
        },
      ),
    );
  }
}
