import 'package:collezione_topolino/blocs/database_bloc.dart';
import 'package:collezione_topolino/blocs/issue_bloc.dart';
import 'package:collezione_topolino/blocs/publication_bloc.dart';
import 'package:collezione_topolino/services/api.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'package:collezione_topolino/screens/home/home.dart';

void main() {
  // Initialize date formatting
  initializeDateFormatting();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<IssueBloc>(
          create: (_) => IssueBloc(API()),
        ),
        Provider<PublicationBloc>(
          create: (_) => PublicationBloc(API()),
        ),
        Provider<DatabaseBloc>(
          create: (_) => DatabaseBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Collezione Topolino',
        theme: ThemeData(
          primarySwatch: Colors.yellow,
        ),
        home: const MyHome(),
      ),
    );
  }
}
