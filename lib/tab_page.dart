import "package:flutter/material.dart";
import "package:hanjul_front/feed_page.dart";
import 'package:hanjul_front/my_page.dart';

class TabPage extends StatefulWidget {
  const TabPage({this.onLoggedOut});
  final VoidCallback onLoggedOut;

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  List _widgetOptions;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _widgetOptions = [
      FeedPage(),
      Text(
        '아카이브',
        style: TextStyle(fontSize: 30, fontFamily: 'Nanum Myeongjo'),
      ),
      Text(
        '검색',
        style: TextStyle(fontSize: 30, fontFamily: 'Nanum Myeongjo'),
      ),
      MyPage(
        onLoggedOut: widget.onLoggedOut,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.grey,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(.60),
        selectedFontSize: 14,
        unselectedFontSize: 14,
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "피드"),
          BottomNavigationBarItem(icon: Icon(Icons.archive), label: "아카이브"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "검색"),
          BottomNavigationBarItem(icon: Icon(Icons.circle), label: "MY")
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
