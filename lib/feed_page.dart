import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hanjul_front/config.dart';
import 'package:hanjul_front/widgets/day_feed.dart';
import 'package:hanjul_front/writing_page.dart';

String searchWordsQuery = """
query searchWords(\$date: String){
  searchWords(date: \$date) {
      ok
      error
      words {
        id
        word
        meaning
        date
      }
    }
}
""";

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  ScrollController _scrollController = new ScrollController();
  Map<String, dynamic> _word;

  String getTodaysDate() {
    var now = DateTime.now();
    var formattedDate = "";
    formattedDate += now.year.toString().substring(2);
    formattedDate += now.month.toString().padLeft(2, '0');
    formattedDate += now.day.toString().padLeft(2, '0');
    return formattedDate;
  }

  Future getTodaysWord(String date) async {
    var result = await Config.client.value.query(QueryOptions(
        document: gql(searchWordsQuery), variables: {'date': date}));

    if (!result.data['searchWords']['ok']) {
      print("searchWords Query Failed");
    } else {
      print("searchWords Query Succeed");
      setState(() {
        _word = result.data['searchWords']['words'][0];
      });
    }
  }

  @override
  void initState() {
    getTodaysWord(getTodaysDate());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.notes,
            size: 48,
          ),
          onPressed: () {
            _scrollController.animateTo(
              0,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          },
          padding: EdgeInsets.only(left: 8),
        ),
        title: Text(
          "한줄",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, size: 48),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WritingPage(word: _word)),
              );
            },
            padding: EdgeInsets.only(right: 28),
          )
        ],
      ),
      body: DayFeed(scrollController: _scrollController, word: _word),
    );
  }
}
