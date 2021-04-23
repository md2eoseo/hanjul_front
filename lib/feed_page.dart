import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hanjul_front/widgets/like_button.dart';

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

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "한줄",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontFamily: "Nanum Myeongjo",
          ),
        ),
      ),
      body: Container(
        child: Query(
          options: QueryOptions(
            document: gql(seeDayFeedQuery),
          ),
          builder: (QueryResult result,
              {VoidCallback refetch, FetchMore fetchMore}) {
            FetchMoreOptions fetchMoreOpts = FetchMoreOptions(
              variables: result.data['seeDayFeed']['lastId'] != null
                  ? {'lastId': result.data['seeDayFeed']['lastId']}
                  : {},
              updateQuery: (previousResultData, fetchMoreResultData) {
                final List<dynamic> posts = [
                  ...previousResultData['seeDayFeed']['posts'] as List<dynamic>,
                  ...fetchMoreResultData['seeDayFeed']['posts'] as List<dynamic>
                ];
                fetchMoreResultData['seeDayFeed']['posts'] = posts;
                return fetchMoreResultData;
              },
            );

            if (result.hasException) {
              return Text(result.exception.toString());
            }

            if (result.isLoading) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                ],
              );
            }

            List _posts = [];
            if (!result.data['seeDayFeed']['ok']) {
              print("seeDayFeed Query not ok!!!!!!");
            } else {
              print("seeDayFeed Query fetched!!");
              _posts = result.data['seeDayFeed']['posts'];
            }
            return _buildDayFeedPosts(_posts, fetchMore, fetchMoreOpts);
          },
        ),
      ),
    );
  }

  Widget _buildDayFeedPosts(
      List dayFeedPosts, FetchMore fetchMore, FetchMoreOptions fetchMoreOpts) {
    if (dayFeedPosts.length == 0) {
      return Center(child: Text("글이 없습니다."));
    }
    return NotificationListener<ScrollEndNotification>(
      child: ListView.separated(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(vertical: 14),
        itemCount: dayFeedPosts.length,
        itemBuilder: (context, i) {
          return _buildPost(dayFeedPosts[i]);
        },
        separatorBuilder: (context, i) {
          return Divider();
        },
      ),
      onNotification: (notification) {
        if (fetchMoreOpts.variables['lastId'] != null) {
          print("fetchMore");
          fetchMore(fetchMoreOpts);
          return false;
        } else {
          print("infinite scroll end");
          return true;
        }
      },
    );
  }

  Widget _buildPost(post) {
    return ListTile(
      title: Container(
          padding: EdgeInsets.fromLTRB(8, 12, 0, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post['text'],
                style: TextStyle(
                  fontSize: 28,
                  fontFamily: "Nanum Myeongjo",
                ),
              ),
              SizedBox(height: 24),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.account_circle),
                        SizedBox(width: 8),
                        Text(
                          post['author']['username'],
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: "Nanum Myeongjo",
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        LikeButton(
                            postId: post['id'],
                            isLiked: post['isLiked'],
                            likesCount: post['likesCount'])
                      ],
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}
