import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hanjul_front/widgets/user_profile.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyPage extends StatefulWidget {
  MyPage({Key key, this.onLoggedOut, this.me});
  final onLoggedOut;
  final me;

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return GraphQLConsumer(
      builder: (GraphQLClient client) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.me['username'],
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
          body: UserProfile(user: widget.me),
        );
      },
    );
  }
}
