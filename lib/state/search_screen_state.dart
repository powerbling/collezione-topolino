import 'package:equatable/equatable.dart';

import 'package:collezione_topolino/models/issue.dart';

abstract class SearchScreenState extends Equatable {
  const SearchScreenState();
}

class SearchScreenInitialState extends SearchScreenState {
  const SearchScreenInitialState();

  @override
  List<Object?> get props => [];
}

class SearchScreenLoadingState extends SearchScreenState {
  const SearchScreenLoadingState();

  @override
  List<Object?> get props => [];
}

class SearchScreenErrorFetchingState extends SearchScreenState {
  final Object? error;
  const SearchScreenErrorFetchingState({
    this.error,
  });

  @override
  List<Object?> get props => [];
}

class SearchScreenSuccessFetchingState extends SearchScreenState {
  final Issue issue;
  const SearchScreenSuccessFetchingState({
    required this.issue,
  });

  @override
  List<Object?> get props => [];
}

class SearchScreenEmptyResultState extends SearchScreenState {
  const SearchScreenEmptyResultState();

  @override
  List<Object?> get props => [];
}
