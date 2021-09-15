import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:hanjul_front/pages/writing.dart';

class WritePostButton extends StatelessWidget {
  WritePostButton({Key key, this.word}) : super(key: key);
  final word;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.only(right: 32),
      icon: Icon(Icons.add, size: 36, color: Colors.black),
      onPressed: () {
        Get.to(
          () => WritingPage(word: word),
          transition: Transition.rightToLeft,
        );
      },
    );
  }
}
