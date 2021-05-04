class Categories {
  String id;
  String name;
  String imageLink;

  Categories({this.id, this.name, this.imageLink});

  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
      id: json['_id'],
      name: json['providerCatName'],
      imageLink: json['providerCatImage'],
    );
  }
}
