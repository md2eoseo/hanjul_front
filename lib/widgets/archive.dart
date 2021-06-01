import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hanjul_front/widgets/post_tile.dart';

String seeArchiveQuery = """
  query seeArchive(\$lastId: Int) {
    seeArchive(lastId: \$lastId) {
      ok
      error
      posts {
        id
        text
        author{
          id
          username
          avatar
        }
        likesCount
        isLiked
      }
      lastId
    }
  }
""";

class Archive extends StatefulWidget {
  Archive({Key key, this.scrollController}) : super(key: key);
  final scrollController;

  @override
  _ArchiveState createState() => _ArchiveState();
}

class _ArchiveState extends State<Archive> {
  List<Widget> _currentPostWidgets;

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
              document: gql(seeArchiveQuery),
            ),
            builder: (QueryResult result,
                {VoidCallback refetch, FetchMore fetchMore}) {
              Function _updateIsLikedCache = (int postId) {
                final fragmentDoc = gql(
                  '''
                    fragment postSubset on Post {
                      id
                      likesCount
                      isLiked
                    }
                  ''',
                );
                var fragmentRequest = FragmentRequest(
                  fragment: Fragment(
                    document: fragmentDoc,
                  ),
                  idFields: {'__typename': 'Post', 'id': postId},
                );
                final data = client.readFragment(fragmentRequest);
                client.writeFragment(fragmentRequest, data: {
                  'likesCount': data['isLiked']
                      ? data['likesCount'] - 1
                      : data['likesCount'] + 1,
                  'isLiked': !data['isLiked']
                });
              };

              if (result.hasException) {
                return Text(result.exception.toString());
              }
              List posts = [];
              List<Widget> newPostWidgets = [];
              if (!result.data['seeArchive']['ok']) {
                return Center(child: Text("글 불러오기에 실패했습니다."));
              } else {
                posts = result.data['seeArchive']['posts'];
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
                      post: post,
                      updateIsLikedCache: _updateIsLikedCache,
                    ),
                ];
                return NotificationListener<ScrollEndNotification>(
                  child: ListView.separated(
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                  onNotification: (notification) {
                    if (notification.metrics.maxScrollExtent - 10 <
                        notification.metrics.pixels) {
                      setState(() {
                        _currentPostWidgets = newPostWidgets;
                      });
                      FetchMoreOptions fetchMoreOpts = FetchMoreOptions(
                        variables: {
                          'lastId': result.data['seeArchive']['lastId']
                        },
                        updateQuery: (previousResultData, fetchMoreResultData) {
                          List posts = [
                            ...previousResultData['seeArchive']['posts'],
                            ...fetchMoreResultData['seeArchive']['posts']
                          ];
                          fetchMoreResultData['seeArchive']['posts'] = posts;
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
    );
  }
}
