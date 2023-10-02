import 'package:collezione_topolino/events/issue_screen_event.dart';
import 'package:collezione_topolino/services/api.dart';
import 'package:collezione_topolino/state/issue_screen_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class IssueScreenBloc extends Bloc<IssueScreenEvent, IssueScreenState> {
  IssueScreenBloc() : super(const IssueScreenLoadingState()) {
    on<IssueScreenFetchDataEvent>(_onFetchDataEvent);
  }

  void _onFetchDataEvent(
    IssueScreenFetchDataEvent event,
    Emitter<IssueScreenState> emitter,
  ) async {
    emitter(const IssueScreenLoadingState());

    await API
        .fetchIssue(event.issueNumber)
        .then(
          (issue) => emitter(IssueScreenSuccessFetchingState(issue: issue)),
        )
        .onError((error, stackTrace) =>
            emitter(IssueScreenErrorFetchingState(error: error)));
  }
}
