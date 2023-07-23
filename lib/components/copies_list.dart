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
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: copies.length,
      itemBuilder: (context, index) {
        final copy = copies[index]!;

        return CopiesListEntry(
          copy: copy,
          index: index,
          deletable: deletable,
        );
      },
    );
  }
}
