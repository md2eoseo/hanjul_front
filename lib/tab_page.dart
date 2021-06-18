import "package:flutter/material.dart";
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hanjul_front/archive_page.dart';
import 'package:hanjul_front/config/client.dart';
import "package:hanjul_front/feed_page.dart";
import 'package:hanjul_front/my_page.dart';
import 'package:hanjul_front/queries/search_words.dart';
import 'package:hanjul_front/queries/see_my_profile.dart';
import 'package:hanjul_front/search_page.dart';
import 'package:hanjul_front/config/utils.dart';

class TabPage extends StatefulWidget {
  TabPage({Key key, this.onLoggedOut});
  final VoidCallback onLoggedOut;

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  int _currentIndex = 0;
  Map<String, dynamic> _word;
  Map<String, dynamic> _me;

  Future getTodaysWord(String date) async {
    var result = await client.value.query(
      QueryOptions(
        document: gql(searchWords),
        variables: {'date': date},
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (!result.data['searchWords']['ok']) {
      print("오늘의 단어 불러오기 실패!");
    } else {
      setState(() {
        _word = result.data['searchWords']['words'][0];
      });
    }
  }

  Future getMyProfile() async {
    var result = await client.value.query(
      QueryOptions(
        document: gql(seeMyProfile),
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (!result.data['seeMyProfile']['ok']) {
      print("내 프로필 불러오기 실패!");
    } else {
      setState(() {
        _me = result.data['seeMyProfile']['user'];
      });
    }
  }

  @override
  void initState() {
    getTodaysWord(getTodaysDate());
    getMyProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _word == null || _me == null
          ? Center(child: CircularProgressIndicator())
          : IndexedStack(
              index: _currentIndex,
              children: <Widget>[
                FeedPage(word: _word),
                ArchivePage(word: _word),
                SearchPage(),
                MyPage(onLoggedOut: widget.onLoggedOut, me: _me),
              ],
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
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "MY")
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
