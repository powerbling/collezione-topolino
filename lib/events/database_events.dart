import 'package:collezione_topolino/models/physical_copy.dart';

abstract class DatabaseEvent {}

class AddEvent extends DatabaseEvent {
  final PhysicalCopy _copy;

  PhysicalCopy get copy => _copy;

  AddEvent(PhysicalCopy copy) : _copy = copy;
}

class RemoveEvent extends DatabaseEvent {
  final int _id;

  int get id => _id;

  RemoveEvent(int id) : _id = id;
}

class ClearEvent extends DatabaseEvent {
  final int _number;

  int get number => _number;

  ClearEvent(int number) : _number = number;
}

class UpdateEvent extends DatabaseEvent {
  final PhysicalCopy _copy;

  PhysicalCopy get copy => _copy;

  UpdateEvent(PhysicalCopy copy) : _copy = copy;
}

abstract class FetchEvent extends DatabaseEvent {}

class FetchAllEvent extends FetchEvent {}

class FetchByIdEvent extends FetchEvent {
  final int _id;

  int get id => _id;

  FetchByIdEvent(int id) : _id = id;
}

class FetchByNumberEvent extends FetchEvent {
  final int _number;

  int get number => _number;

  FetchByNumberEvent(int number) : _number = number;
}
