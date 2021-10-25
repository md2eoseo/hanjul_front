import 'package:flutter/material.dart';
import 'package:hanjul_front/config/client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:hanjul_front/pages/privacy.dart';
import 'package:hanjul_front/pages/root.dart';
import 'package:get/get.dart';

void main() async {
  await DotEnv.load(fileName: "dotenv");
  await initHiveForFlutter();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: CacheProvider(
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: '한줄',
          theme: ThemeData(
            fontFamily: 'Nanum Myeongjo',
            snackBarTheme: SnackBarThemeData(
              backgroundColor: Colors.green[300],
              contentTextStyle: TextStyle(fontSize: 20),
            ),
          ),
          home: RootPage(),
          routes: {
            '/privacy': (BuildContext context) => PrivacyPage(),
          },
        ),
      ),
    );
  }
}
