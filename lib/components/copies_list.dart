import 'package:flutter/material.dart';

import 'package:collezione_topolino/models/physical_copy.dart';

import 'copies_list_entry.dart';

class CopiesList extends StatelessWidget {
  const CopiesList({
    Key? key,
    required this.copies,
    this.deletable = false,
  }) : super(key: key);

  final List<PhysicalCopy?> copies;
  final bool deletable;

  @override
  Widget build(BuildContext context) {
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
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: copies.length,
          itemBuilder: (context, index) {
            final copy = copies[index]!;

            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Theme.of(context).primaryColorLight,
                ),
                // Delete modal
                child: CopiesListEntry(
                  copy: copy,
                  index: index,
                  deletable: deletable,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
