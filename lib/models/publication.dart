class Publication {
  final int number;
  final String url;
  final String imgUrl;

  const Publication({
    required this.number,
    required this.url,
    required this.imgUrl,
  });

  @override
  String toString() {
    return "Instance of 'Publication'<$number, $url, $imgUrl>";
  }
}