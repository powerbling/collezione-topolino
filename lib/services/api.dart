import 'package:collezione_topolino/exceptions/explainable_exception.dart';
import 'package:collezione_topolino/models/issue.dart';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:intl/intl.dart';

class BadDataFormatException
    with ExplainableException
    implements ExplainableException {
  final String? message;
  BadDataFormatException(this.message);

  @override
  String get explainer => "Il sito di origine non risponde correttamente.";
}

class ClientException extends http.ClientException with ExplainableException {
  ClientException(super.message);

  @override
  String get explainer => "Impossibile raggiungere il sito di origine";
}

class API {
  static const String _baseUrl = "https://inducks.org/";
  static const String _publicationUrl =
      "${_baseUrl}publication.php?pg=img&c=it/TL";

  static const String _issueUrl = "${_baseUrl}issue.php?c=it%2FTL";

  static final DateFormat dateFormatFull = DateFormat('yyyy-MM-dd');
  static final DateFormat dateFormatReduced = DateFormat('yyyy-MM');

  static Future<List<IssueBase>> fetchAllIssues() async {
    List<IssueBase> issues = [];

    RegExp regExp = RegExp(r"^\d+$");

    try {
      await http
          .get(Uri.parse(_publicationUrl))
          .then((res) => res.body)
          .then(parse)
          .then(
              (html) => html.querySelectorAll('body > table > tbody > tr > td'))
          .then((elmts) =>
              // If the element list is empty, that means the website does
              // not respond with the correct data.
              elmts.isEmpty
                  ? throw BadDataFormatException("Empty list")
                  : elmts)
          // ignore: avoid_function_literals_in_foreach_calls
          .then((elmts) => elmts.forEach((e) {
                // Select the two useful elements
                var link = e.querySelector("a:nth-child(2)");
                var image = e.querySelector("img");

                // Shortcut if any is null
                if (link == null) return;

                if (regExp.hasMatch(link.innerHtml)) {
                  try {
                    issues.add(
                      IssueBase(
                        number: int.parse(link.innerHtml),
                        url: _baseUrl + (link.attributes['href'] ?? ""),
                        imgUrl: image == null
                            ? null
                            : _baseUrl + (image.attributes['src'] ?? ""),
                      ),
                    );
                  } on FormatException {
                    // This means the selected link is not valid
                    // and that it is not needed
                    return;
                  }
                }
              }));
    } catch (e) {
      var error = e;
      if (error is http.ClientException) {
        error = ClientException(error.message);
      }
      return Future.error(error);
    }

    return issues;
  }

  static Future<Issue> fetchIssue(int toFetch) async {
    int? number;
    String? imageUrl;
    String? imageHRUrl;
    DateTime? dateTime;

    try {
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
        throw BadDataFormatException("Could not fetch issue.");
      }

      return Issue(
        number: number ?? 0,
        url: _issueUrl + toFetch.toString().padLeft(5, '+'),
        dateTime: dateTime ?? DateTime.now(),
        imgUrl: imageUrl != null ? _baseUrl + (imageUrl!) : null,
        imgHRUrl: imageHRUrl != null ? _baseUrl + (imageHRUrl!) : null,
      );
    } catch (e) {
      var error = e;
      if (e is http.ClientException) {
        error = ClientException(e.message);
      }
      return Future.error(error);
    }
  }
}
