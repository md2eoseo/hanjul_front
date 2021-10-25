import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hanjul_front/mutations/update_profile.dart';
import 'package:hanjul_front/widgets/main_app_bar.dart';

class SettingAccountPage extends StatefulWidget {
  const SettingAccountPage({Key? key, this.me}) : super(key: key);
  final me;

  @override
  _SettingAccountPageState createState() => _SettingAccountPageState();
}

class _SettingAccountPageState extends State<SettingAccountPage> {
  final formKey = GlobalKey<FormState>();
  String _firstName = '';
  String _lastName = '';
  String _username = '';
  String _bio = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        appBar: AppBar(),
        title: "계정 정보 변경",
        leading: true,
      ),
      body: Center(
        child: Container(
          width: kIsWeb ? 420 : null,
          padding: EdgeInsets.fromLTRB(32, 64, 32, 96),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment:
                  kIsWeb ? MainAxisAlignment.center : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 80,
                  child: TextFormField(
                    initialValue: widget.me['lastName'],
                    decoration: InputDecoration(labelText: '성'),
                    validator: (value) {
                      final trimmedValue = value!.trim();
                      return trimmedValue.isEmpty ? '성을 입력해주세요.' : null;
                    },
                    onSaved: (value) => _lastName = value!.trim(),
                    style: TextStyle(fontSize: 24),
                    textInputAction: TextInputAction.done,
                  ),
                ),
                SizedBox(
                  height: 80,
                  child: TextFormField(
                    initialValue: widget.me['firstName'],
                    decoration: InputDecoration(labelText: '이름'),
                    validator: (value) {
                      final trimmedValue = value!.trim();
                      return trimmedValue.isEmpty ? '이름을 입력해주세요.' : null;
                    },
                    onSaved: (value) => _firstName = value!.trim(),
                    style: TextStyle(fontSize: 24),
                    textInputAction: TextInputAction.done,
                  ),
                ),
                SizedBox(
                  height: 80,
                  child: TextFormField(
                    initialValue: widget.me['username'],
                    decoration: InputDecoration(labelText: '사용자명'),
                    validator: (value) {
                      final trimmedValue = value!.trim();
                      return trimmedValue.isEmpty ? '사용자명을 입력해주세요.' : null;
                    },
                    onSaved: (value) => _username = value!.trim(),
                    style: TextStyle(fontSize: 24),
                    textInputAction: TextInputAction.done,
                  ),
                ),
                SizedBox(
                  height: kIsWeb ? 98 : 280,
                  child: TextFormField(
                    initialValue: widget.me['bio'],
                    decoration: InputDecoration(
                      labelText: "자기 소개",
                    ),
                    autocorrect: false,
                    maxLines: 6,
                    maxLength: 80,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    validator: (value) {
                      final trimmedValue = value!.trim();
                      return trimmedValue.isEmpty ? '자기 소개를 입력해주세요.' : null;
                    },
                    onSaved: (value) => _bio = value!.trim(),
                    style: TextStyle(fontSize: 24),
                    textInputAction: TextInputAction.done,
                  ),
                ),
                Mutation(
                  options: MutationOptions(
                    document: gql(updateProfile),
                    update: (GraphQLDataProxy? cache, QueryResult? result) {
                      return cache;
                    },
                    onCompleted: (dynamic resultData) async {
                      if (!resultData['updateProfile']['ok']) {
                        Get.snackbar(
                          "계정 정보 변경에 실패했습니다.",
                          "${resultData['updateProfile']['error']}",
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("계정 정보가 변경되었습니다!")),
                        );
                        Get.back();
                      }
                    },
                  ),
                  builder: (
                    RunMutation? runMutation,
                    QueryResult? result,
                  ) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16)),
                      child: Text(
                        result!.isLoading ? '계정 정보 변경 중...' : '계정 정보 변경',
                        style: TextStyle(fontSize: 24),
                      ),
                      onPressed: result.isLoading
                          ? null
                          : () => {
                                if (validateAndSave())
                                  {
                                    runMutation!({
                                      'firstName': _firstName,
                                      'lastName': _lastName,
                                      'username': _username,
                                      'bio': _bio
                                    })
                                  }
                              },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validateAndSave() {
    final formState = formKey.currentState;
    formState!.save();
    if (formState.validate()) {
      return true;
    }
    return false;
  }
}
