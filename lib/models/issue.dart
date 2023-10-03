class IssueBase {
  final int number;
  final String url;
  final String? imgUrl;

  const IssueBase({
    required this.number,
    required this.url,
    this.imgUrl,
  });

  @override
  String toString() {
    return "Instance of 'IssueBase'<$number, $url, $imgUrl>";
  }
}

class Issue extends IssueBase {
  final DateTime dateTime;
  final String? imgHRUrl;

  const Issue({
    required super.number,
    required super.url,
    required this.dateTime,
    required super.imgUrl,
    this.imgHRUrl,
  });

  @override
  String toString() {
    return "Instance of 'Issue'<$number, $url, $dateTime, $imgUrl, $imgHRUrl>";
  }
}
