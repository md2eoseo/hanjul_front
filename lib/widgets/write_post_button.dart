import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:hanjul_front/pages/writing.dart';

class WritePostButton extends StatelessWidget {
  WritePostButton({Key key, this.word}) : super(key: key);
  final word;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.only(right: 28),
      icon: FaIcon(FontAwesomeIcons.pen, size: 28, color: Colors.black),
      onPressed: () {
        Get.to(
          () => WritingPage(word: word),
          transition: Transition.rightToLeft,
        );
      },
    );
  }
}
