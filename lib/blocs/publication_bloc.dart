import 'dart:async' show Stream;

import 'package:collezione_topolino/models/publication.dart';
import 'package:collezione_topolino/services/api.dart';

class PublicationBloc {
  final API api;

  Stream<List<Publication>> _results = const Stream.empty();

  Stream<List<Publication>> get results => _results;

  PublicationBloc(this.api) {
    _results = Stream.fromFuture(api.fetchPublications()).asBroadcastStream();
  }
}
