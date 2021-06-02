import 'package:flutter/material.dart';
import 'package:hanjul_front/widgets/follow_button.dart';
import 'package:hanjul_front/widgets/followers.dart';
import 'package:hanjul_front/widgets/following.dart';
import 'package:hanjul_front/widgets/user_avatar.dart';
import 'package:hanjul_front/widgets/user_profile_top_info_box.dart';

class UserProfileTopInfo extends StatelessWidget {
  UserProfileTopInfo({
    Key key,
    this.username,
    this.avatar,
    this.totalPosts,
    this.totalFollowers,
    this.totalFollowing,
    this.firstName,
    this.lastName,
    this.bio,
    this.isMe,
    this.isFollowers,
    this.isFollowing,
  });
  final username;
  final avatar;
  final totalPosts;
  final totalFollowers;
  final totalFollowing;
  final firstName;
  final lastName;
  final bio;
  final isMe;
  final isFollowers;
  final isFollowing;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UserAvatar(avatar: avatar, size: 96.0),
              SizedBox(width: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  UserProfileTopInfoBox(name: "글", cnt: totalPosts),
                  UserProfileTopInfoBox(
                    name: "팔로워",
                    cnt: totalFollowers,
                    page: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Followers(username: username),
                        ),
                      );
                    },
                  ),
                  UserProfileTopInfoBox(
                    name: "팔로잉",
                    cnt: totalFollowing,
                    page: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Following(username: username),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 18, horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$firstName $lastName",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                if (bio != null)
                  Text(
                    bio,
                    style: TextStyle(fontSize: 22),
                  )
              ],
            ),
          ),
          if (!isMe)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FollowButton(
                  username: username,
                  isFollowers: isFollowers,
                  isFollowing: isFollowing,
                  width: MediaQuery.of(context).size.width - 40,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
