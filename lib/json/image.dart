class GalleryItem {
  String url;
  String description;

  GalleryItem({
    required this.url,
    required this.description,
  });

  factory GalleryItem.fromJson(Map<String, dynamic> json) {
    return GalleryItem(
      url: json['url'] ?? "",
      description: json['description'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'description': description,
    };
  }
}
