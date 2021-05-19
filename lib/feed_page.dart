import 'package:flutter/material.dart';
import 'package:hanjul_front/widgets/day_feed.dart';
import 'package:hanjul_front/writing_page.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.notes,
            size: 48,
          ),
          onPressed: () {},
          padding: EdgeInsets.only(left: 8),
        ),
        title: Text(
          "한줄",
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
      body: DayFeed(),
    );
  }
}
