class Listing {
  Listing({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.priceLabel,
    required this.distanceLabel,
    required this.timeAgo,
    required this.author,
    required this.imageUrl,
    this.isSaved = false,
    this.isVerified = false,
  });

  final String id;
  final String title;
  final String subtitle;
  final String priceLabel;
  final String distanceLabel;
  final String timeAgo;
  final String author;
  final String imageUrl;
  final bool isSaved;
  final bool isVerified;

  Listing copyWith({bool? isSaved}) {
    return Listing(
      id: id,
      title: title,
      subtitle: subtitle,
      priceLabel: priceLabel,
      distanceLabel: distanceLabel,
      timeAgo: timeAgo,
      author: author,
      imageUrl: imageUrl,
      isSaved: isSaved ?? this.isSaved,
      isVerified: isVerified,
    );
  }
}
