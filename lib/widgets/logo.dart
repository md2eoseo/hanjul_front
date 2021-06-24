import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 160,
              height: 160,
              child: kIsWeb
                  ? Image.asset(
                      'logo.png',
                      fit: BoxFit.fill,
                    )
                  : Image(
                      image: AssetImage('assets/logo.png'),
                      fit: BoxFit.fill,
                    ),
            ),
            Text(
              "한줄",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 42,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
