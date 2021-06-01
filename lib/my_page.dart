import 'package:hanjul_front/widgets/user_profile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyPage extends StatelessWidget {
  MyPage({Key key, this.onLoggedOut, this.me});
  final onLoggedOut;
  final me;

  @override
  Widget build(BuildContext context) {
    return UserProfile(
        onLoggedOut: onLoggedOut, username: me['username'], authorId: me['id']);
  }
}
