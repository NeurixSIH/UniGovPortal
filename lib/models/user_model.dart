import 'package:cloud_firestore/cloud_firestore.dart';

class AddressModel {
  final String line1;
  final String? line2;
  final String city;
  final String state;
  final String pincode;

  const AddressModel({
    required this.line1,
    this.line2,
    required this.city,
    required this.state,
    required this.pincode,
  });

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      line1: map['line1'] ?? '',
      line2: map['line2'],
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      pincode: map['pincode'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'line1': line1,
      if (line2 != null) 'line2': line2,
      'city': city,
      'state': state,
      'pincode': pincode,
    };
  }

  AddressModel copyWith({
    String? line1,
    String? line2,
    String? city,
    String? state,
    String? pincode,
  }) {
    return AddressModel(
      line1: line1 ?? this.line1,
      line2: line2 ?? this.line2,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
    );
  }
}

class UserModel {
  final String userId;
  final String fullName;
  final String email;
  final String mobileNumber;
  final Timestamp dob;
  final String gender;
  final Map<String, dynamic> address;
  final String city;
  final String state;
  final String pincode;
  final num income;
  final String category;
  final String role; // 'citizen', 'departmentAdmin', 'systemAdmin'
  final String status; // 'active', 'blocked'
  final Timestamp createdAt;
  final Timestamp updatedAt;

  const UserModel({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.mobileNumber,
    required this.dob,
    required this.gender,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    required this.income,
    required this.category,
    required this.role,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  // Roles constants
  static const String roleCitizen = 'citizen';
  static const String roleDepartmentAdmin = 'departmentAdmin';
  static const String roleSystemAdmin = 'systemAdmin';

  // Status constants
  static const String statusActive = 'active';
  static const String statusBlocked = 'blocked';

  factory UserModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    return UserModel(
      userId: map['userId'] ?? docId ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      mobileNumber: map['mobileNumber'] ?? '',
      dob: map['dob'] is Timestamp ? map['dob'] : Timestamp.now(),
      gender: map['gender'] ?? '',
      address: map['address'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(map['address'])
          : (map['address'] is Map ? Map<String, dynamic>.from(map['address']) : {}),
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      pincode: map['pincode'] ?? '',
      income: map['income'] ?? 0,
      category: map['category'] ?? '',
      role: map['role'] ?? roleCitizen,
      status: map['status'] ?? statusActive,
      createdAt: map['createdAt'] is Timestamp ? map['createdAt'] : Timestamp.now(),
      updatedAt: map['updatedAt'] is Timestamp ? map['updatedAt'] : Timestamp.now(),
    );
  }

  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return UserModel.fromMap(doc.data() ?? {}, docId: doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'fullName': fullName,
      'email': email,
      'mobileNumber': mobileNumber,
      'dob': dob,
      'gender': gender,
      'address': address,
      'city': city,
      'state': state,
      'pincode': pincode,
      'income': income,
      'category': category,
      'role': role,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  UserModel copyWith({
    String? userId,
    String? fullName,
    String? email,
    String? mobileNumber,
    Timestamp? dob,
    String? gender,
    Map<String, dynamic>? address,
    String? city,
    String? state,
    String? pincode,
    num? income,
    String? category,
    String? role,
    String? status,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      income: income ?? this.income,
      category: category ?? this.category,
      role: role ?? this.role,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
