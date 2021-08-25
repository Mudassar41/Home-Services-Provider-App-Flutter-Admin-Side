class ProviderProfile {
  String id;
  String providerFirstName;
  String providerLastName;
  String providerPhoneNumber;
  String deviceId;
  ProviderProfile({
    this.id,
    this.providerFirstName,
    this.providerLastName,
    this.providerPhoneNumber,
    this.deviceId
  });
  factory ProviderProfile.fromJson(Map<String, dynamic> json) =>
      ProviderProfile(
        id: json["_id"],
        providerFirstName: json["providerFirstName"],
        providerLastName: json["providerLastName"],
        providerPhoneNumber: json["providerPhoneNumber"],
        deviceId:json['deviceToken']
      );
}
