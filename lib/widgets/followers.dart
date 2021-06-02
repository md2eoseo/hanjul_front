import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hanjul_front/widgets/search_user_tile.dart';

String seeFollowersQuery = """
  query seeFollowers(\$username: String!, \$lastId: Int) {
    seeFollowers(username: \$username, lastId: \$lastId) {
      ok
      error
      followers {
        id
        username
        avatar
        isMe
        isFollowers
        isFollowing
      }
    }
  }
""";

class Followers extends StatefulWidget {
  Followers({Key key, this.username}) : super(key: key);
  final username;

  @override
  _FollowersState createState() => _FollowersState();
}

class _FollowersState extends State<Followers> {
  ScrollController _scrollController = new ScrollController();
  List<Widget> _currentUserWidgets;

  @override
  void initState() {
    _currentUserWidgets = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.username}의 팔로워",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: GraphQLConsumer(
        builder: (GraphQLClient client) {
          return Container(
            child: Query(
              options: QueryOptions(
                document: gql(seeFollowersQuery),
                variables: {'username': widget.username},
              ),
              builder: (QueryResult result,
                  {VoidCallback refetch, FetchMore fetchMore}) {
                Future _refreshData() async {
                  refetch();
                  return true;
                }

                if (result.hasException) {
                  return Text(result.exception.toString());
                }
                List users = [];
                List<Widget> newUserWidgets = [];
                if (result.isLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (!result.data['seeFollowers']['ok']) {
                  return Center(child: Text("팔로워 불러오기에 실패했습니다."));
                } else {
                  users = result.data['seeFollowers']['followers'];
                  if (users.length == 0) {
                    return SizedBox(
                      height: 80,
                      child: Center(
                        child: Text(
                          "팔로워가 없습니다.",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    );
                  }
                  newUserWidgets = [
                    for (var user in users)
                      SearchUserTile(
                        key: Key(user['id'].toString()),
                        user: user,
                      ),
                  ];
                  return NotificationListener<ScrollEndNotification>(
                    child: RefreshIndicator(
                      onRefresh: _refreshData,
                      child: ListView.separated(
                        controller: _scrollController,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        itemCount: result.isLoading
                            ? _currentUserWidgets.length + 1
                            : newUserWidgets.length,
                        itemBuilder: (context, i) {
                          return result.isLoading
                              ? ([
                                  ..._currentUserWidgets,
                                  ListTile(
                                    title: Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          CircularProgressIndicator(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ])[i]
                              : newUserWidgets[i];
                        },
                        separatorBuilder: (context, i) {
                          return Divider();
                        },
                      ),
                    ),
                    onNotification: (notification) {
                      if (notification.metrics.maxScrollExtent - 10 <
                          notification.metrics.pixels) {
                        setState(() {
                          _currentUserWidgets = newUserWidgets;
                        });
                        FetchMoreOptions fetchMoreOpts = FetchMoreOptions(
                          variables: {
                            'username': widget.username,
                            'lastId': result.data['seeFollowers']['lastId']
                          },
                          updateQuery:
                              (previousResultData, fetchMoreResultData) {
                            List users = [
                              ...previousResultData['seeFollowers']
                                  ['followers'],
                              ...fetchMoreResultData['seeFollowers']
                                  ['followers']
                            ];
                            fetchMoreResultData['seeFollowers']['followers'] =
                                users;
                            return fetchMoreResultData;
                          },
                        );
                        if (fetchMoreOpts.variables['lastId'] != null) {
                          fetchMore(fetchMoreOpts);
                        }
                      }
                      return true;
                    },
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
