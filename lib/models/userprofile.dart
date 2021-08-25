class UserProfile {
  String userId;
  String firstName;
  String lastName;
  String userImage;
  String phoneNumber;
  String password;
  String confirmPassword;
  String deviceId;

  UserProfile(
      {this.userId,
      this.firstName,
      this.lastName,
      this.phoneNumber,
      this.userImage,
      this.deviceId});

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
      userId: json["_id"],
      userImage: json['userImage'],
      firstName: json["userFirstName"],
      lastName: json["userLastName"],
      phoneNumber: json["userPhoneNumber"],
      deviceId: json['deviceToke']);
}
