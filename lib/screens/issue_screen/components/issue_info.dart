
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:collezione_topolino/blocs/issue_bloc.dart';
import 'package:collezione_topolino/models/issue.dart';

import 'poster.dart';

class IssueInfo extends StatelessWidget {
  const IssueInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMMEEEEd('it_IT');

    return StreamBuilder<Issue>(
      stream: context.watch<IssueBloc>().selected,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text("Impossibile caricare..."),
          );
        }
        final issue = snapshot.data;
        return Column(
          children: [
            const SizedBox(height: 20.0),
            Poster(issue: issue),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                "Data di uscita: ${dateFormat.format(issue!.dateTime)}",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        );
      },
    );
  }
}