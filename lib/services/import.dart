import 'dart:async';
import 'dart:io';

import 'package:collezione_topolino/models/physical_copy.dart';
import 'package:collezione_topolino/services/database.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class StoreFormatException extends FormatException {
  StoreFormatException(String message) : super(message);
}

class StoreNotFoundException implements Exception {
  final String? message;
  final String? path;
  StoreNotFoundException(this.message, this.path);

  @override
  String toString() {
    String result = "StoreNotFoundException";
    if (path != null) result = "$result at $path";
    if (message != null) result = "$result: $message";
    return result;
  }
}

class ImportConfirmation {
  final Completer<bool> _completer = Completer<bool>();
  final PhysicalCopy copy;

  ImportConfirmation({required this.copy});

  Future<bool> confirmation() {
    return _completer.future;
  }

  void confirm() {
    _completer.complete(true);
  }

  void skip() {
    _completer.complete(false);
  }
}

class StoreImporter {
  Database? _store;
  final DatabaseConnection _dbConn;
  final String _storePath;

  StoreImporter(this._dbConn, this._storePath) {
    if (extension(_storePath) != '.topo' && extension(_storePath) != '.db') {
      throw StoreFormatException('The selected file is not valid');
    }
    if (!File(_storePath).existsSync()) {
      throw StoreNotFoundException(
          'The selected path is not valid', _storePath);
    }
  }

  Future<Database> get store async => _store ??= await initStore();

  Future<Database> initStore() async {
    return await openDatabase(
      _storePath,
      version: 1,
      // readOnly: true,
    );
  }

  Future<List<PhysicalCopy>> fetchStoreCopies() async {
    final st = await store;

    final List<Map<String, dynamic>> asMaps = await st.query('Copies');

    return List.generate(asMaps.length, (i) => PhysicalCopy.fromMap(asMaps[i]));
  }

  void registerCopy(PhysicalCopy copy) {
    // Purge id to avoid db collision
    final insertable = PhysicalCopy.fromOther(copy);
    _dbConn.insertCopy(insertable);
  }

  Stream<ImportConfirmation> executeMerge() async* {
    final copies = await fetchStoreCopies();

    for (PhysicalCopy c in copies) {
      // Check for already present copies
      final tweens = await _dbConn.fetchByNumber(c.number);
      if (tweens.isEmpty) registerCopy(c);

      final importConfirmation = ImportConfirmation(copy: c);
      yield importConfirmation;

      // Wait for user to confirm or reject the merge
      if (await importConfirmation.confirmation()) registerCopy(c);
    }
  }
}
