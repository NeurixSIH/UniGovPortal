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
  final String departmentId; // Assigned department for departmentAdmin
  final String landOwnership; // E.g. 'Owns Agricultural Land', 'None'
  final String incomeBracket; // E.g. '₹1,00,000 - ₹3,00,000'
  final Map<String, dynamic> extraInformation; // Additional custom metadata map
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
    this.departmentId = '',
    this.landOwnership = 'None',
    this.incomeBracket = '',
    this.extraInformation = const {},
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

  String get citizenId => userId;

  factory UserModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    final extra = (map['extraInformation'] ?? map['extrainformation']) is Map<String, dynamic>
        ? Map<String, dynamic>.from(map['extraInformation'] ?? map['extrainformation'])
        : ((map['extraInformation'] ?? map['extrainformation']) is Map
            ? Map<String, dynamic>.from(map['extraInformation'] ?? map['extrainformation'])
            : <String, dynamic>{});

    final String resolvedDeptId = map['departmentId'] ?? extra['departmentId'] ?? '';
    final String resolvedLand = map['landOwnership'] ?? extra['landOwnership'] ?? 'None';
    final String resolvedIncomeBracket = map['incomeBracket'] ?? extra['incomeBracket'] ?? '';

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
      departmentId: resolvedDeptId,
      landOwnership: resolvedLand,
      incomeBracket: resolvedIncomeBracket,
      extraInformation: extra,
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
      'departmentId': departmentId,
      'landOwnership': landOwnership,
      'incomeBracket': incomeBracket,
      'extraInformation': extraInformation,
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
    String? departmentId,
    String? landOwnership,
    String? incomeBracket,
    Map<String, dynamic>? extraInformation,
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
      departmentId: departmentId ?? this.departmentId,
      landOwnership: landOwnership ?? this.landOwnership,
      incomeBracket: incomeBracket ?? this.incomeBracket,
      extraInformation: extraInformation ?? this.extraInformation,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
