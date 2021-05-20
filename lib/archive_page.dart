import 'package:flutter/material.dart';
import 'package:hanjul_front/widgets/archive.dart';
import 'package:hanjul_front/writing_page.dart';

class ArchivePage extends StatefulWidget {
  @override
  _ArchivePageState createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.archive,
            size: 48,
          ),
          onPressed: () {
            _scrollController.animateTo(
              0,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          },
          padding: EdgeInsets.only(left: 8),
        ),
        title: Text(
          "아카이브",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontFamily: "Nanum Myeongjo",
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, size: 48),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WritingPage()),
              );
            },
            padding: EdgeInsets.only(right: 28),
          )
        ],
      ),
      body: Archive(scrollController: _scrollController),
    );
  }
}
