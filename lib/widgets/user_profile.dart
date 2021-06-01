import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hanjul_front/widgets/user_profile_top_info.dart';

String seeProfileQuery = """
  query seeProfile(\$username: String!) {
    seeProfile(username: \$username) {
      ok
      error
      user {
        id
        firstName
        lastName
        username
        bio
        avatar
        totalPosts
        totalFollowers
        totalFollowing
        isMe
        isFollowers
        isFollowing
      }
    }
  }
""";

class UserProfile extends StatefulWidget {
  UserProfile({Key key, this.username, this.onLoggedOut}) : super(key: key);
  final String username;
  final onLoggedOut;

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return GraphQLConsumer(
      builder: (GraphQLClient client) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.username,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              if (widget.onLoggedOut != null)
                IconButton(
                  icon: Icon(Icons.logout, size: 48),
                  onPressed: () async {
                    widget.onLoggedOut();
                  },
                  padding: EdgeInsets.only(right: 28),
                )
            ],
          ),
          body: Container(
            padding: EdgeInsets.only(top: 32),
            width: screenWidth,
            height: screenHeight,
            child: Query(
              options: QueryOptions(
                  document: gql(seeProfileQuery),
                  variables: {'username': widget.username}),
              builder: (QueryResult result,
                  {VoidCallback refetch, FetchMore fetchMore}) {
                if (result.hasException) {
                  return Text(result.exception.toString());
                }

                Map<String, dynamic> user;
                if (result.isLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (!result.data['seeProfile']['ok']) {
                  print("seeProfile Query Failed");
                  return Center(child: Text("유저 정보 불러오는 것에 실패했습니다."));
                } else {
                  print("seeProfile Query Succeed");
                  user = result.data['seeProfile']['user'];
                  return Column(
                    children: [
                      UserProfileTopInfo(
                        username: user['username'],
                        avatar: user['avatar'],
                        totalPosts: user['totalPosts'],
                        totalFollowers: user['totalFollowers'],
                        totalFollowing: user['totalFollowing'],
                        firstName: user['firstName'],
                        lastName: user['lastName'],
                        bio: user['bio'],
                        isMe: user['isMe'],
                        isFollowers: user['isFollowers'],
                        isFollowing: user['isFollowing'],
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}
