import 'dart:async' show Stream;

import 'package:collezione_topolino/models/publication.dart';
import 'package:collezione_topolino/services/api.dart';
import 'package:rxdart/rxdart.dart';

class PublicationBloc {
  final API api;

  final ReplaySubject<List<Publication>> _controller =
      ReplaySubject(maxSize: 3);

  Stream<List<Publication>> get _results => _controller.stream;

  Stream<List<Publication>> get results => _results;

  PublicationBloc(this.api) {
    Stream.fromFuture(api.fetchPublications()).listen((event) {
      _controller.sink.add(event);
    });
  }
}
