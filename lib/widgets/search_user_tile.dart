import 'package:flutter/material.dart';
import 'package:hanjul_front/widgets/user_avatar.dart';
import 'package:hanjul_front/widgets/user_profile.dart';

class SearchUserTile extends StatefulWidget {
  SearchUserTile({Key key, this.user}) : super(key: key);
  final Map<String, dynamic> user;

  @override
  _SearchUserTileState createState() => _SearchUserTileState();
}

class _SearchUserTileState extends State<SearchUserTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Container(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        child: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    UserProfile(username: widget.user['username']),
              ),
            );
          },
          child: Row(
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
        ),
      ),
    );
  }
}
