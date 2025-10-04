class Package {
  String packageId;
  String packageName;
  String packageDescription;
  String packagePrice;

  Package({
    required this.packageId,
    required this.packageName,
    required this.packageDescription,
    required this.packagePrice,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      packageId: json['package_id'],
      packageName: json['package_name'],
      packageDescription: json['package_description'],
      packagePrice: json['package_price'],
    );
  }}