import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:collezione_topolino/models/issue.dart';

class Poster extends StatelessWidget {
  const Poster({
    Key? key,
    required this.issue,
  }) : super(key: key);

  final Issue? issue;
  static const double correctHeight = 450.0;
  static const double correctWidth = correctHeight * 0.739; // Correct aspect-ratio

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CachedNetworkImage(
        imageUrl: issue?.imgHRUrl ?? "",
        placeholder: (context, url) => CachedNetworkImage(
          // Use lower resolution image as placeholder to avoid
          // too much visible buffering
          imageUrl: issue?.imgUrl ?? "",
          placeholder: (context, url) => const SizedBox(
            height: correctHeight,
            width: correctWidth,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          imageBuilder: imageBuilder,
        ),
        imageBuilder: imageBuilder,
      ),
    );
  }

  Padding imageBuilder(
    BuildContext context,
    ImageProvider<Object> imageProvider,
  ) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: correctHeight,
        width: correctWidth,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.fitWidth,
          ),
          boxShadow: const [
            BoxShadow(
                blurRadius: 10.0, color: Colors.grey, offset: Offset(5.0, 5.0)),
          ],
          border: Border.all(
            color: Colors.grey[600]!,
            width: 3.0,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
      ),
    );
  }
}
