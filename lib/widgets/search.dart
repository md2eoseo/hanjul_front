import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hanjul_front/widgets/search_results.dart';

String getCleanKeyword(String keyword) {
  final regex = RegExp('\\s+');
  return keyword.replaceAll(regex, ' ').trim();
}

class Search extends StatefulWidget {
  Search({Key? key, this.type, this.keyword}) : super(key: key);
  final type;
  final keyword;

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return GraphQLConsumer(
      builder: (GraphQLClient client) {
        return Container(
          child: Column(
            children: [
              widget.keyword != ""
                  ? SearchResults(
                      type: widget.type,
                      keyword: widget.keyword,
                    )
                  : Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Text("검색어가 비어있습니다."),
                    )
            ],
          ),
        );
      },
    );
  }
}
