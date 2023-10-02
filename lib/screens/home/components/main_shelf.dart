import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:collezione_topolino/blocs/home_bloc.dart';
import 'package:collezione_topolino/events/home_event.dart';
import 'package:collezione_topolino/exceptions/explainable_exception.dart';
import 'package:collezione_topolino/models/issue.dart';
import 'package:collezione_topolino/state/home_state.dart';
import 'package:collezione_topolino/models/physical_copy.dart';
import 'package:collezione_topolino/services/database.dart';
import 'package:collezione_topolino/components/order_select.dart';
import 'package:collezione_topolino/components/custom_scroller.dart';

import 'copies_grid.dart';

class MainShelf extends StatefulWidget {
  const MainShelf({Key? key}) : super(key: key);

  @override
  State<MainShelf> createState() => _MainShelfState();
}

class _MainShelfState extends State<MainShelf> {
  int _orderBy = 0;
  final _scrollController = ScrollController();
  late HomeBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = context.read<HomeBloc>();
    bloc.add(const HomeFetchDataEvent()); // Immediatly fetch data
  }

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
          child: RefreshIndicator(
              // notificationPredicate: (notification) => notification.depth == 4,
              onRefresh: () =>
                  Future(() => bloc.add(const HomeFetchDataEvent())),
              child: BlocConsumer<HomeBloc, HomeState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is HomeLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is HomeErrorFetchingState) {
                    String errorString =
                        "Errore, impossibile caricare i dati: ";
                    // Throw the received error to use builtin exception handling
                    if (state.error is ExplainableException) {
                      errorString +=
                          (state.error as ExplainableException).explainer;
                    }

                    return LayoutBuilder(
                      builder: (context, constraints) => SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minHeight: constraints.maxHeight),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                errorString,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  if (state is HomeSuccessFetchingState) {
                    final List<IssueBase> data = _orderBy != 0
                        ? state.issues
                        : state.issues.reversed.toList();

                    return Consumer<DatabaseConnection>(
                      builder: (context, connection, child) =>
                          FutureBuilder<List<PhysicalCopy?>>(
                        future: connection.fetchAllCopies(),
                        initialData: const [],
                        builder: (context, snapshot) {
                          return CustomScroller(
                            totalAmount: data.length,
                            scrollController: _scrollController,
                            titleBuilder: (index) =>
                                (index == null) ? null : data[index].number,
                            child: CopiesGrid(
                              issues: data,
                              copies: snapshot.data,
                              scrollController: _scrollController,
                            ),
                          );
                        },
                      ),
                    );
                  }

                  return const Placeholder();
                },
              )

              //  StreamBuilder<List<Publication>>(
              //   stream: context.watch<PublicationBloc>().results,
              //   builder: (context, snapshot) {
              //     if (snapshot.hasError) {
              //       String errorString = "Errore, impossibile caricare i dati: ";
              //       // Throw the received error to use builtin exception handling
              //       try {
              //         throw snapshot.error!;
              //       } on ExplainableException catch (e) {
              //         errorString += e.explainer;
              //       } catch (e) {
              //         rethrow;
              //       }
              //       return LayoutBuilder(
              //         builder: (context, constraints) => SingleChildScrollView(
              //           physics: const AlwaysScrollableScrollPhysics(),
              //           scrollDirection: Axis.vertical,
              //           child: ConstrainedBox(
              //             constraints:
              //                 BoxConstraints(minHeight: constraints.maxHeight),
              //             child: Center(
              //               child: Padding(
              //                 padding: const EdgeInsets.all(15.0),
              //                 child: Text(
              //                   errorString,
              //                   textAlign: TextAlign.center,
              //                   style: Theme.of(context).textTheme.titleLarge,
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
              //       );
              //     }
              //     if (!snapshot.hasData) {
              //       return const Center(child: CircularProgressIndicator());
              //     }

              //     final List<Publication> data = _orderBy != 0
              //         ? snapshot.data!
              //         : snapshot.data!.reversed.toList();

              //     return Consumer<DatabaseConnection>(
              //       builder: (context, connection, child) =>
              //           FutureBuilder<List<PhysicalCopy?>>(
              //         future: connection.fetchAllCopies(),
              //         initialData: const [],
              //         builder: (context, snapshot) {
              //           return CustomScroller(
              //             totalAmount: data.length,
              //             scrollController: _scrollController,
              //             titleBuilder: (index) =>
              //                 (index == null) ? null : data[index].number,
              //             child: CopiesGrid(
              //               issues: data,
              //               copies: snapshot.data,
              //               scrollController: _scrollController,
              //             ),
              //           );
              //         },
              //       ),
              //     );
              //   },
              // ),
              ),
        ),
      ],
    );
  }
}
