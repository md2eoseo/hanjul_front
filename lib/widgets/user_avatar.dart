import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  UserAvatar({Key key, this.avatar, this.size});
  final avatar;
  final size;

  @override
  Widget build(BuildContext context) {
    return avatar == null
        ? Icon(Icons.account_circle, size: size, color: Colors.black)
        : CircleAvatar(
            radius: size / 2,
            backgroundImage: NetworkImage(avatar),
            backgroundColor: Colors.transparent,
          );
  }
}
