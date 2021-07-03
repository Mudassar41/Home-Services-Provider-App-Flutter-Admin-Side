

import 'package:final_year_project/models/providerProfile.dart';

import 'categories.dart';

class ProvidersData {
  String id;
  ProviderProfile serviceprovidersdatas;
  Providercategories providercategories;
  String shopImage;
  String address;
  String whFromTime;
  String whFromTimeType;
  String whToTime;
  String whToTimeType;
  String wsFrom;
  String wsTo;
  String longitude;
  String latitude;
  String shopName;
  ProvidersData({
    this.id,
    this.serviceprovidersdatas,
    this.providercategories,
    this.shopImage,
    this.address,
    this.whFromTime,
    this.whFromTimeType,
    this.whToTime,
    this.whToTimeType,
    this.wsFrom,
    this.wsTo,
    this.longitude,
    this.latitude,
    this.shopName,
  });
  factory ProvidersData.fromJson(Map<String, dynamic> json) => ProvidersData(
        id: json["_id"],
        serviceprovidersdatas:
            ProviderProfile.fromJson(json["serviceprovidersdatas"]),
        providercategories:
            Providercategories.fromJson(json["providercategories"]),
        shopImage: json["shopImage"],
        address: json["address"],
        whFromTime: json["whFromTime"],
        whFromTimeType: json["whFromTimeType"],
        whToTime: json["whToTime"],
        whToTimeType: json["whToTimeType"],
        wsFrom: json["wsFrom"],
        wsTo: json["wsTo"],
        longitude: json["longitude"],
        latitude: json["latitude"],
        shopName: json["shopName"],
      );
  factory ProvidersData.fromJson1(Map<String, dynamic> json) => ProvidersData(
    id: json["_id"],
    shopImage: json["shopImage"],
    address: json["address"],
    whFromTime: json["whFromTime"],
    whFromTimeType: json["whFromTimeType"],
    whToTime: json["whToTime"],
    whToTimeType: json["whToTimeType"],
    wsFrom: json["wsFrom"],
    wsTo: json["wsTo"],
    longitude: json["longitude"],
    latitude: json["latitude"],
    shopName: json["shopName"],
  );
}
