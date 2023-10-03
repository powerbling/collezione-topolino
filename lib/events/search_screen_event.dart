import 'package:equatable/equatable.dart';

abstract class SearchScreenEvent extends Equatable {
  const SearchScreenEvent();
}

class SearchScreenFetchDataEvent extends SearchScreenEvent {
  final int issueNumber;
  const SearchScreenFetchDataEvent({
    required this.issueNumber,
  });

  @override
  List<Object?> get props => [];
}

class SearchScreenEmptySearchEvent extends SearchScreenEvent {
  const SearchScreenEmptySearchEvent();

  @override
  List<Object?> get props => [];
}
