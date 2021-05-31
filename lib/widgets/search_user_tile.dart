import 'package:flutter/material.dart';
import 'package:hanjul_front/widgets/user_avatar.dart';

class SearchUserTile extends StatefulWidget {
  SearchUserTile({Key key, this.user}) : super(key: key);
  final Map user;

  @override
  _SearchUserTileState createState() => _SearchUserTileState();
}

class _SearchUserTileState extends State<SearchUserTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Container(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
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
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
