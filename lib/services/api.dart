import 'package:collezione_topolino/models/issue.dart';
import 'package:collezione_topolino/models/publication.dart';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:intl/intl.dart';

class API {
  static const String _baseUrl = "https://inducks.org/";
  static const String _publicationUrl =
      "${_baseUrl}publication.php?pg=img&c=it/TL";

  static const String _issueUrl = "${_baseUrl}issue.php?c=it%2FTL";

  static final DateFormat dateFormatFull = DateFormat('yyyy-MM-dd');
  static final DateFormat dateFormatReduced = DateFormat('yyyy-MM');

  Future<List<Publication>> fetchPublications() async {
    List<Publication> publications = [];

    RegExp regExp = RegExp(r"^\d+$");

    await http
        .get(Uri.parse(_publicationUrl))
        .then((res) => res.body)
        .then(parse)
        .then((html) => html.querySelectorAll('body > table > tbody > tr > td'))
        // ignore: avoid_function_literals_in_foreach_calls
        .then((elmts) => elmts.forEach((e) {
              // Select the two useful elements
              var link = e.querySelector("a:nth-child(2)");
              var image = e.querySelector("img");

              // Shortcut if any is null
              if (link == null || image == null) return;

              if (regExp.hasMatch(link.innerHtml)) {
                try {
                  publications.add(
                    Publication(
                      number: int.parse(link.innerHtml),
                      url: _baseUrl + (link.attributes['href'] ?? ""),
                      imgUrl: _baseUrl + (image.attributes['src'] ?? ""),
                    ),
                  );
                } on FormatException {
                  return;
                }
              }
            }));
    return publications;
  }

  Future<Issue> fetchIssue(int toFetch) async {
    int? number;
    String? imageUrl;
    String? imageHRUrl;
    DateTime? dateTime;

    await http
        .get(Uri.parse(
            _issueUrl + toFetch.toString().padLeft(5, '+'))) // Compose url
        .then((res) => res.body)
        .then(parse)
        .then((html) {
      number = int.tryParse(
        html
                .querySelector("body > header > div > h1")
                ?.innerHtml
                .split('#')[1] ??
            "",
      );

      imageUrl = html
          .querySelector(".issueImageHighlight figure > img")
          ?.attributes['src'];

      imageHRUrl = html
          .querySelector(".issueImageHighlight figure figcaption a")
          ?.attributes['href'];

      final dateString = html
          .querySelector('.generalIssueInformation time')
          ?.attributes['datetime'];

      try {
        dateTime = dateFormatFull.parse(dateString ?? "");
      } on FormatException {
        try {
          dateTime = dateFormatReduced.parse(dateString ?? "");
        } on FormatException {
          dateTime = null;
        }
      }
    });

    if (number == null || imageUrl == null || dateTime == null) {
      throw Exception("Could not fetch issue.");
    }

    return Issue(
      number: number ?? 0,
      dateTime: dateTime ?? DateTime.now(),
      imgUrl: imageUrl != null
          ? _baseUrl + (imageUrl!)
          : "http://via.placeholder.com/150",
      imgHRUrl: imageHRUrl != null ? _baseUrl + (imageHRUrl!) : null,
    );
  }
}
