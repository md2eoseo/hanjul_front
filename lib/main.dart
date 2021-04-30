import 'package:flutter/material.dart';
import 'package:hanjul_front/config.dart';
import 'package:hanjul_front/root_page.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

void main() async {
  await DotEnv.load();
  await initHiveForFlutter();
  runApp(MyApp(client: Config.client));
}

class MyApp extends StatelessWidget {
  final ValueNotifier<GraphQLClient> client;

  const MyApp({Key key, this.client}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
        client: client,
        child: CacheProvider(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: '한줄',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              primaryColor: Colors.grey[300],
              accentColor: Colors.black,
              snackBarTheme: SnackBarThemeData(
                backgroundColor: Colors.amber,
                contentTextStyle: TextStyle(fontSize: 20),
              ),
            ),
            home: Scaffold(
              body: RootPage(),
            ),
          ),
        ));
  }
}
