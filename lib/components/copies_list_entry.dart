import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:collezione_topolino/models/physical_copy.dart';
import 'package:collezione_topolino/services/database.dart';

class CopiesListEntry extends StatelessWidget {
  CopiesListEntry({
    super.key,
    required this.copy,
    required this.index,
    this.deletable = false,
    DateFormat? dateFormat,
  }) : dateFormat = dateFormat ?? DateFormat.yMd('it_IT');

  final DateFormat dateFormat;
  final PhysicalCopy copy;
  final bool deletable;
  final int index;

  Future<void> Function() _deleteDialog(
    BuildContext context,
    PhysicalCopy copy,
  ) {
    return () async {
      // Access it before any async method otherwise flutter wines
      final dbConn = Provider.of<DatabaseConnection>(context);

      bool confirm = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Conferma"),
          content: const Text("Sei sicuro di voler rimuovere questa copia?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Annulla"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Elimina"),
            ),
          ],
        ),
      );
      // Exit if not confirmed
      if (!confirm) return;

      // Remove from database
      dbConn.removeCopy(copy.id!);
    };
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Theme.of(context).primaryColorLight,
        ),
        child: ListTile(
          onLongPress: deletable ? _deleteDialog(context, copy) : null,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${index + 1}"),
              Text("Aggiunto: ${dateFormat.format(copy.dateAdded)}"),
              Text("Stato: ${conditionString(copy.condition)}"),
            ],
          ),
        ),
      ),
    );
  }
}
