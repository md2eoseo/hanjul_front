import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

String toggleLikeMutation = """
  mutation toggleLike(\$postId: Int!) {
    toggleLike(postId: \$postId) {
      ok
      error
      like
    }
  }
""";

class LikeButton extends StatefulWidget {
  LikeButton(
      {Key key,
      this.postId,
      this.isLiked,
      this.likesCount,
      this.updateIsLikedCache})
      : super(key: key);
  final int postId;
  final bool isLiked;
  final int likesCount;
  final Function updateIsLikedCache;

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool _isLiked;
  int _likesCount;

  @override
  void initState() {
    _isLiked = widget.isLiked;
    _likesCount = widget.likesCount;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Mutation(
        options: MutationOptions(
          document: gql(toggleLikeMutation),
          update: (GraphQLDataProxy cache, QueryResult result) {
            return cache;
          },
          onCompleted: (dynamic resultData) async {
            if (!resultData['toggleLike']['ok']) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("${resultData['toggleLike']['error']}")));
            } else {
              widget.updateIsLikedCache(widget.postId);
            }
          },
        ),
        builder: (
          RunMutation toggleLike,
          QueryResult result,
        ) {
          return Row(
            children: [
              Text(
                '$_likesCount',
                style: TextStyle(fontSize: 22),
              ),
              SizedBox(width: 4),
              IconButton(
                onPressed: () {
                  toggleLike({'postId': widget.postId});
                  setState(() {
                    if (_isLiked) {
                      _likesCount -= 1;
                    } else {
                      _likesCount += 1;
                    }
                    _isLiked = !_isLiked;
                  });
                },
                icon: Icon(
                  Icons.favorite,
                  color: _isLiked ? Colors.red[800] : Colors.grey,
                  size: 32,
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
