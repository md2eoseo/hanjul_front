import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hanjul_front/widgets/todays_word.dart';

String createPostMutation = """
  mutation createPost(\$wordId: Int!, \$text: String!) {
    createPost(wordId: \$wordId, text: \$text) {
      ok
      error
    }
  }
""";

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
    Function _checkText = () {
      if (_text.contains(widget.word['word'])) return true;
      for (final v in widget.word['variation']) {
        if (_text.contains(v)) return true;
      }
      return false;
    };
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
          Mutation(
            options: MutationOptions(
              document: gql(createPostMutation),
              update: (GraphQLDataProxy cache, QueryResult result) {
                return cache;
              },
              onCompleted: (dynamic resultData) {
                if (resultData['createPost']['ok']) {
                  Get.back();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('글 작성에 실패했습니다.'),
                        backgroundColor: Colors.red[200]),
                  );
                }
              },
            ),
            builder: (
              RunMutation runMutation,
              QueryResult result,
            ) {
              return IconButton(
                icon: Icon(Icons.check, size: 48),
                onPressed: () {
                  if (!_checkText()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('글에 오늘의 단어를 포함시켜주세요.'),
                          backgroundColor: Colors.red[200]),
                    );
                    return;
                  }
                  runMutation(
                      {'wordId': widget.word['id'], 'text': _text.trim()});
                },
                padding: EdgeInsets.only(right: 28),
              );
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 24),
            TodaysWord(word: widget.word),
            SizedBox(height: 24),
            Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  autocorrect: false,
                  maxLines: 8,
                  maxLength: 160,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  style: TextStyle(fontSize: 36),
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
