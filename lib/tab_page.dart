import "package:flutter/material.dart";
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hanjul_front/archive_page.dart';
import 'package:hanjul_front/config.dart';
import "package:hanjul_front/feed_page.dart";
import 'package:hanjul_front/my_page.dart';
import 'package:hanjul_front/search_page.dart';

String seeMyProfileQuery = """
query seeMyProfile{
  seeMyProfile{
    ok
    error
    user{
      id
      firstName
      lastName
      username
      bio
      avatar
      totalPosts
      totalFollowers
      totalFollowing
      isMe
      isFollowers
      isFollowing
    }
  }
}
""";

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
  TabPage({Key key, this.onLoggedOut});
  final VoidCallback onLoggedOut;

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  int _currentIndex = 0;
  Map<String, dynamic> _word;

  Future getTodaysWord(String date) async {
    var result = await Config.client.value.query(
      QueryOptions(
        document: gql(searchWordsQuery),
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

  @override
  void initState() {
    getTodaysWord(getTodaysDate());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Query(
        options: QueryOptions(
          document: gql(seeMyProfileQuery),
        ),
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (!result.data['seeMyProfile']['ok']) {
            return Center(child: Text("유저 프로필 불러오기에 실패했습니다."));
          } else {
            Map<String, dynamic> me = result.data['seeMyProfile']['user'];
            return IndexedStack(
              index: _currentIndex,
              children: <Widget>[
                FeedPage(word: _word),
                ArchivePage(word: _word),
                SearchPage(),
                MyPage(onLoggedOut: widget.onLoggedOut, me: me),
              ],
            );
          }
        },
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
