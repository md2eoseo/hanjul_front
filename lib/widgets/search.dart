import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hanjul_front/widgets/search_results.dart';

String getCleanKeyword(String keyword) {
  final regex = RegExp('\\s+');
  return keyword.replaceAll(regex, ' ').trim();
}

class Search extends StatefulWidget {
  Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String _keyword;

  @override
  void initState() {
    _keyword = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return GraphQLConsumer(
      builder: (GraphQLClient client) {
        return Container(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: statusBarHeight)),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        color: Colors.grey[400],
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 2, horizontal: 24),
                      margin:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
              SizedBox(height: 4),
              _keyword != ""
                  ? SearchResults(
                      keyword: _keyword,
                    )
                  : Text("검색어가 비어있습니다.")
            ],
          ),
        );
      },
    );
  }
}
