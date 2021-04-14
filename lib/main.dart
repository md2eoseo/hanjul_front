import 'package:flutter/material.dart';
import 'package:hanjul_front/root_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Color pointColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '한줄',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.grey[300],
        accentColor: pointColor,
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Colors.amber,
          contentTextStyle: TextStyle(fontSize: 20),
        ),
      ),
      home: Scaffold(
        body: RootPage(),
      ),
    );
  }
}
