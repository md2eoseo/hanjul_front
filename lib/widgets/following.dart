import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hanjul_front/queries/see_following.dart';
import 'package:hanjul_front/widgets/main_app_bar.dart';
import 'package:hanjul_front/widgets/user_tile.dart';

class Following extends StatefulWidget {
  Following({Key key, this.username}) : super(key: key);
  final username;

  @override
  _FollowingState createState() => _FollowingState();
}

class _FollowingState extends State<Following> {
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
      appBar: MainAppBar(
        appBar: AppBar(),
        title: "${widget.username}의 팔로잉",
        leading: true,
      ),
      body: GraphQLConsumer(
        builder: (GraphQLClient client) {
          return Container(
            child: Query(
              options: QueryOptions(
                document: gql(seeFollowing),
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
                } else if (!result.data['seeFollowing']['ok']) {
                  return Center(child: Text("팔로잉 불러오기에 실패했습니다."));
                } else {
                  users = result.data['seeFollowing']['following'];
                  if (users.length == 0) {
                    return SizedBox(
                      height: 80,
                      child: Center(
                        child: Text(
                          "팔로잉이 없습니다.",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    );
                  }
                  newUserWidgets = [
                    for (var user in users)
                      UserTile(
                        key: Key(user['id'].toString()),
                        user: user,
                      ),
                  ];
                  return NotificationListener<ScrollEndNotification>(
                    child: RefreshIndicator(
                      onRefresh: _refreshData,
                      child: ListView.separated(
                        physics: AlwaysScrollableScrollPhysics(),
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
                            'lastId': result.data['seeFollowing']['lastId']
                          },
                          updateQuery:
                              (previousResultData, fetchMoreResultData) {
                            List users = [
                              ...previousResultData['seeFollowing']
                                  ['following'],
                              ...fetchMoreResultData['seeFollowing']
                                  ['following']
                            ];
                            fetchMoreResultData['seeFollowing']['following'] =
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
