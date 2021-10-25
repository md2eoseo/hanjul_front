import 'package:flutter/material.dart';

class TodaysWord extends StatelessWidget {
  TodaysWord({Key? key, this.word}) : super(key: key);
  final word;

  List<Widget> getMeaningWidgets() {
    var widgets = <Widget>[];
    for (var i = 0; i < word['meaning'].length; i++) {
      var widget = Container(
        child: Text(
          "${i + 1}. ${word['meaning'][i]}",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      );
      widgets.add(widget);
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return word != null
        ? Container(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: screenWidth * 0.8,
                  child: Row(
                    children: [
                      Text(
                        '오늘의 단어  ',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${word['word']}',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: screenWidth * 0.8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: getMeaningWidgets(),
                  ),
                ),
              ],
            ),
          )
        : SizedBox(
            height: 120,
            child: Center(child: CircularProgressIndicator()),
          );
  }
}
