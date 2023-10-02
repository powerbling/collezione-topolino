import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class HomeFetchDataEvent extends HomeEvent {
  const HomeFetchDataEvent();

  @override
  List<Object?> get props => [];
}
