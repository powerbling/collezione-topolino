import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class FetchDataEvent extends HomeEvent {
  const FetchDataEvent();

  @override
  List<Object?> get props => [];
}
