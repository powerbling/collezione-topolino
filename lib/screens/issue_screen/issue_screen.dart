import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// External components
import '../../components/copies_list.dart';
import '../../models/physical_copy.dart';
import '../../services/database.dart';
import 'components/form_modal.dart';
import 'components/issue_info.dart';

class IssueScreen extends StatelessWidget {
  final int issueNumber;

  const IssueScreen({
    Key? key,
    required this.issueNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Topolino n. $issueNumber"),
      ),
      body: ListView(
        children: [
          const IssueInfo(),
          Consumer<DatabaseConnection>(
            builder: (context, connection, child) {
              return FutureBuilder<List<PhysicalCopy?>>(
                future: connection.fetchByNumber(issueNumber),
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
                      issueNumber: issueNumber,
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
