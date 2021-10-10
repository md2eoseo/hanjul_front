import 'package:hanjul_front/config/utils.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

final storage = new FlutterSecureStorage();

final HttpLink _httpLink = HttpLink(env['SERVER_URL']!);

final AuthLink _authLink = AuthLink(getToken: getToken);

Link _link = _authLink.concat(_httpLink);

final ValueNotifier<GraphQLClient> client = ValueNotifier(
  GraphQLClient(
    link: _link,
    cache: GraphQLCache(store: HiveStore()),
  ),
);
