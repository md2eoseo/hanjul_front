// import 'dart:html' as html;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Config {
  static final storage = new FlutterSecureStorage();

  static final HttpLink _httpLink = HttpLink(env['SERVER_URL']);

  static final AuthLink _authLink = AuthLink(getToken: () {
    // if (!kIsWeb)
    return storage.read(key: env['TOKEN']);
    // else
    //   return html.window.localStorage.containsKey('TOKEN')
    //       ? html.window.localStorage['TOKEN']
    //       : null;
  });

  static final Link _link = _authLink.concat(_httpLink);

  static final ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: _link,
      cache: GraphQLCache(store: HiveStore()),
    ),
  );
}
