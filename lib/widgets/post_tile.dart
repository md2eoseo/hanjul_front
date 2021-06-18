import 'package:flutter/material.dart';
import 'package:hanjul_front/widgets/like_button.dart';
import 'package:hanjul_front/widgets/user_button.dart';

class PostTile extends StatefulWidget {
  PostTile({
    Key key,
    this.post,
  }) : super(key: key);
  final Map post;

  @override
  _PostTileState createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Container(
        padding: EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.post['text'],
              style: TextStyle(
                fontSize: 28,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 12),
              height: 48,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.post['author'] != null
                      ? UserButton(
                          authorName: widget.post['author']['username'],
                          authorAvatar: widget.post['author']['avatar'],
                        )
                      : SizedBox(),
                  LikeButton(
                    postId: widget.post['id'],
                    isLiked: widget.post['isLiked'],
                    likesCount: widget.post['likesCount'],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
