import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:collezione_topolino/blocs/database_bloc.dart';
import 'package:collezione_topolino/blocs/issue_bloc.dart';
import 'package:collezione_topolino/blocs/publication_bloc.dart';
import 'package:collezione_topolino/models/publication.dart';
import 'package:collezione_topolino/events/database_events.dart';
import 'package:collezione_topolino/components/order_select.dart';
import 'package:collezione_topolino/screens/issue_screen/issue_screen.dart';

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
              var data =
                  _orderBy != 0 ? snapshot.data : snapshot.data!.reversed;
              return GridView.count(
                  crossAxisCount: 3,
                  children: data!.map((e) {
                    return InkWell(
                      onTap: () {
                        // Load data from api
                        Provider.of<IssueBloc>(
                          context,
                          listen: false,
                        ).query.sink.add(e.number);
                        // Load data from database
                        Provider.of<DatabaseBloc>(
                          context,
                          listen: false,
                        ).querySink.add(
                              FetchByNumberEvent(e.number),
                            );
                        // Push view
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                IssueScreen(issueNumber: e.number),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          CachedNetworkImage(
                            imageUrl: e.imgUrl,
                            height: 100.0,
                          ),
                          Text(
                            "${e.number}",
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    );
                  }).toList());
            },
          ),
        ),
      ],
    );
  }
}
