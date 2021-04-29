import 'package:flutter/material.dart';
import 'package:hanjul_front/widgets/day_feed.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "한줄",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontFamily: "Nanum Myeongjo",
          ),
        ),
      ),
      body: DayFeed(),
    );
  }
}
