class ProviderProfile {
  String id;
  String providerFirstName;
  String providerLastName;
  String providerPhoneNumber;
  ProviderProfile({
    this.id,
    this.providerFirstName,
    this.providerLastName,
    this.providerPhoneNumber,
  });
  factory ProviderProfile.fromJson(Map<String, dynamic> json) =>
      ProviderProfile(
        id: json["_id"],
        providerFirstName: json["providerFirstName"],
        providerLastName: json["providerLastName"],
        providerPhoneNumber: json["providerPhoneNumber"],
      );
}
