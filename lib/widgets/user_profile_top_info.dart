import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hanjul_front/config/client.dart';
import 'package:hanjul_front/mutations/update_profile_image.dart';
import 'package:hanjul_front/widgets/follow_button.dart';
import 'package:hanjul_front/widgets/followers.dart';
import 'package:hanjul_front/widgets/following.dart';
import 'package:hanjul_front/widgets/user_avatar.dart';
import 'package:hanjul_front/widgets/user_profile_top_info_box.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileTopInfo extends StatefulWidget {
  UserProfileTopInfo({
    Key? key,
    this.username,
    this.avatar,
    this.totalPosts,
    this.totalFollowers,
    this.totalFollowing,
    this.firstName,
    this.lastName,
    this.bio,
    this.isMe,
    this.isFollowers,
    this.isFollowing,
  });
  final username;
  final avatar;
  final totalPosts;
  final totalFollowers;
  final totalFollowing;
  final firstName;
  final lastName;
  final bio;
  final isMe;
  final isFollowers;
  final isFollowing;

  @override
  _UserProfileTopInfoState createState() => _UserProfileTopInfoState();
}

class _UserProfileTopInfoState extends State<UserProfileTopInfo> {
  final ImagePicker _picker = new ImagePicker();
  PickedFile? _image;

  Future _getImageFromGallery() async {
    final image = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  _showUpdateProfileImageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("프로필 사진을 변경하시겠습니까?"),
          actions: <Widget>[
            new TextButton(
              child: new Text("아니오"),
              onPressed: () {
                Get.back();
              },
            ),
            new TextButton(
              child: new Text("예"),
              onPressed: () async {
                Get.back();

                final MutationOptions options = MutationOptions(
                  document: gql(updateProfileImage),
                  variables: <String, dynamic>{
                    'avatar': File(_image!.path),
                  },
                );

                final QueryResult result = await client.value.mutate(options);
                print(result);
                if (result.hasException) {
                  Get.snackbar("프로필 사진을 변경하면서 오류가 발생했습니다.", "");
                  return;
                }

                final bool success = result.data?['updateProfile']['ok'];

                if (success) {
                  Get.snackbar("프로필 사진을 변경했습니다.", "");
                  return;
                } else {
                  Get.snackbar("프로필 사진을 변경하면서 오류가 발생했습니다.", "");
                  return;
                }
              },
            ),
          ],
        );
      },
    );
  }

  _updateProfileImage() async {
    await _getImageFromGallery();
    _showUpdateProfileImageDialog();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (!widget.isMe)
                UserAvatar(
                  avatar: widget.avatar,
                  size: 96.0,
                )
              else
                UserAvatar(
                  avatar: widget.avatar,
                  size: 96.0,
                  // TODO: onTap: _updateProfileImage,
                ),
              SizedBox(width: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  UserProfileTopInfoBox(name: "글", cnt: widget.totalPosts),
                  UserProfileTopInfoBox(
                    name: "팔로워",
                    cnt: widget.totalFollowers,
                    page: () {
                      Get.to(
                        () => Followers(username: widget.username),
                        transition: Transition.rightToLeft,
                      );
                    },
                  ),
                  UserProfileTopInfoBox(
                    name: "팔로잉",
                    cnt: widget.totalFollowing,
                    page: () {
                      Get.to(
                        () => Following(username: widget.username),
                        transition: Transition.rightToLeft,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 24),
          SizedBox(
            width: 380,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.firstName} ${widget.lastName}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                if (widget.bio != null) SizedBox(height: 4),
                if (widget.bio != null)
                  Text(
                    widget.bio,
                    style: TextStyle(fontSize: 18),
                  ),
                if (!widget.isMe) SizedBox(height: 18),
                if (!widget.isMe)
                  FollowButton(
                    username: widget.username,
                    isFollowers: widget.isFollowers,
                    isFollowing: widget.isFollowing,
                    width: 380.0,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
