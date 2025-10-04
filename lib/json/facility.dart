class Facility {
  String title;
  String image;

  Facility(this.title, this.image);


  static List<Facility> get items => [
    Facility("Ac", "wind.png"),
    Facility("Restaurant", "building.png"),
    Facility("Swimming Pool", "swimming.png"),
    Facility("24-Hours Front Desk", "24-support.png"),
  ];
}