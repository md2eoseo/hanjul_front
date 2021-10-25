import 'package:flutter/material.dart';

class UserProfileTopInfoBox extends StatelessWidget {
  UserProfileTopInfoBox({Key? key, this.name, this.cnt, this.page});
  final name;
  final cnt;
  final page;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(splashFactory: NoSplash.splashFactory),
      onPressed: () {
        if (page != null) {
          page();
        }
      },
      child: SizedBox(
        width: 52,
        child: Column(
          children: [
            Text(
              cnt.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Text(
              name,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
