import 'package:flutter/material.dart';
import 'package:hanjul_front/widgets/search.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  String? _keyword;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _keyword = "";
    super.initState();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Column(
          children: [
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: Colors.grey[400],
                    ),
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 24),
                    margin: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                    child: TextField(
                      style: TextStyle(color: Colors.white, fontSize: 24),
                      cursorColor: Colors.white,
                      cursorWidth: 0.6,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                      ),
                      onChanged: (value) =>
                          setState(() => {_keyword = getCleanKeyword(value)}),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
        backgroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          tabs: <Tab>[
            Tab(text: "유저"),
            Tab(text: "글"),
          ],
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          labelStyle: TextStyle(
            fontFamily: 'Nanum Myeongjo',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Search(type: "user", keyword: _keyword),
          Search(type: "post", keyword: _keyword),
        ],
      ),
    );
  }
}
