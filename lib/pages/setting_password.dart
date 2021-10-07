import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hanjul_front/mutations/update_password.dart';
import 'package:hanjul_front/widgets/main_app_bar.dart';

class SettingPasswordPage extends StatefulWidget {
  const SettingPasswordPage({Key key}) : super(key: key);

  @override
  _SettingPasswordPageState createState() => _SettingPasswordPageState();
}

class _SettingPasswordPageState extends State<SettingPasswordPage> {
  final formKey = GlobalKey<FormState>();
  String _oldPassword = '';
  String _newPassword = '';
  String _newPasswordCheck = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        appBar: AppBar(),
        title: "비밀번호 변경",
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
                    obscureText: true,
                    decoration: InputDecoration(labelText: '현재 비밀번호'),
                    validator: (value) {
                      return value.isEmpty ? '현재 비밀번호를 입력해주세요.' : null;
                    },
                    onSaved: (value) => _oldPassword = value,
                    style: TextStyle(fontSize: 24),
                    textInputAction: TextInputAction.done,
                  ),
                ),
                SizedBox(
                  height: 80,
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(labelText: '새 비밀번호'),
                    validator: (value) {
                      return value.isEmpty ? '새 비밀번호를 입력해주세요.' : null;
                    },
                    onSaved: (value) => _newPassword = value,
                    style: TextStyle(fontSize: 24),
                    textInputAction: TextInputAction.done,
                  ),
                ),
                SizedBox(
                  height: kIsWeb ? 98 : 180,
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(labelText: '새 비밀번호 확인'),
                    validator: (value) {
                      return value.isEmpty
                          ? '새 비밀번호를 확인해주세요.'
                          : _newPassword != _newPasswordCheck
                              ? '새 비밀번호가 일치하지 않습니다.'
                              : null;
                    },
                    onSaved: (value) => _newPasswordCheck = value,
                    style: TextStyle(fontSize: 24),
                    textInputAction: TextInputAction.done,
                  ),
                ),
                Mutation(
                  options: MutationOptions(
                    document: gql(updatePassword),
                    update: (GraphQLDataProxy cache, QueryResult result) {
                      return cache;
                    },
                    onCompleted: (dynamic resultData) async {
                      if (!resultData['updatePassword']['ok']) {
                        Get.snackbar(
                          "비밀번호 변경에 실패했습니다.",
                          "${resultData['updatePassword']['error']}",
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("비밀번호가 변경되었습니다!")),
                        );
                        Get.back();
                      }
                    },
                  ),
                  builder: (
                    RunMutation runMutation,
                    QueryResult result,
                  ) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16)),
                      child: Text(
                        result.isLoading ? '비밀번호 변경 중...' : '비밀번호 변경',
                        style: TextStyle(fontSize: 24),
                      ),
                      onPressed: result.isLoading
                          ? null
                          : () => {
                                if (validateAndSave())
                                  {
                                    runMutation({
                                      'oldPassword': _oldPassword,
                                      'newPassword': _newPassword
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
    formState.save();
    if (formState.validate()) {
      return true;
    }
    return false;
  }
}
