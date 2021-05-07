import "package:flutter/material.dart";
import 'package:hanjul_front/archive_page.dart';
import "package:hanjul_front/feed_page.dart";
import 'package:hanjul_front/my_page.dart';
import 'package:hanjul_front/search_page.dart';

class TabPage extends StatefulWidget {
  const TabPage({this.onLoggedOut});
  final VoidCallback onLoggedOut;

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  List<Widget> _tabOptions;
  int _currentIndex;

  @override
  void initState() {
    _tabOptions = <Widget>[
      FeedPage(),
      ArchivePage(),
      SearchPage(),
      MyPage(
        onLoggedOut: widget.onLoggedOut,
      ),
    ];
    _currentIndex = 0;
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "피드"),
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
