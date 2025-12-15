import 'dart:async';

import 'package:digimed/app/data/http/http.dart';
import 'package:digimed/app/domain/either/either.dart';
import 'package:digimed/app/domain/globals/logger.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

enum GraphQLMethod { query, mutation }

class GraphQLDigimed {
  GraphQLClient _client;
  final String _url;
  String? _token;

  GraphQLDigimed(
      {required GraphQLClient client, required String link, String? token})
      : _client = client,
        _url = link,
        _token = token;

  void refreshToken(String token) {
    print("refresh token: $token");
    final HttpLink httpLink = HttpLink(
      _url,
    );

    final AuthLink authLink = AuthLink(
      getToken: () async => 'Bearer $token',
    );

    _token = token;

    final Link link = authLink.concat(httpLink);
    _client = _client.copyWith(link: link);
  }

  String? getMyToken() {
    return _token;
  }

  Future<Either<HttpFailure, R>> request<R>(
      {required R Function(dynamic responseBody) onSuccess,
      GraphQLMethod method = GraphQLMethod.query,
      Map<String, dynamic> variables = const {},
      String body = ""}) async {
    late final QueryResult result;
    switch (method) {
      case GraphQLMethod.query:
        final QueryOptions options = QueryOptions(
            document: gql(body),
            fetchPolicy: FetchPolicy.noCache,
            variables: variables);

        result = await _client.query(options);
        break;
      case GraphQLMethod.mutation:
        final MutationOptions options = MutationOptions(
            document: gql(body),
            fetchPolicy: FetchPolicy.noCache,
            variables: variables);
        result = await _client
            .mutate(options)
            .timeout(const Duration(seconds: 60), onTimeout: () {
          throw TimeoutException('Tiempo de espera máximo superado.');
        });
        break;
    }
    if (result.hasException) {
      if (result.exception != null &&
          result.exception!.graphqlErrors.isNotEmpty) {
        logger.e(result.exception);
        if (result.exception!.linkException is NetworkException) {
          return Either.left(HttpFailure(exception: "network"));
        } else if (result.exception! is TimeoutException) {
          return Either.left(HttpFailure(exception: "time out"));
        }
        return Either.left(HttpFailure(
            errorGraphQlDigimed: result.exception!.graphqlErrors[0].message));
      }
      return Either.left(HttpFailure(exception: result.exception));
    } else {
      return Either.right(
        onSuccess(
          result.data,
        ),
      );
    }
  }
}
