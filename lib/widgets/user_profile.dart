import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hanjul_front/widgets/post_tile.dart';
import 'package:hanjul_front/widgets/user_profile_top_info.dart';

String seeProfileQuery = """
  query seeProfile(\$username: String!) {
    seeProfile(username: \$username) {
      ok
      error
      user {
        id
        firstName
        lastName
        username
        bio
        avatar
        totalPosts
        totalFollowers
        totalFollowing
        isMe
        isFollowers
        isFollowing
      }
    }
  }
""";

String seeUserPostsQuery = """
  query seeUserPosts(\$authorId: Int!, \$lastId: Int) {
    seeUserPosts(authorId: \$authorId, lastId: \$lastId) {
      ok
      error
      posts {
        id
        text
        likesCount
        isLiked
      }
      lastId
    }
  }
""";

class UserProfile extends StatefulWidget {
  UserProfile({Key key, this.username, this.authorId, this.onLoggedOut})
      : super(key: key);
  final username;
  final authorId;
  final onLoggedOut;

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
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
        return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.username,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              if (widget.onLoggedOut != null)
                IconButton(
                  icon: Icon(Icons.logout, size: 48),
                  onPressed: () async {
                    widget.onLoggedOut();
                  },
                  padding: EdgeInsets.only(right: 28),
                )
            ],
          ),
          body: Container(
            padding: EdgeInsets.only(top: 32),
            child: Column(
              children: [
                Query(
                  options: QueryOptions(
                      document: gql(seeProfileQuery),
                      variables: {'username': widget.username}),
                  builder: (QueryResult result,
                      {VoidCallback refetch, FetchMore fetchMore}) {
                    if (result.hasException) {
                      return Text(result.exception.toString());
                    }
                    if (result.isLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (!result.data['seeProfile']['ok']) {
                      return Center(child: Text("유저 프로필 불러오기에 실패했습니다."));
                    } else {
                      Map<String, dynamic> user =
                          result.data['seeProfile']['user'];
                      return UserProfileTopInfo(
                        username: user['username'],
                        avatar: user['avatar'],
                        totalPosts: user['totalPosts'],
                        totalFollowers: user['totalFollowers'],
                        totalFollowing: user['totalFollowing'],
                        firstName: user['firstName'],
                        lastName: user['lastName'],
                        bio: user['bio'],
                        isMe: user['isMe'],
                        isFollowers: user['isFollowers'],
                        isFollowing: user['isFollowing'],
                      );
                    }
                  },
                ),
                Query(
                  options: QueryOptions(
                      document: gql(seeUserPostsQuery),
                      variables: {'authorId': int.parse(widget.authorId)}),
                  builder: (QueryResult result,
                      {VoidCallback refetch, FetchMore fetchMore}) {
                    Future _refreshData() async {
                      refetch();
                      setState(() {
                        _currentPostWidgets.clear();
                      });
                    }

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
                    if (result.isLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (!result.data['seeUserPosts']['ok']) {
                      return Center(child: Text("유저 글 불러오기에 실패했습니다."));
                    } else {
                      posts = result.data['seeUserPosts']['posts'];
                      if (posts.length == 0) {
                        return SizedBox(
                          height: 80,
                          child: Center(
                            child: Text(
                              "작성한 글이 없습니다.",
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
                            updateIsLikedCache: _updateIsLikedCache,
                          ),
                      ];
                    }
                    return NotificationListener<ScrollEndNotification>(
                      child: Expanded(
                        child: RefreshIndicator(
                          onRefresh: _refreshData,
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
                      ),
                      onNotification: (notification) {
                        if (notification.metrics.maxScrollExtent - 10 <
                            notification.metrics.pixels) {
                          setState(() {
                            _currentPostWidgets = newPostWidgets;
                          });
                          FetchMoreOptions fetchMoreOpts = FetchMoreOptions(
                            variables: {
                              'authorId': int.parse(widget.authorId),
                              'lastId': result.data['seeUserPosts']['lastId'],
                            },
                            updateQuery:
                                (previousResultData, fetchMoreResultData) {
                              List posts = [
                                ...previousResultData['seeUserPosts']['posts'],
                                ...fetchMoreResultData['seeUserPosts']['posts']
                              ];
                              fetchMoreResultData['seeUserPosts']['posts'] =
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
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
