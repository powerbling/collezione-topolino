import 'dart:async';

import 'package:collezione_topolino/models/issue.dart';
import 'package:collezione_topolino/services/api.dart';

class IssueBloc {
  final API api;

  final StreamController<int> _query = StreamController();
  Stream<Issue> _selected = const Stream.empty();

  StreamController<int> get query => _query;
  Stream<Issue> get selected => _selected;

  IssueBloc(this.api) {
    _selected = _query.stream.asyncMap(api.fetchIssue).asBroadcastStream();
  }

  void dispose() {
    _query.close();
  }
}
