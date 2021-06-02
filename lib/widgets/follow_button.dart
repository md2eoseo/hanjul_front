import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

String toggleFollowMutation = """
  mutation toggleFollow(\$username: String!) {
    toggleFollow(username: \$username) {
      ok
      error
      follow
    }
  }
""";

class FollowButton extends StatefulWidget {
  FollowButton({
    Key key,
    this.username,
    this.isFollowers,
    this.isFollowing,
    this.width,
  });
  final username;
  final isFollowers;
  final isFollowing;
  final width;

  @override
  _FollowButtonState createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  bool _followingState = false;

  @override
  void initState() {
    _followingState = widget.isFollowing;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            width: widget.width,
            child: Mutation(
              options: MutationOptions(
                document: gql(toggleFollowMutation),
                update: (GraphQLDataProxy cache, QueryResult result) {
                  return cache;
                },
                onCompleted: (dynamic resultData) async {
                  if (!resultData['toggleFollow']['ok']) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text("${resultData['toggleFollow']['error']}")));
                  } else {
                    setState(() {
                      _followingState = resultData['toggleFollow']['follow'];
                    });
                  }
                },
              ),
              builder: (
                RunMutation runMutation,
                QueryResult result,
              ) {
                return ElevatedButton(
                  onPressed: () {
                    if (result.isLoading) return;
                    runMutation({'username': widget.username});
                  },
                  style: _followingState
                      ? ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              side: BorderSide(color: Colors.black, width: 2.0),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.grey[100]),
                        )
                      : ButtonStyle(),
                  child: Text(
                    _followingState
                        ? "팔로잉"
                        : widget.isFollowers
                            ? "맞팔로우"
                            : "팔로우",
                    style: _followingState
                        ? TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )
                        : TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
