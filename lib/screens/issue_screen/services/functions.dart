import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:collezione_topolino/blocs/database_bloc.dart';
import 'package:collezione_topolino/events/database_events.dart';

void forceFetch(BuildContext context, int issueNumber) {
  Provider.of<DatabaseBloc>(
    context,
    listen: false,
  ).querySink.add(
        FetchByNumberEvent(issueNumber),
      );
}
