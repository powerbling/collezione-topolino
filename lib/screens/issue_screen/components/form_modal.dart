import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:collezione_topolino/blocs/database_bloc.dart';
import 'package:collezione_topolino/components/date_field.dart';
import 'package:collezione_topolino/events/database_events.dart';
import 'package:collezione_topolino/models/physical_copy.dart';

import '../services/functions.dart';

class FormModal extends StatefulWidget {
  const FormModal({
    Key? key,
    required this.issueNumber,
  }) : super(key: key);

  final int issueNumber;

  @override
  State<FormModal> createState() => _FormModalState();
}

class _FormModalState extends State<FormModal> {
  DateTime? _selectedDate;
  PhysicalCopyCondition? _copyCondition;

  @override
  void initState() {
    _selectedDate = DateTime.now();
    _copyCondition = PhysicalCopyCondition.good;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 30.0,
        ),
        Text(
          "Inserisci nuova copia per Topolino n. ${widget.issueNumber}",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Center(
          child: DateField(
            initialDate: DateTime.now(),
            onChanged: (newDate) {
              setState(() {
                _selectedDate = newDate;
              });
            },
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Condizioni della copia: "),
                PopupMenuButton<PhysicalCopyCondition>(
                  child: Row(
                    children: [
                      Text(
                        conditionString(_copyCondition!),
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const Icon(Icons.arrow_downward),
                    ],
                  ),
                  itemBuilder: (context) {
                    return PhysicalCopyCondition.values
                        .map((val) => PopupMenuItem(
                              value: val,
                              child: Text(conditionString(val)),
                            ))
                        .toList();
                  },
                  onSelected: (value) => setState(() {
                    _copyCondition = value;
                  }),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Center(
          child: ElevatedButton(
            child: const Text("Aggiungi alla collezione"),
            onPressed: () {
              // Add the new copy
              Provider.of<DatabaseBloc>(
                context,
                listen: false,
              ).querySink.add(
                    AddEvent(
                      PhysicalCopy(
                        condition: _copyCondition!,
                        dateAdded: _selectedDate!,
                        number: widget.issueNumber,
                      ),
                    ),
                  );

              // Force refresh for the UI
              forceFetch(context, widget.issueNumber);

              // Exit the modal
              Navigator.pop(context);
            },
          ),
        )
      ],
    );
  }
}
