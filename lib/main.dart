import 'package:flutter/material.dart';
import 'package:hanjul_front/root_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '한줄',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: RootPage(),
    );
  }
}
