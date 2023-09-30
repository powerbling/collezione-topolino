import 'package:collezione_topolino/models/issue.dart';
import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeInitialState extends HomeState {
  const HomeInitialState();

  @override
  List<Object?> get props => [];
}

class HomeLoadingState extends HomeState {
  const HomeLoadingState();

  @override
  List<Object?> get props => [];
}

class HomeErrorFetchingState extends HomeState {
  final Object? error;
  const HomeErrorFetchingState({
    this.error,
  });

  @override
  List<Object?> get props => [];
}

class HomeSuccessFetchingState extends HomeState {
  final List<IssueBase> issues;
  const HomeSuccessFetchingState({
    required this.issues,
  });

  @override
  List<Object?> get props => [];
}
