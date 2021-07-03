class Providercategories {
  String id;
  String providerCatName;
  String providerCatImage;
  int v;
  Providercategories({
    this.id,
    this.providerCatName,
    this.providerCatImage,
    this.v,
  });

  factory Providercategories.fromJson(Map<String, dynamic> json) =>
      Providercategories(
        id: json["_id"],
        providerCatName: json["providerCatName"],
        providerCatImage: json["providerCatImage"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "providerCatName": providerCatName,
        "providerCatImage": providerCatImage,
        "__v": v,
      };
}
