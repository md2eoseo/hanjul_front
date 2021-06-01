import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hanjul_front/config.dart';
import 'package:hanjul_front/widgets/post_tile.dart';
import 'package:hanjul_front/widgets/todays_word.dart';

String seeDayFeedQuery = """
  query seeDayFeed(\$date: String!, \$lastId: Int) {
    seeDayFeed(date: \$date, lastId: \$lastId) {
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
  DayFeed({Key key, this.scrollController, this.word}) : super(key: key);
  final scrollController;
  final word;

  @override
  _DayFeedState createState() => _DayFeedState();
}

class _DayFeedState extends State<DayFeed> {
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
          child: Column(
            children: [
              widget.word != null
                  ? TodaysWord(widget.word)
                  : Center(child: Text("오늘의 단어를 불러오지 못했습니다.")),
              Query(
                options: QueryOptions(
                    document: gql(seeDayFeedQuery),
                    variables: {'date': getTodaysDate()}),
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
                  if (!result.data['seeDayFeed']['ok']) {
                    return Center(child: Text("글 불러오기에 실패했습니다."));
                  } else {
                    posts = result.data['seeDayFeed']['posts'];
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
                            updateIsLikedCache: _updateIsLikedCache),
                    ];
                    return NotificationListener<ScrollEndNotification>(
                      child: Expanded(
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
                              'date': getTodaysDate(),
                              'lastId': result.data['seeDayFeed']['lastId']
                            },
                            updateQuery:
                                (previousResultData, fetchMoreResultData) {
                              List posts = [
                                ...previousResultData['seeDayFeed']['posts'],
                                ...fetchMoreResultData['seeDayFeed']['posts']
                              ];
                              fetchMoreResultData['seeDayFeed']['posts'] =
                                  posts;
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
            ],
          ),
        );
      },
    );
  }
}
