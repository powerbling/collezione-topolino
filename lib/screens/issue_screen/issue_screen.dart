import 'package:flutter/material.dart';

// External components
import 'components/form_modal.dart';
import 'components/issue_info.dart';
import 'components/copies_list.dart';

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
          CopiesList(issueNumber: issueNumber),
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
