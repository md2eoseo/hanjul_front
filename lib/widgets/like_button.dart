import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hanjul_front/mutations/toggle_like.dart';

class LikeButton extends StatefulWidget {
  LikeButton({
    Key key,
    this.postId,
    this.isLiked,
    this.likesCount,
  }) : super(key: key);
  final int postId;
  final bool isLiked;
  final int likesCount;

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
    return GraphQLConsumer(builder: (GraphQLClient client) {
      return Container(
        child: Mutation(
          options: MutationOptions(
            document: gql(toggleLike),
            update: (GraphQLDataProxy cache, QueryResult result) {
              return cache;
            },
            onCompleted: (dynamic resultData) async {
              if (!resultData['toggleLike']['ok']) {
                Get.snackbar(
                  "좋아요 오류",
                  "${resultData['toggleFollow']['error']}",
                );
              } else {
                Function _updateIsLikedCache = (int postId) {
                  final fragmentDoc = gql(
                    '''
                          fragment postSubset on Post {
                            id
                            likesCount
                            isLiked
                          }
                        ''',
                  );
                  var fragmentRequest = FragmentRequest(
                    fragment: Fragment(
                      document: fragmentDoc,
                    ),
                    idFields: {'__typename': 'Post', 'id': postId},
                  );
                  final data = client.readFragment(fragmentRequest);
                  client.writeFragment(fragmentRequest, data: {
                    'likesCount': data['isLiked']
                        ? data['likesCount'] - 1
                        : data['likesCount'] + 1,
                    'isLiked': !data['isLiked']
                  });
                };
                _updateIsLikedCache(widget.postId);
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
    });
  }
}
