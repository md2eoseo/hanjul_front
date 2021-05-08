import 'package:flutter/material.dart';

class SearchUserTile extends StatefulWidget {
  const SearchUserTile({
    Key key,
    this.user,
  }) : super(key: key);

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
            widget.user['avatar'] == null
                ? CircleAvatar(
                    child: LayoutBuilder(
                      builder: (context, constraint) {
                        return Icon(
                          Icons.account_circle,
                          size: constraint.biggest.height,
                        );
                      },
                    ),
                  )
                : CircleAvatar(
                    backgroundImage: NetworkImage(widget.user['avatar'])),
            SizedBox(width: 32),
            Text(
              widget.user['username'],
              style: TextStyle(
                fontSize: 24,
                fontFamily: "Nanum Myeongjo",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
