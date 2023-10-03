import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'package:collezione_topolino/blocs/home_bloc.dart';
import 'package:collezione_topolino/blocs/issue_screen_bloc.dart';
import 'package:collezione_topolino/blocs/search_screen_bloc.dart';
import 'package:collezione_topolino/services/database.dart';
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
        Provider<HomeBloc>(
          create: (_) => HomeBloc(),
        ),
        Provider<IssueScreenBloc>(
          create: (_) => IssueScreenBloc(),
        ),
        Provider<SearchScreenBloc>(
          create: (_) => SearchScreenBloc(),
        ),
        ChangeNotifierProvider(
          create: (_) => DatabaseConnection(),
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
