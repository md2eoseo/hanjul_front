import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hanjul_front/config/utils.dart';
import 'package:hanjul_front/mutations/login.dart';
import 'package:hanjul_front/pages/sign_up.dart';
import 'package:hanjul_front/widgets/logo.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.onLoggedIn});
  final onLoggedIn;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(32, 96, 32, 0),
        child: Center(
          child: Column(
            children: [
              Logo(),
              SizedBox(height: 32),
              Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(labelText: '사용자명'),
                      validator: (value) {
                        final trimmedValue = value.trim();
                        return trimmedValue.isEmpty ? '사용자명을 입력해주세요.' : null;
                      },
                      onSaved: (value) => _username = value,
                      style: TextStyle(fontSize: 24),
                      textInputAction: TextInputAction.next,
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(labelText: '비밀번호'),
                      validator: (value) {
                        final trimmedValue = value.trim();
                        return trimmedValue.isEmpty ? '비밀번호를 입력해주세요.' : null;
                      },
                      onSaved: (value) => _password = value,
                      style: TextStyle(fontSize: 24),
                      textInputAction: TextInputAction.done,
                    ),
                    Mutation(
                      options: MutationOptions(
                        document: gql(login),
                        update: (GraphQLDataProxy cache, QueryResult result) {
                          return cache;
                        },
                        onCompleted: (dynamic resultData) async {
                          if (!resultData['login']['ok']) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text("${resultData['login']['error']}"),
                                  backgroundColor: Colors.red[200]),
                            );
                          } else {
                            saveToken(resultData['login']['token']);
                            widget.onLoggedIn();
                          }
                        },
                      ),
                      builder: (
                        RunMutation runMutation,
                        QueryResult result,
                      ) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 16)),
                              child: Text(
                                result.isLoading ? '로그인 중...' : '로그인',
                                style: TextStyle(fontSize: 24),
                              ),
                              onPressed: result.isLoading
                                  ? null
                                  : () => {
                                        if (validateAndSave())
                                          {
                                            runMutation({
                                              'username': _username,
                                              'password': _password
                                            })
                                          }
                                      },
                            ),
                            Divider(height: 28, thickness: 3),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 16)),
                              child: Text(
                                '회원가입',
                                style: TextStyle(fontSize: 24),
                              ),
                              onPressed: () => {
                                Get.to(
                                  () => SignUpPage(),
                                  transition: Transition.rightToLeft,
                                )
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validateAndSave() {
    final formState = formKey.currentState;
    if (formState.validate()) {
      formState.save();
      return true;
    }
    return false;
  }
}
