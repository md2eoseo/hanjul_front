import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hanjul_front/config/client.dart';
import 'package:hanjul_front/queries/search_posts.dart';
import 'package:hanjul_front/queries/search_users.dart';
import 'package:hanjul_front/widgets/post_tile.dart';
import 'package:hanjul_front/widgets/user_tile.dart';

class SearchResults extends StatefulWidget {
  SearchResults({Key? key, this.type, this.keyword}) : super(key: key);
  final type;
  final keyword;

  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  Future _getUsers() async {
    print("user search!!");
    var result = await client.value.query(
      QueryOptions(
        document: gql(searchUsers),
        variables: {'keyword': widget.keyword},
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (!result.data?['searchUsers']['ok']) {
      print("유저 검색 실패!");
    } else {
      return result.data?['searchUsers']['users'];
    }
  }

  Future _getPosts() async {
    print("post search!!");
    var result = await client.value.query(
      QueryOptions(
        document: gql(searchPosts),
        variables: {'keyword': widget.keyword},
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (!result.data?['searchPosts']['ok']) {
      print("글 검색 실패!");
    } else {
      return result.data?['searchPosts']['posts'];
    }
  }

  Future _delayFetch() async {
    await Future.delayed(Duration(milliseconds: 400));
    switch (widget.type) {
      case 'user':
        return await _getUsers();
      case 'post':
        return await _getPosts();
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: _delayFetch(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 36.0, vertical: 24.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 36.0),
                  SizedBox(
                    width: 240,
                    child: Text(
                      '"${widget.keyword}" 검색중...',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text("검색에 실패했습니다."),
            );
          } else {
            final results = snapshot.data;
            List<Widget> resultWidgets = [];
            switch (widget.type) {
              case 'user':
                resultWidgets = [
                  for (var result in results) UserTile(user: result),
                ];
                break;
              case 'post':
                resultWidgets = [
                  for (var result in results) PostTile(post: result),
                ];
                break;
              default:
                break;
            }

            return Flexible(
              child: results.length == 0
                  ? Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                      child: Text(
                        '"${widget.keyword}" 검색 결과 없음',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.only(top: 8),
                      itemCount: resultWidgets.length,
                      itemBuilder: (context, i) {
                        return resultWidgets[i];
                      },
                      separatorBuilder: (context, i) {
                        return Divider();
                      },
                    ),
            );
          }
        },
      ),
    );
  }
}
