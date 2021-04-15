import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const String TOKEN = "token";
final storage = new FlutterSecureStorage();

class Config {
  static final HttpLink _httpLink =
      HttpLink('https://hanjul-back.herokuapp.com/graphql');

  static final AuthLink _authLink = AuthLink(getToken: () {
    return storage.read(key: TOKEN);
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
