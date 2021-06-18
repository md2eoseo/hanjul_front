import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hanjul_front/mutations/create_account.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  String _firstName = '';
  String _lastName = '';
  String _username = '';
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 48,
          ),
          onPressed: () {
            Get.back();
          },
          padding: EdgeInsets.only(left: 8),
        ),
        title: Text(
          "회원가입",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: '성'),
                  validator: (value) {
                    final trimmedValue = value.trim();
                    return trimmedValue.isEmpty ? '성을 입력해주세요.' : null;
                  },
                  onSaved: (value) => _lastName = value.trim(),
                  style: TextStyle(fontSize: 24),
                  textInputAction: TextInputAction.next,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: '이름'),
                  validator: (value) {
                    final trimmedValue = value.trim();
                    return trimmedValue.isEmpty ? '이름을 입력해주세요.' : null;
                  },
                  onSaved: (value) => _firstName = value.trim(),
                  style: TextStyle(fontSize: 24),
                  textInputAction: TextInputAction.next,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: '이메일'),
                  validator: (value) {
                    final trimmedValue = value.trim();
                    if (trimmedValue.isEmpty) return '이메일을 입력해주세요.';
                    Pattern pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                    RegExp regex = new RegExp(pattern);
                    return regex.hasMatch(trimmedValue)
                        ? null
                        : '이메일 형식으로 입력해주세요.';
                  },
                  onSaved: (value) => _email = value.trim(),
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: '사용자명'),
                  validator: (value) {
                    final trimmedValue = value.trim();
                    return trimmedValue.isEmpty ? '사용자명을 입력해주세요.' : null;
                  },
                  onSaved: (value) => _username = value.trim(),
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
                  onSaved: (value) => _password = value.trim(),
                  style: TextStyle(fontSize: 24),
                  textInputAction: TextInputAction.done,
                ),
                Mutation(
                  options: MutationOptions(
                    document: gql(createAccount),
                    update: (GraphQLDataProxy cache, QueryResult result) {
                      return cache;
                    },
                    onCompleted: (dynamic resultData) async {
                      if (!resultData['createAccount']['ok']) {
                        Get.snackbar(
                          "다른 이메일 또는 사용자명을 입력해주세요.",
                          "${resultData['createAccount']['error']}",
                        );
                      } else {
                        Get.snackbar(
                          "가입이 완료되었습니다!",
                          "${resultData['createAccount']['username']}으로 로그인 해주세요.",
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
                        result.isLoading ? '회원가입 중...' : '회원가입',
                        style: TextStyle(fontSize: 24),
                      ),
                      onPressed: result.isLoading
                          ? null
                          : () => {
                                if (validateAndSave())
                                  {
                                    runMutation({
                                      'lastName': _lastName,
                                      'firstName': _firstName,
                                      'email': _email,
                                      'username': _username,
                                      'password': _password
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
    if (formState.validate()) {
      formState.save();
      return true;
    }
    return false;
  }
}
