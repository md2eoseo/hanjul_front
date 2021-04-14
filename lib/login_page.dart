import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    void validateAndSave() {
      final form = formKey.currentState;
      if (form.validate()) {
        form.save();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$_username님으로 로그인하는 중... $_password')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('없는 로그인 정보입니다.')));
      }
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
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16)),
                child: Text(
                  '로그인',
                  style: TextStyle(fontSize: 24),
                ),
                onPressed: validateAndSave,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
