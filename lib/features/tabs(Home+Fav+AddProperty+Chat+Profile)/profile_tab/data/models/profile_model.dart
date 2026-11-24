class ProfileModel {
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? profilePhoto;
  final String? gender;
  final String? location;
  final String? birthDate;
  final String? address;
  final int? districtId;
  final int? cityId;
  final int? governorateId;

  ProfileModel({
    this.name,
    this.email,
    this.phoneNumber,
    this.profilePhoto,
    this.gender,
    this.location,
    this.birthDate,
    this.address,
    this.districtId,
    this.cityId,
    this.governorateId,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json['name'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      profilePhoto: json['profilePhoto'] as String?,
      gender: json['gender'] as String?,
      location: json['location'] as String?,
      birthDate: json['birthDate'] as String?,
      address: json['address'] as String?,
      districtId: json['districtId'] as int?,
      cityId: json['cityId'] as int?,
      governorateId: json['governorateId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'profilePhoto': profilePhoto,
      'gender': gender,
      'location': location,
      'birthDate': birthDate,
      'address': address,
      'districtId': districtId,
      'cityId': cityId,
      'governorateId': governorateId,
    };
  }
}
