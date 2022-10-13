import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:collezione_topolino/models/physical_copy.dart';
import 'package:collezione_topolino/models/publication.dart';
import 'package:collezione_topolino/services/database.dart';

class CopyDisplay extends StatelessWidget {
  final Publication copy;

  const CopyDisplay({
    Key? key,
    required this.copy,
  }) : super(key: key);

  static const double imageHeight = 105.0;

  static const iconMap = {
    1: Icons.filter_1_outlined,
    2: Icons.filter_2_outlined,
    3: Icons.filter_3_outlined,
    4: Icons.filter_4_outlined,
    5: Icons.filter_5_outlined,
    6: Icons.filter_6_outlined,
    7: Icons.filter_7_outlined,
    8: Icons.filter_8_outlined,
    9: Icons.filter_9_outlined,
  };

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<DatabaseConnection>(
        builder: (context, connection, child) =>
            FutureBuilder<List<PhysicalCopy?>>(
                future: connection.fetchByNumber(copy.number),
                builder: (context, snapshot) {
                  final Border border;

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    border = Border.all(
                      color: Colors.transparent,
                      width: 3.5,
                    );
                  } else {
                    border = Border.all(
                      color: Colors.yellow[700]!,
                      width: 3.5,
                    );
                  }

                  return Container(
                    decoration: BoxDecoration(
                      border: border,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 2.0,
                          color: Colors.grey,
                          offset: Offset(1.0, 1.0),
                          spreadRadius: -2.5,
                        ),
                      ],
                      borderRadius: const BorderRadius.all(
                        Radius.circular(3.0),
                      ),
                    ),
                    height: imageHeight,
                    width: imageHeight * 0.75,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        child!,
                        snapshot.hasData && snapshot.data!.isNotEmpty
                            ? Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.yellow[700],
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(5.0),
                                    ),
                                  ),
                                  padding: const EdgeInsets.fromLTRB(
                                    4.0,
                                    4.0,
                                    2.0,
                                    2.0,
                                  ),
                                  child: Icon(
                                    iconMap[snapshot.data!.length] ??
                                        Icons.filter_9_plus_outlined,
                                    color: Colors.grey[50]!,
                                    size: 20.0,
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  );
                }),
        child: CachedNetworkImage(
          imageUrl: copy.imgUrl,
          imageBuilder: (context, imageProvider) {
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.fitWidth,
                ),
                border: Border.all(
                  color: Colors.grey[600]!,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
            );
          },
        ),
      ),
    );
  }
}
