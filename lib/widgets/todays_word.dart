import 'package:flutter/material.dart';

class TodaysWord extends StatelessWidget {
  TodaysWord(this.word);

  final Map<String, dynamic> word;

  List<Widget> getMeaningWidgets() {
    var widgets = <Widget>[];
    for (var i = 0; i < word['meaning'].length; i++) {
      var widget = Container(
          child: Text(
        "${i + 1}. ${word['meaning'][i]}",
        style: TextStyle(
          fontSize: 18,
        ),
      ));
      widgets.add(widget);
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "오늘의 단어",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                SizedBox(width: 20),
                Text(
                  word['word'],
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: getMeaningWidgets(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
