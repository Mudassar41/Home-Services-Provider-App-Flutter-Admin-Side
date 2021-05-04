

class ProfileModel {
  String catId;
  String shopName;
  String address;
  String whFromTime;
  String whFromTimeType;
  String whToTime;
  String whToTimeType;
  String wsFrom;
  String wsTo;
  String id;
  String shopImage;
  var longitude;
  var latitude;
  dynamic currentUid;

  Providercategories providercategories;
  ProfileModel({
    this.id,
    this.providercategories,
    this.shopImage,
    this.shopName,
    this.address,
    this.whFromTime,
    this.whFromTimeType,
    this.whToTime,
    this.whToTimeType,
    this.wsFrom,
    this.wsTo,
    this.longitude,
    this.latitude,
    this.currentUid
  });
  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        id: json["_id"],
        providercategories:
            Providercategories.fromJson(json["providercategories"]),
        shopImage: json["shopImage"],
        shopName: json["shopName"],
        address: json["address"],
        whFromTime: json["whFromTime"],
        whFromTimeType: json["whFromTimeType"],
        whToTime: json["whToTime"],
        whToTimeType: json["whToTimeType"],
        wsFrom: json["wsFrom"],
        wsTo: json["wsTo"],
        longitude: json["longitude"],
        latitude: json["latitude"],
        currentUid: json['currentUid']
      );
}

class Providercategories {
  String id;
  String providerCatName;
  String providerCatImage;
  Providercategories({
    this.id,
    this.providerCatName,
    this.providerCatImage,
  });
  factory Providercategories.fromJson(Map<String, dynamic> json) =>
      Providercategories(
        id: json["_id"],
        providerCatName: json["providerCatName"],
        providerCatImage: json["providerCatImage"],
      );
}
