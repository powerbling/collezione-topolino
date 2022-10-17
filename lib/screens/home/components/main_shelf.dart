import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:collezione_topolino/blocs/publication_bloc.dart';
import 'package:collezione_topolino/models/publication.dart';
import 'package:collezione_topolino/models/physical_copy.dart';
import 'package:collezione_topolino/services/database.dart';
import 'package:collezione_topolino/components/order_select.dart';

import 'copies_grid.dart';

class MainShelf extends StatefulWidget {
  const MainShelf({Key? key}) : super(key: key);

  @override
  State<MainShelf> createState() => _MainShelfState();
}

class _MainShelfState extends State<MainShelf> {
  int _orderBy = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OrderSelect(onChanged: (value) {
          setState(() {
            _orderBy = value;
          });
        }),
        Expanded(
          child: StreamBuilder<List<Publication>>(
            stream: context.watch<PublicationBloc>().results,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Errore, impossibile caricare i dati: ${snapshot.error}",
                    textAlign: TextAlign.center,
                  ),
                );
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final data = _orderBy != 0
                  ? snapshot.data
                  : snapshot.data!.reversed.toList();
              return Consumer<DatabaseConnection>(
                builder: (context, connection, child) =>
                    FutureBuilder<List<PhysicalCopy?>>(
                  future: connection.fetchAllCopies(),
                  initialData: const [],
                  builder: (context, snapshot) {
                    return CopiesGrid(
                      issues: data,
                      copies: snapshot.data,
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
