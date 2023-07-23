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

  PhysicalCopy get copy => _confirmation.copy;

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 8.0),
        child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "Conferma",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Text(
                    "Questo numero ha copie gia' presenti nella tua collezione.",
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    copy.number.toString(),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Column(
                    children: [
                      const IssueInfo(),
                      const Text("Le copie che hai gia':"),
                      Consumer<DatabaseConnection>(
                        builder: (context, connection, child) {
                          return FutureBuilder<List<PhysicalCopy?>>(
                              future: connection.fetchByNumber(copy.number),
                              builder: (context, snapshot) {
                                if (snapshot.hasData &&
                                    snapshot.data!.isNotEmpty) {
                                  final copies = snapshot.data!;

                                  return CopiesList(copies: copies);
                                }
                                return const Placeholder();
                              });
                        },
                      ),
                      const Text("La copia da inserire:"),
                      CopiesListEntry(copy: copy, index: 0),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _confirmation.skip();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                    child: const Text("Scarta"),
                  ),
                  const SizedBox(width: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      _confirmation.confirm();
                      Navigator.of(context).pop();
                    },
                    child: const Text("Inserisci"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
