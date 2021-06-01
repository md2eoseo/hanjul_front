import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hanjul_front/widgets/user_profile_top_info.dart';

class UserProfile extends StatefulWidget {
  UserProfile({Key key, this.onLoggedOut, this.user}) : super(key: key);
  final onLoggedOut;
  final Map<String, dynamic> user;

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
              widget.user['username'],
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
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
            child: Column(
              children: [
                UserProfileTopInfo(
                  username: widget.user['username'],
                  avatar: widget.user['avatar'],
                  totalPosts: widget.user['totalPosts'],
                  totalFollowers: widget.user['totalFollowers'],
                  totalFollowing: widget.user['totalFollowing'],
                  firstName: widget.user['firstName'],
                  lastName: widget.user['lastName'],
                  bio: widget.user['bio'],
                  isMe: widget.user['isMe'],
                  isFollowers: widget.user['isFollowers'],
                  isFollowing: widget.user['isFollowing'],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
