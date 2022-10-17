import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:collezione_topolino/models/publication.dart';

class CopyDisplay extends StatelessWidget {
  final Publication copy;
  final int amount;

  const CopyDisplay({
    Key? key,
    required this.copy,
    required this.amount,
  }) : super(key: key);

  static const double imageHeight = 105.0;

  // Icons need to be mapped because object properties
  // cannot be dynamically retrieved
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
    final Border border;

    if (amount == 0) {
      border = Border.all(
        color: Colors.transparent,
        width: 3.5,
      );
    } else {
      border = Border.all(
        color: Theme.of(context).primaryColorDark,
        // Colors.yellow[700]!,
        width: 3.5,
      );
    }
    return Expanded(
      child: Container(
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
        width: imageHeight * 0.76,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: copy.imgUrl,
              placeholder: (context, url) =>
                  Image.asset('assets/placeholder_topolino.png'),
              imageBuilder: (context, imageProvider) {
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.fitWidth,
                    ),
                    border: Border.all(
                      strokeAlign: StrokeAlign.inside,
                      color: Colors.grey[600]!,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                );
              },
            ),
            amount > 0
                ? Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorDark,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                        ),
                      ),
                      transform: Matrix4.translationValues(1.0, 1.0, 0.0),
                      padding: const EdgeInsets.fromLTRB(
                        4.0,
                        4.0,
                        2.0,
                        2.0,
                      ),
                      child: Icon(
                        iconMap[amount] ?? Icons.filter_9_plus_outlined,
                        color: Colors.grey[50]!,
                        size: 20.0,
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
