import 'package:equatable/equatable.dart';

abstract class IssueScreenEvent extends Equatable {
  const IssueScreenEvent();
}

class IssueScreenFetchDataEvent extends IssueScreenEvent {
  final int issueNumber;
  const IssueScreenFetchDataEvent({
    required this.issueNumber,
  });

  @override
  List<Object?> get props => [];
}
