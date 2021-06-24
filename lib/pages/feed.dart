import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanjul_front/widgets/day_feed.dart';
import 'package:hanjul_front/pages/writing.dart';

class FeedPage extends StatefulWidget {
  FeedPage({Key key, this.word}) : super(key: key);
  final word;

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: TextButton(
          child: Text(
            "피드",
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
      body: DayFeed(scrollController: _scrollController, word: widget.word),
    );
  }
}
