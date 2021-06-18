import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanjul_front/widgets/archive.dart';
import 'package:hanjul_front/writing_page.dart';

class ArchivePage extends StatefulWidget {
  ArchivePage({Key key, this.word}) : super(key: key);
  final word;

  @override
  _ArchivePageState createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: TextButton(
          child: Text(
            "아카이브",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          onPressed: () {
            _scrollController.animateTo(
              0,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, size: 48),
            onPressed: () {
              Get.to(
                () => WritingPage(word: widget.word),
                transition: Transition.rightToLeft,
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
