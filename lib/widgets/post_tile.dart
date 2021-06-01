import 'package:flutter/material.dart';
import 'package:hanjul_front/widgets/like_button.dart';

class PostTile extends StatefulWidget {
  PostTile({
    Key key,
    this.post,
    this.updateIsLikedCache,
  }) : super(key: key);
  final Map post;
  final Function updateIsLikedCache;

  @override
  _PostTileState createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Container(
        padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.post['text'],
              style: TextStyle(
                fontSize: 28,
              ),
            ),
            SizedBox(height: 24),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.post['author'] != null)
                    Row(
                      children: [
                        Icon(Icons.account_circle),
                        SizedBox(width: 8),
                        Text(
                          widget.post['author']['username'],
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  Row(
                    children: [
                      LikeButton(
                        postId: widget.post['id'],
                        isLiked: widget.post['isLiked'],
                        likesCount: widget.post['likesCount'],
                        updateIsLikedCache: widget.updateIsLikedCache,
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
