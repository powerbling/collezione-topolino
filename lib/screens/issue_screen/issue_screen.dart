import 'package:collezione_topolino/blocs/issue_screen_bloc.dart';
import 'package:collezione_topolino/events/issue_screen_event.dart';
import 'package:collezione_topolino/state/issue_screen_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

// External components
import 'package:collezione_topolino/components/copies_list.dart';
import 'package:collezione_topolino/models/physical_copy.dart';
import 'package:collezione_topolino/services/database.dart';
import 'components/form_modal.dart';
import 'components/issue_info.dart';

class IssueScreen extends StatefulWidget {
  final int issueNumber;

  const IssueScreen({
    Key? key,
    required this.issueNumber,
  }) : super(key: key);

  @override
  State<IssueScreen> createState() => _IssueScreenState();
}

class _IssueScreenState extends State<IssueScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<IssueScreenBloc>()
        .add(IssueScreenFetchDataEvent(issueNumber: widget.issueNumber));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Topolino n. ${widget.issueNumber}"),
      ),
      body: BlocConsumer<IssueScreenBloc, IssueScreenState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is IssueScreenErrorFetchingState) {
            return Center(
              child:
                  Text("Impossibile caricare dati: ${state.error.toString()}"),
            );
          }
          if (state is IssueScreenSuccessFetchingState) {
            return ListView(
              children: [
                const IssueInfo(),
                Consumer<DatabaseConnection>(
                  builder: (context, connection, child) {
                    return FutureBuilder<List<PhysicalCopy?>>(
                      future: connection.fetchByNumber(widget.issueNumber),
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
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            CopiesList(
                              copies: copies,
                              deletable: true,
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 80.0,
                ),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Aggiungi copia",
        child: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => SizedBox(
              height: 300.0,
              child: Scaffold(
                body: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 20.0,
                    ),
                    child: FormModal(
                      issueNumber: widget.issueNumber,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
