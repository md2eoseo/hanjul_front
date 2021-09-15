import 'package:flutter/material.dart';
import 'package:hanjul_front/widgets/archive.dart';
import 'package:hanjul_front/widgets/main_app_bar.dart';
import 'package:hanjul_front/widgets/write_post_button.dart';

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
      appBar: MainAppBar(
        appBar: AppBar(),
        title: "아카이브",
        scrollController: _scrollController,
        iconButtons: [WritePostButton(word: widget.word)],
        centerTitle: false,
      ),
      body: Archive(scrollController: _scrollController),
    );
  }
}
