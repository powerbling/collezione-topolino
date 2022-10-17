import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:collezione_topolino/blocs/issue_bloc.dart';
import 'package:collezione_topolino/models/physical_copy.dart';
import 'package:collezione_topolino/models/publication.dart';
import 'package:collezione_topolino/screens/issue_screen/issue_screen.dart';

import 'copy_display.dart';

class CopiesGrid extends StatelessWidget {
  final Iterable<Publication>? issues;
  final List<PhysicalCopy?>? copies;

  const CopiesGrid({
    super.key,
    this.issues,
    this.copies,
  });

  static int copyCount(List<PhysicalCopy?>? copies, int number) {
    return copies?.where((e) => e?.number == number).length ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 3,
        children: issues!.map((element) {
          final amount = copyCount(copies, element.number);
          return Padding(
            padding: const EdgeInsets.all(2.0),
            child: Center(
              child: InkWell(
                onTap: () {
                  // Load data from api
                  Provider.of<IssueBloc>(
                    context,
                    listen: false,
                  ).query.sink.add(element.number);
                  // Push view
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          IssueScreen(issueNumber: element.number),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        amount > 0 ? Theme.of(context).backgroundColor : null,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Column(
                    children: [
                      CopyDisplay(
                        copy: element,
                        amount: amount,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2.0,
                          horizontal: 5.0,
                        ),
                        child: Text(
                          "${element.number}",
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList());
  }
}
