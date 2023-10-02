import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:collezione_topolino/blocs/issue_screen_bloc.dart';
import 'package:collezione_topolino/state/issue_screen_state.dart';

import 'poster.dart';

class IssueInfo extends StatelessWidget {
  const IssueInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMMEEEEd('it_IT');

    return BlocConsumer<IssueScreenBloc, IssueScreenState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is IssueScreenLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is IssueScreenErrorFetchingState) {
          return const Center(
            child: Text("Impossibile caricare..."),
          );
        }
        if (state is IssueScreenSuccessFetchingState) {
          return Column(
            children: [
              const SizedBox(height: 20.0),
              Poster(issue: state.issue),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Data di uscita: ${dateFormat.format(state.issue.dateTime)}",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          );
        }

        return const Placeholder();
      },
    );
  }
}
