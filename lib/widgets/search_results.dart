import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hanjul_front/widgets/user_tile.dart';

String searchUsersQuery = """
  query searchUsers(\$keyword: String!, \$lastId: Int) {
    searchUsers(keyword: \$keyword, lastId: \$lastId) {
      ok
      error
      users {
        id
        username
        avatar
        isMe
        isFollowing
        isFollowers
      }
      lastId
    }
  }
""";

class SearchResults extends StatefulWidget {
  SearchResults({Key key, this.keyword}) : super(key: key);
  final keyword;

  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: _delayFetch(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 36.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(width: 36.0),
                    SizedBox(
                      width: 280,
                      child: Text(
                        '"${widget.keyword}" 검색중...',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              );
            default:
              return Flexible(child: snapshot.data);
          }
        },
      ),
    );
  }

  Future _delayFetch() async {
    await Future.delayed(Duration(milliseconds: 400));
    return Query(
      options: QueryOptions(
        document: gql(searchUsersQuery),
        variables: {'keyword': widget.keyword},
      ),
      builder: (QueryResult result,
          {VoidCallback refetch, FetchMore fetchMore}) {
        if (result.hasException) {
          return Text(result.exception.toString());
        }
        if (result.isLoading) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 36.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 36.0),
                SizedBox(
                  width: 280,
                  child: Text(
                    '"${widget.keyword}" 검색중...',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          );
        } else if (!result.data['searchUsers']['ok']) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text("검색에 실패했습니다."),
          );
        } else if (result.data['searchUsers']['users'].length == 0) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '"${widget.keyword}" 검색 결과 없음',
              style: TextStyle(fontSize: 16),
            ),
          );
        } else {
          FetchMoreOptions fetchMoreOpts = FetchMoreOptions(
            variables: {
              'keyword': widget.keyword,
              'lastId': result.data['searchUsers']['lastId'],
            },
            updateQuery: (previousResultData, fetchMoreResultData) {
              List users = [
                ...previousResultData['searchUsers']['users'],
                ...fetchMoreResultData['searchUsers']['users']
              ];
              fetchMoreResultData['searchUsers']['users'] = users;
              return fetchMoreResultData;
            },
          );

          List users = result.data['searchUsers']['users'];
          List<Widget> newUserWidgets = [
            for (var user in users) UserTile(user: user),
          ];
          return ListView.separated(
            padding: EdgeInsets.only(top: 8),
            itemCount: newUserWidgets.length,
            itemBuilder: (context, i) {
              return newUserWidgets[i];
            },
            separatorBuilder: (context, i) {
              return Divider();
            },
          );
        }
      },
    );
  }
}
