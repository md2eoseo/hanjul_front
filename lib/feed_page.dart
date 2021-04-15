import 'package:flutter/material.dart';

String seeDayFeedQuery = """
  query seeDayFeed(\$lastId: Int) {
    seeDayFeed(lastId: \$lastId) {
      ok
      error
      posts {
        text
      }
    }
  }
""";

class FeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "한줄",
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              fontFamily: "Nanum Myeongjo"),
        ),
      ),
    );
  }
}
