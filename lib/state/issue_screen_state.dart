import 'package:equatable/equatable.dart';

import 'package:collezione_topolino/models/issue.dart';

abstract class IssueScreenState extends Equatable {
  const IssueScreenState();
}

class IssueScreenLoadingState extends IssueScreenState {
  const IssueScreenLoadingState();

  @override
  List<Object?> get props => [];
}

class IssueScreenErrorFetchingState extends IssueScreenState {
  final Object? error;
  const IssueScreenErrorFetchingState({
    this.error,
  });

  @override
  List<Object?> get props => [];
}

class IssueScreenSuccessFetchingState extends IssueScreenState {
  final Issue issue;
  const IssueScreenSuccessFetchingState({
    required this.issue,
  });

  @override
  List<Object?> get props => [];
}
