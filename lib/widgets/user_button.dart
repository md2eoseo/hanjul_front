import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanjul_front/widgets/user_avatar.dart';
import 'package:hanjul_front/widgets/user_profile.dart';

class UserButton extends StatelessWidget {
  UserButton({Key key, this.authorName, this.authorAvatar}) : super(key: key);
  final authorName;
  final authorAvatar;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(splashFactory: NoSplash.splashFactory),
      onPressed: () {
        Get.to(
          () => UserProfile(
            username: authorName,
          ),
          transition: Transition.rightToLeft,
        );
      },
      child: Container(
        child: Row(
          children: [
            UserAvatar(avatar: authorAvatar, size: 26.0),
            SizedBox(width: 6),
            Text(
              authorName,
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
