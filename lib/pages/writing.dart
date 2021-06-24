import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hanjul_front/widgets/posting_button.dart';
import 'package:hanjul_front/widgets/todays_word.dart';

class WritingPage extends StatefulWidget {
  WritingPage({Key key, this.word}) : super(key: key);
  final Map<String, dynamic> word;

  @override
  _WritingPageState createState() => _WritingPageState();
}

class _WritingPageState extends State<WritingPage> {
  String _text;

  @override
  void initState() {
    _text = "";
    super.initState();
  }

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
            Get.back();
          },
          padding: EdgeInsets.only(left: 8),
        ),
        title: Text(
          "글쓰기",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [PostingButton(text: _text, word: widget.word)],
          )
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 18),
            TodaysWord(word: widget.word),
            Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  autocorrect: false,
                  maxLines: 8,
                  maxLength: 160,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  style: TextStyle(fontSize: 32),
                  decoration: InputDecoration.collapsed(
                    hintText: "글을 작성해주세요.",
                  ),
                  onChanged: (value) {
                    setState(() {
                      _text = value;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
