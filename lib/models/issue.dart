class Issue {
  final int number;
  final DateTime dateTime;
  final String imgUrl;
  final String? imgHRUrl;

  const Issue({
    required this.number,
    required this.dateTime,
    required this.imgUrl,
    this.imgHRUrl,
  });
}
