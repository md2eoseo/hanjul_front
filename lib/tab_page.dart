import "package:flutter/material.dart";
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hanjul_front/archive_page.dart';
import 'package:hanjul_front/config.dart';
import "package:hanjul_front/feed_page.dart";
import 'package:hanjul_front/my_page.dart';
import 'package:hanjul_front/search_page.dart';

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

class TabPage extends StatefulWidget {
  const TabPage({this.onLoggedOut});
  final VoidCallback onLoggedOut;

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  List<Widget> _tabOptions;
  int _currentIndex = 0;
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
        _tabOptions = <Widget>[
          FeedPage(word: _word),
          ArchivePage(word: _word),
          SearchPage(),
          MyPage(
            onLoggedOut: widget.onLoggedOut,
          ),
        ];
      });
    }
  }

  @override
  void initState() {
    getTodaysWord(getTodaysDate());
    _tabOptions = <Widget>[
      FeedPage(),
      ArchivePage(),
      SearchPage(),
      MyPage(
        onLoggedOut: widget.onLoggedOut,
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _tabOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.grey,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(.60),
        selectedFontSize: 14,
        unselectedFontSize: 14,
        onTap: _onItemTapped,
        currentIndex: _currentIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.notes), label: "피드"),
          BottomNavigationBarItem(icon: Icon(Icons.archive), label: "아카이브"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "검색"),
          BottomNavigationBarItem(icon: Icon(Icons.circle), label: "MY")
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
