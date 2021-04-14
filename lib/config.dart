import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Config {
  static final HttpLink _httpLink =
      HttpLink('https://hanjul-back.herokuapp.com/graphql');

  static final AuthLink _authLink = AuthLink(getToken: () async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("token");
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
