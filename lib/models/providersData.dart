import 'package:final_year_project/models/providerProfile.dart';
import 'package:final_year_project/models/tasksModel.dart';

import 'categories.dart';

class ProvidersData {
  List<TasksModel> offerscollections;
  String id;
  ProviderProfile serviceprovidersdatas;
  Providercategories providercategories;
  String shopImage;
  String address;
  String longitude;
  String latitude;
  String shopName;
  String des;

  ProvidersData(
      {this.id,
      this.serviceprovidersdatas,
      this.providercategories,
      this.shopImage,
      this.address,
      this.longitude,
      this.latitude,
      this.des,
      this.shopName,
      this.offerscollections});

  factory ProvidersData.fromJson(Map<String, dynamic> json) => ProvidersData(
      id: json["_id"],
      offerscollections: List<TasksModel>.from(
          json["offerscollections"].map((x) => TasksModel.fromJson1(x))),
      serviceprovidersdatas:
          ProviderProfile.fromJson(json["serviceprovidersdatas"]),
      providercategories:
          Providercategories.fromJson(json["providercategories"]),
      shopImage: json["shopImage"],
      address: json["address"],
      longitude: json["longitude"],
      latitude: json["latitude"],
      shopName: json["shopName"],
      des: json['desc']);

  factory ProvidersData.fromJson1(Map<String, dynamic> json) => ProvidersData(
        id: json["_id"],
        shopImage: json["shopImage"],
        address: json["address"],
        longitude: json["longitude"],
        latitude: json["latitude"],
        shopName: json["shopName"],
      );
}
