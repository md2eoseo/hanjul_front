import 'package:flutter/material.dart';

class WritingPage extends StatefulWidget {
  @override
  _WritingPageState createState() => _WritingPageState();
}

class _WritingPageState extends State<WritingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 48,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          padding: EdgeInsets.only(left: 8),
        ),
        title: Text(
          "글쓰기",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontFamily: "Nanum Myeongjo",
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check, size: 48),
            onPressed: () {
              // TODO: createPost Mutation
            },
            padding: EdgeInsets.only(right: 28),
          )
        ],
      ),
    );
  }
}
