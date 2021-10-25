import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hanjul_front/config/client.dart';
import 'package:hanjul_front/config/utils.dart';
import 'package:hanjul_front/mutations/delete_post.dart';
import 'package:hanjul_front/widgets/like_button.dart';
import 'package:hanjul_front/widgets/user_button.dart';

class PostTile extends StatefulWidget {
  PostTile({
    Key? key,
    this.post,
  }) : super(key: key);
  final Map? post;

  @override
  _PostTileState createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  _showDeletePostDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("글을 삭제하시겠습니까?"),
          content: new Text("글 정보가 사라집니다!"),
          actions: <Widget>[
            new TextButton(
              child: new Text("아니오"),
              onPressed: () {
                Get.back();
              },
            ),
            new TextButton(
              child: new Text("예"),
              onPressed: () async {
                Get.back();

                final MutationOptions options = MutationOptions(
                  document: gql(deletePost),
                  variables: <String, dynamic>{
                    'id': widget.post?['id'],
                  },
                );

                final QueryResult result = await client.value.mutate(options);

                if (result.hasException) {
                  Get.snackbar("글을 삭제 중에 오류가 발생했습니다.", "");
                  return;
                }

                final bool success = result.data?['deletePost']['ok'];

                if (success) {
                  Get.snackbar("글이 삭제되었습니다.", "");
                  return;
                } else {
                  Get.snackbar("글을 삭제 중에 오류가 발생했습니다.", "");
                  return;
                }
              },
            ),
          ],
        );
      },
    );
  }

  _showBlameDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("글을 신고하시겠습니까?"),
          content: new Text("부적절한 글은 신고해주세요."),
          actions: <Widget>[
            new TextButton(
              child: new Text("아니오"),
              onPressed: () {
                Get.back();
              },
            ),
            new TextButton(
              child: new Text("예"),
              onPressed: () async {
                Get.back();
                Get.snackbar("글을 신고했습니다.", "");
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        onLongPress: () async {
          if (widget.post?['authorId'] == await getLoggedInUserId()) {
            _showDeletePostDialog();
          } else {
            _showBlameDialog();
          }
        },
        title: Container(
          padding: EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  widget.post?['text'],
                  style: TextStyle(
                    fontSize: 28,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 12),
                height: 48,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.post?['author'] != null
                        ? UserButton(
                            authorName: widget.post?['author']['username'],
                            authorAvatar: widget.post?['author']['avatar'],
                          )
                        : SizedBox(),
                    LikeButton(
                      postId: widget.post?['id'],
                      isLiked: widget.post?['isLiked'],
                      likesCount: widget.post?['likesCount'],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
