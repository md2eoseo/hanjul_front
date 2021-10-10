import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hanjul_front/queries/see_archive.dart';
import 'package:hanjul_front/widgets/post_tile.dart';

class Archive extends StatefulWidget {
  Archive({Key? key, this.scrollController}) : super(key: key);
  final scrollController;

  @override
  _ArchiveState createState() => _ArchiveState();
}

class _ArchiveState extends State<Archive> {
  List<Widget> _currentPostWidgets = [];

  @override
  void initState() {
    _currentPostWidgets = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GraphQLConsumer(
      builder: (GraphQLClient client) {
        return Container(
          child: Query(
            options: QueryOptions(
              document: gql(seeArchive),
            ),
            builder: (QueryResult result,
                {VoidCallback? refetch, FetchMore? fetchMore}) {
              Future _refreshData() async {
                refetch!();
                return true;
              }

              if (result.hasException) {
                return Text(result.exception.toString());
              }
              List posts = [];
              List<Widget> newPostWidgets = [];
              if (!result.data?['seeArchive']['ok']) {
                return Center(child: Text("글 불러오기에 실패했습니다."));
              } else {
                posts = result.data?['seeArchive']['posts'];
                if (posts.length == 0) {
                  return SizedBox(
                    height: 80,
                    child: Center(
                      child: Text(
                        "글이 없습니다.",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  );
                }
                newPostWidgets = [
                  for (var post in posts)
                    PostTile(
                      key: Key(post['id'].toString()),
                      post: post,
                    ),
                ];
                return NotificationListener<ScrollEndNotification>(
                  child: RefreshIndicator(
                    onRefresh: _refreshData,
                    child: ListView.separated(
                      physics: AlwaysScrollableScrollPhysics(),
                      controller: widget.scrollController,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      itemCount: result.isLoading
                          ? _currentPostWidgets.length + 1
                          : newPostWidgets.length,
                      itemBuilder: (context, i) {
                        return result.isLoading
                            ? ([
                                ..._currentPostWidgets,
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
                            : newPostWidgets[i];
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
                        _currentPostWidgets = newPostWidgets;
                      });
                      FetchMoreOptions fetchMoreOpts = FetchMoreOptions(
                        variables: {
                          'lastId': result.data?['seeArchive']['lastId']
                        },
                        updateQuery: (previousResultData, fetchMoreResultData) {
                          List posts = [
                            ...previousResultData?['seeArchive']['posts'],
                            ...fetchMoreResultData?['seeArchive']['posts']
                          ];
                          fetchMoreResultData?['seeArchive']['posts'] = posts;
                          return fetchMoreResultData;
                        },
                      );
                      if (fetchMoreOpts.variables['lastId'] != null) {
                        fetchMore!(fetchMoreOpts);
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
    );
  }
}
