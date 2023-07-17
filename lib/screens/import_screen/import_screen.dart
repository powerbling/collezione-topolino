import 'package:collezione_topolino/screens/import_screen/components/import_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

import 'package:collezione_topolino/blocs/issue_bloc.dart';
import 'package:collezione_topolino/services/database.dart';
import 'package:collezione_topolino/services/import.dart';

class ImportScreen extends StatefulWidget {
  const ImportScreen({super.key});

  @override
  State<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends State<ImportScreen> {
  static const String _defaultText = "Nessun file selezionato";
  final TextEditingController _textController =
      TextEditingController(text: _defaultText);

  String? _selectedPath;

  Future<void> Function() _importLogic(BuildContext context) {
    final dbConn = Provider.of<DatabaseConnection>(context);

    final StoreImporter importer;

    try {
      importer = StoreImporter(dbConn, _selectedPath!);
    } on FormatException {
      return () async {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Il file non e' valido"),
                content: const Text("Selezionare un altro file e riprovare."),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Ok"))
                ],
              );
            });
      };
    }

    return () async {
      importer.executeMerge().listen((c) {
        final copy = c.copy;
        // Query api
        Provider.of<IssueBloc>(
          context,
          listen: false,
        ).query.sink.add(copy.number);

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return ImportModal(confirmation: c);
          },
        );
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Importa una collezione"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Center(
            child: ListView(
          children: [
            Row(
              children: [
                const Text("File:"),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
                    child: TextField(
                  enabled: false,
                  controller: _textController,
                  onChanged: (_) {},
                )),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            ElevatedButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['topo', 'db'],
                );

                setState(() {
                  _selectedPath = result?.files.single.path;
                  _textController.text = _selectedPath ?? _defaultText;
                });
              },
              child: const Text("Seleziona file"),
            ),
            const SizedBox(
              height: 10.0,
            ),
            ElevatedButton(
              onPressed: _selectedPath == null ? null : _importLogic(context),
              child: const Text("Importa"),
            ),
          ],
        )),
      ),
    );
  }
}
