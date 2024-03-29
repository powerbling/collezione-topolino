import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:collezione_topolino/models/issue.dart';
import 'package:collezione_topolino/screens/issue_screen/issue_screen.dart';

class ResultElement extends StatelessWidget {
  final Issue issue;

  const ResultElement({
    super.key,
    required this.issue,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Push view
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IssueScreen(issueNumber: issue.number),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 10.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 100.0,
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: issue.imgUrl ?? "http://invalid.url",
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        height: 100.0,
                        width: 100.0 * 0.739, // Correct aspect-ratio
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.fitWidth,
                          ),
                          boxShadow: const [
                            BoxShadow(
                                blurRadius: 2.0,
                                color: Colors.grey,
                                offset: Offset(1.0, 1.0)),
                          ],
                          border: Border.all(
                            color: Colors.grey[600]!,
                            width: 1.0,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(2.0),
                          ),
                        ),
                      );
                    },
                    placeholder: (context, url) => const SizedBox(
                      height: 100.0,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                          child: Text(
                        "Topolino n.${issue.number}",
                        style: Theme.of(context).textTheme.titleLarge,
                      )),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
