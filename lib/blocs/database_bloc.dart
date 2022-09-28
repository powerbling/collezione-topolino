import 'dart:async';

import 'package:collezione_topolino/events/database_events.dart';
import 'package:collezione_topolino/models/physical_copy.dart';
import 'package:collezione_topolino/services/database.dart';
import 'package:rxdart/rxdart.dart';

class DatabaseBloc {
  late DatabaseConnection _connection;

  // BehaviorSubject caches last value added so it's saved for
  // when the stream is listened to
  final _stateController = BehaviorSubject<List<PhysicalCopy?>>();
  StreamSink<List<PhysicalCopy?>> get _resultSink => _stateController.sink;

  Stream<List<PhysicalCopy?>> get result => _stateController.stream;

  final _eventController = StreamController<DatabaseEvent>();

  Sink<DatabaseEvent> get querySink => _eventController.sink;

  DatabaseBloc() {
    _connection = DatabaseConnection();

    _eventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(DatabaseEvent event) async {
    if (event is AddEvent) {
      await _connection.insertCopy(
        event.copy,
      );
    } else if (event is RemoveEvent) {
      await _connection.removeCopy(
        event.id,
      );
    } else if (event is ClearEvent) {
      await _connection.removeAllByNumber(
        event.number,
      );
    } else if (event is UpdateEvent) {
      await _connection.updateCopy(
        event.copy,
      );
    } else if (event is FetchAllEvent) {
      _resultSink.add(
        await _connection.fetchAllCopies(),
      );
    } else if (event is FetchByIdEvent) {
      _resultSink.add(
        [
          await _connection.fetchCopy(event.id),
        ],
      );
    } else if (event is FetchByNumberEvent) {
      _resultSink.add(
        await _connection.fetchByNumber(event.number),
      );
    }
  }

  void dispose() {
    _stateController.close();
    _eventController.close();
  }
}
