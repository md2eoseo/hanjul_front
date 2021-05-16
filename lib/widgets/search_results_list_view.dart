import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hanjul_front/widgets/search_user_tile.dart';

String searchUsersQuery = """
  query searchUsers(\$keyword: String!, \$lastId: Int) {
    searchUsers(keyword: \$keyword, lastId: \$lastId) {
      ok
      error
      users {
        id
        username
        avatar
      }
      lastId
    }
  }
""";

class SearchResultsListView extends StatefulWidget {
  const SearchResultsListView({
    Key key,
    this.keyword,
  }) : super(key: key);

  final keyword;

  @override
  _SearchResultsListViewState createState() => _SearchResultsListViewState();
}

class _SearchResultsListViewState extends State<SearchResultsListView> {
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
              return Expanded(child: snapshot.data);
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
              crossAxisAlignment: CrossAxisAlignment.start,
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

          List users = [];
          if (!result.data['searchUsers']['ok']) {
            print("searchUsers Query Failed");
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text("검색에 실패했습니다."),
            );
          } else if (result.data['searchUsers']['users'].length == 0) {
            print("searchUsers Query No Users");
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '"${widget.keyword}" 검색 결과 없음',
                style: TextStyle(fontSize: 16),
              ),
            );
          } else {
            print("searchUsers Query Succeed");
            users = result.data['searchUsers']['users'];
            List<Widget> newUserWidgets = [
              for (var user in users) SearchUserTile(user: user),
            ];

            return ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 14),
              itemCount: newUserWidgets.length,
              itemBuilder: (context, i) {
                return newUserWidgets[i];
              },
              separatorBuilder: (context, i) {
                return Divider();
              },
            );
          }
        }
      },
    );
  }
}
