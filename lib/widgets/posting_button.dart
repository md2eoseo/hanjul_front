import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hanjul_front/mutations/create_post.dart';

class PostingButton extends StatelessWidget {
  PostingButton({Key? key, this.text, this.word}) : super(key: key);
  final text;
  final word;

  @override
  Widget build(BuildContext context) {
    Function _checkText = () {
      if (text.contains(word['word'])) return true;
      for (final v in word['variation']) {
        if (text.contains(v)) return true;
      }
      return false;
    };
    return Mutation(
      options: MutationOptions(
        document: gql(createPost),
        update: (GraphQLDataProxy? cache, QueryResult? result) {
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
        RunMutation? runMutation,
        QueryResult? result,
      ) {
        return result!.isLoading
            ? Padding(
                padding: EdgeInsets.only(right: 18),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                ),
              )
            : IconButton(
                icon: Icon(Icons.check, size: 36, color: Colors.black),
                onPressed: () {
                  if (!_checkText()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('글에 오늘의 단어를 포함시켜주세요.'),
                          backgroundColor: Colors.red[200]),
                    );
                    return;
                  }
                  runMutation!({'wordId': word['id'], 'text': text.trim()});
                },
                padding: EdgeInsets.only(right: 28),
              );
      },
    );
  }
}
