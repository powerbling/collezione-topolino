import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:collezione_topolino/blocs/database_bloc.dart';
import 'package:collezione_topolino/events/database_events.dart';
import 'package:collezione_topolino/models/physical_copy.dart';

import '../services/functions.dart';

class CopiesList extends StatelessWidget {
  const CopiesList({
    Key? key,
    required this.issueNumber,
  }) : super(key: key);

  final int issueNumber;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMd('it_IT');

    return StreamBuilder<List<PhysicalCopy?>>(
      stream: context.watch<DatabaseBloc>().result,
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
                style: Theme.of(context).textTheme.headline6,
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

                        // Request remove event to database controller
                        Provider.of<DatabaseBloc>(
                          context,
                          listen: false,
                        ).querySink.add(RemoveEvent(copy.id!));
                        // Fetch to refresh UI
                        forceFetch(context, issueNumber);
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
  }
}
