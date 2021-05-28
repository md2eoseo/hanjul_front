import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hanjul_front/widgets/user_profile_top_info.dart';

class UserProfile extends StatefulWidget {
  UserProfile({Key key, this.user}) : super(key: key);
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
        return Container(
          padding: EdgeInsets.only(top: 32),
          width: screenWidth,
          height: screenHeight,
          child: Column(
            children: [
              UserProfileTopInfo(
                avatar: widget.user['avatar'],
                totalPosts: widget.user['totalPosts'],
                totalFollowers: widget.user['totalFollowers'],
                totalFollowing: widget.user['totalFollowing'],
                firstName: widget.user['firstName'],
                lastName: widget.user['lastName'],
                bio: widget.user['bio'],
              ),
            ],
          ),
        );
      },
    );
  }
}
