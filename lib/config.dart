import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

final storage = new FlutterSecureStorage();

class Config {
  static final HttpLink _httpLink = HttpLink(env['SERVER_URL']);

  static final AuthLink _authLink = AuthLink(getToken: () {
    return storage.read(key: env['TOKEN']);
  });

  static final Link link = _authLink.concat(_httpLink);

  static ValueNotifier<GraphQLClient> initializeClient() {
    ValueNotifier<GraphQLClient> client = ValueNotifier(GraphQLClient(
      link: link,
      cache: GraphQLCache(store: HiveStore()),
    ));
    return client;
  }
}
