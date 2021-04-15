import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

String seeDayFeedQuery = """
  query seeDayFeed(\$lastId: Int) {
    seeDayFeed(lastId: \$lastId) {
      ok
      error
      posts {
        text
        author{
          username
        }
      }
    }
  }
""";

class Post {
  String text;
  String author;

  Post(this.text, this.author);
}

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  List<Post> _dayFeedPosts = <Post>[];

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
            pollInterval: Duration(seconds: 10),
          ),
          builder: (QueryResult result,
              {VoidCallback refetch, FetchMore fetchMore}) {
            if (result.hasException) {
              return Text(result.exception.toString());
            }

            if (result.isLoading) {
              return Text('Loading');
            }

            if (!result.data['seeDayFeed']['ok']) {
              print("seeDayFeed Query not ok!!!!!!");
            } else {
              List posts = result.data['seeDayFeed']['posts'];
              List<Post> _fetchedPosts = <Post>[];
              for (var idx = 0; idx < posts.length; idx++) {
                _fetchedPosts.add(
                    Post(posts[idx]['text'], posts[idx]['author']['username']));
              }
              _dayFeedPosts = _fetchedPosts;
            }
            return _buildDayFeedPosts(_dayFeedPosts);
          },
        ),
      ),
    );
  }

  Widget _buildDayFeedPosts(List<Post> dayFeedPosts) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 14),
      itemCount: dayFeedPosts.length,
      itemBuilder: (context, i) {
        return _buildPost(dayFeedPosts[i]);
      },
      separatorBuilder: (context, i) {
        return Divider();
      },
    );
  }

  Widget _buildPost(Post post) {
    return ListTile(
      title: Container(
          padding: EdgeInsets.fromLTRB(8, 12, 0, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.text,
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
                          post.author,
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: "Nanum Myeongjo",
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.whatshot,
                          size: 36,
                        ),
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
