import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  UserAvatar({Key? key, this.avatar, this.size, this.onTap});
  final avatar;
  final size;
  final onTap;

  @override
  Widget build(BuildContext context) {
    return avatar == null
        ? GestureDetector(
            child: Icon(Icons.account_circle, size: size, color: Colors.black),
            onTap: onTap,
          )
        : GestureDetector(
            child: CircleAvatar(
              radius: size / 2,
              backgroundImage: NetworkImage(avatar),
              backgroundColor: Colors.transparent,
            ),
            onTap: onTap,
          );
  }
}
