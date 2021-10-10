import 'package:flutter/material.dart';
import 'package:hanjul_front/widgets/day_feed.dart';
import 'package:hanjul_front/widgets/main_app_bar.dart';
import 'package:hanjul_front/widgets/write_post_button.dart';

class FeedPage extends StatefulWidget {
  FeedPage({Key? key, this.word}) : super(key: key);
  final word;

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        appBar: AppBar(),
        title: "피드",
        scrollController: _scrollController,
        iconButtons: [WritePostButton(word: widget.word)],
        centerTitle: false,
      ),
      body: DayFeed(scrollController: _scrollController, word: widget.word),
    );
  }
}
