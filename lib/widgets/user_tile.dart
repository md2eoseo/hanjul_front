import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanjul_front/widgets/follow_button.dart';
import 'package:hanjul_front/widgets/user_avatar.dart';
import 'package:hanjul_front/widgets/user_profile.dart';

class UserTile extends StatefulWidget {
  UserTile({Key key, this.user}) : super(key: key);
  final Map<String, dynamic> user;

  @override
  _UserTileState createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Container(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: TextButton(
          onPressed: () {
            Get.to(
              () => UserProfile(
                username: widget.user['username'],
                authorId: widget.user['id'],
              ),
              transition: Transition.rightToLeft,
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  UserAvatar(
                    avatar: widget.user['avatar'],
                    size: 36.0,
                  ),
                  SizedBox(width: 24),
                  Text(
                    widget.user['username'],
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
              if (!widget.user['isMe'])
                FollowButton(
                  username: widget.user['username'],
                  isFollowing: widget.user['isFollowing'],
                  isFollowers: widget.user['isFollowers'],
                  width: 108.0,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
