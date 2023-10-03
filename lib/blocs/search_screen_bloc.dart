import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:collezione_topolino/events/search_screen_event.dart';
import 'package:collezione_topolino/services/api.dart';
import 'package:collezione_topolino/state/search_screen_state.dart';

class SearchScreenBloc extends Bloc<SearchScreenEvent, SearchScreenState> {
  SearchScreenBloc() : super(const SearchScreenInitialState()) {
    on<SearchScreenFetchDataEvent>(_onFetchDataEvent);
    on<SearchScreenEmptySearchEvent>(
      (event, emit) => emit(const SearchScreenInitialState()),
    );
  }

  void _onFetchDataEvent(
    SearchScreenFetchDataEvent event,
    Emitter<SearchScreenState> emitter,
  ) async {
    emitter(const SearchScreenLoadingState());

    await API
        .fetchIssue(event.issueNumber)
        .then(
          (issue) => emitter(SearchScreenSuccessFetchingState(issue: issue)),
        )
        .onError(
          (error, stackTrace) =>
              emitter(SearchScreenErrorFetchingState(error: error)),
        );
  }
}
