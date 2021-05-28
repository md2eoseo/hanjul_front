import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

String createAccountMutation = """
  mutation createAccount(\$firstName: String!, \$lastName: String!, \$username: String!, \$email: String!, \$password: String!) {
    createAccount(firstName: \$firstName, lastName: \$lastName, username: \$username, email: \$email, password: \$password) {
      ok
      error
      username
    }
  }
""";

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
            Navigator.pop(context);
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
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: '성'),
                  validator: (value) => value.isEmpty ? '성을 입력해주세요.' : null,
                  onSaved: (value) => _lastName = value,
                  style: TextStyle(fontSize: 24),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: '이름'),
                  validator: (value) => value.isEmpty ? '이름을 입력해주세요.' : null,
                  onSaved: (value) => _firstName = value,
                  style: TextStyle(fontSize: 24),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: '이메일'),
                  validator: (value) => value.isEmpty ? '이메일을 입력해주세요.' : null,
                  onSaved: (value) => _email = value,
                  style: TextStyle(fontSize: 24),
                ),
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
                    document: gql(createAccountMutation),
                    update: (GraphQLDataProxy cache, QueryResult result) {
                      return cache;
                    },
                    onCompleted: (dynamic resultData) async {
                      if (!resultData['createAccount']['ok']) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "${resultData['createAccount']['error']}")));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "${resultData['createAccount']['username']}님 가입이 완료되었습니다!")));
                        Navigator.pop(context);
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
                        '회원가입',
                        style: TextStyle(fontSize: 24),
                      ),
                      onPressed: () => {
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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('$_username님으로 회원가입하는 중...')));
      return true;
    }
    return false;
  }
}
