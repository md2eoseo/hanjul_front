import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hanjul_front/pages/setting.dart';
import 'package:hanjul_front/queries/see_profile.dart';
import 'package:hanjul_front/queries/see_user_posts.dart';
import 'package:hanjul_front/widgets/main_app_bar.dart';
import 'package:hanjul_front/widgets/post_tile.dart';
import 'package:hanjul_front/widgets/user_profile_top_info.dart';

class UserProfile extends StatefulWidget {
  UserProfile({Key? key, this.me, this.username, this.onLoggedOut})
      : super(key: key);
  final me;
  final username;
  final onLoggedOut;

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  ScrollController _scrollController = new ScrollController();
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
        return Scaffold(
          appBar: MainAppBar(
            appBar: AppBar(),
            title: widget.username,
            scrollController: _scrollController,
            leading: widget.onLoggedOut == null,
            iconButtons: [
              if (widget.onLoggedOut != null)
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.cog,
                      size: 28, color: Colors.black),
                  padding: EdgeInsets.only(right: 28),
                  onPressed: () => {
                    Get.to(
                      () => SettingPage(
                          me: widget.me, onLoggedOut: widget.onLoggedOut),
                      transition: Transition.rightToLeft,
                    )
                  },
                )
            ],
          ),
          body: Container(
            child: Column(
              children: [
                Query(
                  options: QueryOptions(
                      document: gql(seeProfile),
                      variables: {'username': widget.username}),
                  builder: (QueryResult result,
                      {VoidCallback? refetch, FetchMore? fetchMore}) {
                    if (result.hasException) {
                      return Text(result.exception.toString());
                    }
                    if (result.isLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (!result.data?['seeProfile']['ok']) {
                      return Center(child: Text("?????? ????????? ??????????????? ??????????????????."));
                    } else {
                      Map<String, dynamic> user =
                          result.data?['seeProfile']['user'];
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
                    document: gql(seeUserPosts),
                    variables: {'username': widget.username},
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
                    if (!result.data?['seeUserPosts']['ok']) {
                      return Center(child: Text("?????? ??? ??????????????? ??????????????????."));
                    } else {
                      posts = result.data?['seeUserPosts']['posts'];
                      if (posts.length == 0) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(
                            child: GestureDetector(
                              onTap: _refreshData,
                              child: Column(
                                children: [
                                  Text(
                                    "????????? ?????? ????????????.",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(height: 10),
                                  Icon(
                                    Icons.refresh,
                                    color: Colors.grey[600],
                                    size: 24.0,
                                  ),
                                ],
                              ),
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
                    }
                    return NotificationListener<ScrollEndNotification>(
                      child: Expanded(
                        child: RefreshIndicator(
                          onRefresh: _refreshData,
                          child: ListView.separated(
                            physics: AlwaysScrollableScrollPhysics(),
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
                              'username': widget.username,
                              'lastId': result.data?['seeUserPosts']['lastId'],
                            },
                            updateQuery:
                                (previousResultData, fetchMoreResultData) {
                              List posts = [
                                ...previousResultData?['seeUserPosts']['posts'],
                                ...fetchMoreResultData?['seeUserPosts']['posts']
                              ];
                              fetchMoreResultData?['seeUserPosts']['posts'] =
                                  posts;
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
