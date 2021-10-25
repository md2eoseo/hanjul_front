import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class PrivacyStorage {
  Future<String> readPrivacy() async {
    try {
      return rootBundle.loadString('assets/privacy.txt');
    } catch (e) {
      return "Loading Error...";
    }
  }
}

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({Key? key}) : super(key: key);

  @override
  _PrivacyPageState createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  String _text = '';

  @override
  void initState() {
    super.initState();
    PrivacyStorage().readPrivacy().then((String value) {
      setState(() {
        _text = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("개인정보처리방침"),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          child: Text(
            _text,
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }
}
