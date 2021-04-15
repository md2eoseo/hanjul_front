import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const String TOKEN = "token";
final storage = new FlutterSecureStorage();

String loginMutation = """
  mutation login(\$username: String!, \$password: String!) {
    login(username: \$username, password: \$password) {
      ok
      error
      token
    }
  }
""";

class LoginPage extends StatefulWidget {
  const LoginPage({this.onLoggedIn});
  final VoidCallback onLoggedIn;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    bool validateAndSave() {
      final formState = formKey.currentState;
      if (formState.validate()) {
        formState.save();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$_username님으로 로그인하는 중...')));
        return true;
      }
      return false;
    }

    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(32, 96, 32, 0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: '사용자명'),
                validator: (value) => value.isEmpty ? '사용자명을 입력해주세요.' : null,
                onSaved: (value) => _username = value,
                style: TextStyle(fontSize: 24),
              ),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(labelText: '비밀번호'),
                validator: (value) => value.isEmpty ? '비밀번호를 입력해주세요.' : null,
                onSaved: (value) => _password = value,
                style: TextStyle(fontSize: 24),
              ),
              Mutation(
                options: MutationOptions(
                  document: gql(loginMutation),
                  update: (GraphQLDataProxy cache, QueryResult result) {
                    return cache;
                  },
                  onCompleted: (dynamic resultData) async {
                    if (!resultData['login']['ok']) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("${resultData['login']['error']}")));
                    } else {
                      await storage.write(
                          key: TOKEN, value: resultData['login'][TOKEN]);
                      widget.onLoggedIn();
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
                      '로그인',
                      style: TextStyle(fontSize: 24),
                    ),
                    onPressed: () => {
                      if (validateAndSave())
                        {
                          runMutation(
                              {'username': _username, 'password': _password})
                        }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
