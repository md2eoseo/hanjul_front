import 'package:flutter/material.dart';
import 'package:hanjul_front/widgets/archive.dart';

class ArchivePage extends StatefulWidget {
  @override
  _ArchivePageState createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "아카이브",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontFamily: "Nanum Myeongjo",
          ),
        ),
      ),
      body: Archive(),
    );
  }
}
