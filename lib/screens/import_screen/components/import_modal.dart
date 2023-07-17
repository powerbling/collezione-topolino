import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:collezione_topolino/models/physical_copy.dart';
import 'package:collezione_topolino/services/import.dart';
import '../../../components/copies_list.dart';
import '../../../components/copies_list_entry.dart';
import '../../../services/database.dart';
import '../../issue_screen/components/issue_info.dart';

class ImportModal extends StatelessWidget {
  final ImportConfirmation _confirmation;

  const ImportModal({
    super.key,
    required ImportConfirmation confirmation,
  }) : _confirmation = confirmation;

  get copy => _confirmation.copy;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Conferma"),
      content: Column(
        children: [
          const Text(
              "Questo numero ha copie gia' presenti nella tua collezione."),
          const IssueInfo(),
          const Text("Le copie che hai gia':"),
          Consumer<DatabaseConnection>(
            builder: (context, connection, child) {
              return FutureBuilder<List<PhysicalCopy?>>(
                  future: connection.fetchByNumber(copy.number),
                  builder: (context, snapshot) {
                    final copies = snapshot.data!;

                    return CopiesList(copies: copies);
                  });
            },
          ),
          const Text("La copia da inserire:"),
          CopiesListEntry(copy: copy, index: 1),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => _confirmation.skip(), child: const Text("Scarta")),
        TextButton(
            onPressed: () => _confirmation.confirm(),
            child: const Text("Inserisci")),
      ],
    );
  }
}
