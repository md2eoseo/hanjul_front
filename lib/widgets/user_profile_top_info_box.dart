import 'package:flutter/material.dart';

class UserProfileTopInfoBox extends StatelessWidget {
  UserProfileTopInfoBox({Key key, this.name, this.cnt});
  final name;
  final cnt;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: Column(
        children: [
          Text(
            cnt.toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
