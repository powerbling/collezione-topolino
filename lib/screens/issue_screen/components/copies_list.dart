import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:collezione_topolino/services/database.dart';
import 'package:collezione_topolino/models/physical_copy.dart';

class CopiesList extends StatelessWidget {
  const CopiesList({
    Key? key,
    required this.issueNumber,
  }) : super(key: key);

  final int issueNumber;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMd('it_IT');

    return Consumer<DatabaseConnection>(
      builder: (context, connection, child) {
        return FutureBuilder<List<PhysicalCopy?>>(
          future: connection.fetchByNumber(issueNumber),
          builder: (context, snapshot) {
            // Indicate wether there is data
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                  child: Text(
                "No copie salvate",
                style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              ));
            }
            final copies = snapshot.data!;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 5.0,
                  ),
                  child: Text(
                    "Copie salvate:",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: copies.length,
                  itemBuilder: (context, index) {
                    final copy = copies[index]!;

                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Theme.of(context).primaryColorLight,
                        ),
                        child: ListTile(
                          onLongPress: () async {
                            bool confirm = await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Conferma"),
                                content: const Text(
                                    "Sei sicuro di voler rimuovere questa copia?"),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: Text("Annulla"),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: Text("Elimina"),
                                  ),
                                ],
                              ),
                            );
                            // Exit if not confirmed
                            if (!confirm) return;

                            // Remove from database
                            connection.removeCopy(copy.id!);
                          },
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("${index + 1}"),
                              Text(
                                  "Aggiunto: ${dateFormat.format(copy.dateAdded)}"),
                              Text("Stato: ${conditionString(copy.condition)}"),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
