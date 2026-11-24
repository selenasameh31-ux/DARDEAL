//ده بيمثل بيانات المستخدم داخل التطبيق بشكل مجرد من أي تفاصيل API أو JSON

// class UserEntity {
//   final String id;
//   final String name;
//   final String email;
//   final String phone;
//   final String role;
//   final String status;
//   final bool isEmailVerified;
//   final bool isPhoneVerified;
//   final bool hasPassword;
//   // Local profile fields (not from backend)
//   final String gender; // 'Male' or 'Female'
//   final String dateOfBirth; // stored as ISO string
//   final String address;
//   final String bio;
//   final String profileImagePath;

//   const UserEntity({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.phone,
//     required this.role,
//     required this.status,
//     required this.isEmailVerified,
//     required this.isPhoneVerified,
//     required this.hasPassword,
//     this.gender = '',
//     this.dateOfBirth = '',
//     this.address = '',
//     this.bio = '',
//     this.profileImagePath = '',
//   });
 
//  Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'name': name,
//       'email': email,
//       'phone': phone,
//       'role': role,
//       'status': status,
//       'isEmailVerified': isEmailVerified,
//       'isPhoneVerified': isPhoneVerified,
//       'hasPassword': hasPassword,
//       'gender': gender,
//       'dateOfBirth': dateOfBirth,
//       'address': address,
//       'bio': bio,
//       'profileImagePath': profileImagePath,
//     };
//   }

//   factory UserEntity.fromMap(Map<String, dynamic> map) {
//     return UserEntity(
//       id: map['id'] ?? '',
//       name: map['name'] ?? '',
//       email: map['email'] ?? '',
//       phone: map['phone'] ?? '',
//       role: map['role'] ?? '',
//       status: map['status'] ?? '',
//       isEmailVerified: map['isEmailVerified'] ?? false,
//       isPhoneVerified: map['isPhoneVerified'] ?? false,
//       hasPassword: map['hasPassword'] ?? false,
//       gender: map['gender'] ?? '',
//       dateOfBirth: map['dateOfBirth'] ?? '',
//       address: map['address'] ?? '',
//       bio: map['bio'] ?? '',
//       profileImagePath: map['profileImagePath'] ?? '',
//     );
//   }

//   UserEntity copyWith({
//     String? id,
//     String? name,
//     String? email,
//     String? phone,
//     String? role,
//     String? status,
//     bool? isEmailVerified,
//     bool? isPhoneVerified,
//     bool? hasPassword,
//     String? gender,
//     String? dateOfBirth,
//     String? address,
//     String? bio,
//     String? profileImagePath,
//   }) {
//     return UserEntity(
//       id: id ?? this.id,
//       name: name ?? this.name,
//       email: email ?? this.email,
//       phone: phone ?? this.phone,
//       role: role ?? this.role,
//       status: status ?? this.status,
//       isEmailVerified: isEmailVerified ?? this.isEmailVerified,
//       isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
//       hasPassword: hasPassword ?? this.hasPassword,
//       gender: gender ?? this.gender,
//       dateOfBirth: dateOfBirth ?? this.dateOfBirth,
//       address: address ?? this.address,
//       bio: bio ?? this.bio,
//       profileImagePath: profileImagePath ?? this.profileImagePath,
//     );
//   }

//   /// Returns a formatted short address for display.
//   /// If address is empty, returns 'Your Address'.
//   String get displayAddress {
//     if (address.isEmpty) return 'Your Address';
//     // Try to parse "governorate / city - neighborhood" style
//     return address;
//   }
// }





class UserEntity {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String status;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final bool hasPassword;
  // Local profile fields (not from backend)
  final String gender; // 'Male' or 'Female'
  final String dateOfBirth; // stored as ISO string
  final String address;
  final String bio;
  final String profileImagePath;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.status,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.hasPassword,
    this.gender = '',
    this.dateOfBirth = '',
    this.address = '',
    this.bio = '',
    this.profileImagePath = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'status': status,
      'isEmailVerified': isEmailVerified,
      'isPhoneVerified': isPhoneVerified,
      'hasPassword': hasPassword,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'address': address,
      'bio': bio,
      'profileImagePath': profileImagePath,
    };
  }

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      role: map['role'] ?? '',
      status: map['status'] ?? '',
      isEmailVerified: map['isEmailVerified'] ?? false,
      isPhoneVerified: map['isPhoneVerified'] ?? false,
      hasPassword: map['hasPassword'] ?? false,
      gender: map['gender'] ?? '',
      dateOfBirth: map['birthDate'] ?? map['dateOfBirth'] ?? '',
      address: map['address'] ?? '',
      bio: map['bio'] ?? '',
      profileImagePath: map['profilePhoto'] ?? map['profileImagePath'] ?? '',
    );
  }

  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? role,
    String? status,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    bool? hasPassword,
    String? gender,
    String? dateOfBirth,
    String? address,
    String? bio,
    String? profileImagePath,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      status: status ?? this.status,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      hasPassword: hasPassword ?? this.hasPassword,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      address: address ?? this.address,
      bio: bio ?? this.bio,
      profileImagePath: profileImagePath ?? this.profileImagePath,
    );
  }

  /// Returns a formatted short address for display.
  /// If address is empty, returns 'Your Address'.
  String get displayAddress {
    if (address.isEmpty) return 'Your Address';
    // Try to parse "governorate / city - neighborhood" style
    return address;
  }
}
