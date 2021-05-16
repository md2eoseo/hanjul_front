import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hanjul_front/widgets/post_tile.dart';

String seeDayFeedQuery = """
  query seeDayFeed(\$lastId: Int) {
    seeDayFeed(lastId: \$lastId) {
      ok
      error
      posts {
        id
        text
        author{
          username
        }
        likesCount
        isLiked
      }
      lastId
    }
  }
""";

class DayFeed extends StatefulWidget {
  DayFeed({Key key}) : super(key: key);

  @override
  _DayFeedState createState() => _DayFeedState();
}

class _DayFeedState extends State<DayFeed> {
  ScrollController _scrollController = new ScrollController();
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
              document: gql(seeDayFeedQuery),
            ),
            builder: (QueryResult result,
                {VoidCallback refetch, FetchMore fetchMore}) {
              FetchMoreOptions fetchMoreOpts = FetchMoreOptions(
                variables: {
                  'lastId': result.data['seeDayFeed']['lastId'] != null
                      ? result.data['seeDayFeed']['lastId']
                      : null
                },
                updateQuery: (previousResultData, fetchMoreResultData) {
                  List posts = [
                    ...previousResultData['seeDayFeed']['posts'],
                    ...fetchMoreResultData['seeDayFeed']['posts']
                  ];
                  fetchMoreResultData['seeDayFeed']['posts'] = posts;
                  return fetchMoreResultData;
                },
              );

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
              if (!result.data['seeDayFeed']['ok']) {
                print("seeDayFeed Query Failed");
                return Center(child: Text("글 불러오기에 실패했습니다."));
              } else {
                print("seeDayFeed Query Succeed");
                posts = result.data['seeDayFeed']['posts'];
              }

              List<Widget> newPostWidgets = [
                for (var post in posts)
                  PostTile(post: post, updateIsLikedCache: _updateIsLikedCache),
              ];

              return NotificationListener<ScrollEndNotification>(
                child: ListView.separated(
                  controller: _scrollController,
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                    if (fetchMoreOpts.variables['lastId'] != null) {
                      print("seeDayFeed Query fetchMore");
                      fetchMore(fetchMoreOpts);
                    } else {
                      print("infinite scroll end");
                    }
                  }
                  return true;
                },
              );
            },
          ),
        );
      },
    );
  }
}