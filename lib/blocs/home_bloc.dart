import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:collezione_topolino/events/home_event.dart';
import 'package:collezione_topolino/services/api.dart';
import 'package:collezione_topolino/state/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeInitialState()) {
    on<HomeFetchDataEvent>(_onFetchDataEvent);
  }

  void _onFetchDataEvent(
    HomeFetchDataEvent event,
    Emitter<HomeState> emitter,
  ) async {
    emitter(const HomeLoadingState());

    await API
        .fetchAllIssues()
        .then(
          (issues) => emitter(HomeSuccessFetchingState(issues: issues)),
        )
        .onError(
          (error, stackTrace) => emitter(HomeErrorFetchingState(error: error)),
        );
  }
}
