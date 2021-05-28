import 'package:flutter/material.dart';
import 'package:hanjul_front/widgets/day_feed.dart';
import 'package:hanjul_front/writing_page.dart';

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
        leading: IconButton(
          icon: Icon(
            Icons.notes,
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
          "한줄",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, size: 48),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WritingPage(word: widget.word)),
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
