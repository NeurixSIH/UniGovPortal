class OfficerModel {
  final String id;
  final String userId;
  final String fullName;
  final String departmentId;
  final String departmentName;
  final String designation;
  final String email;
  final String phone;
  final bool isActive;
  final DateTime joinedDate;
  final int assignedCount;
  final int resolvedCount;

  const OfficerModel({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.departmentId,
    required this.departmentName,
    required this.designation,
    required this.email,
    required this.phone,
    this.isActive = true,
    required this.joinedDate,
    this.assignedCount = 0,
    this.resolvedCount = 0,
  });

  OfficerModel copyWith({
    String? id,
    String? userId,
    String? fullName,
    String? departmentId,
    String? departmentName,
    String? designation,
    String? email,
    String? phone,
    bool? isActive,
    DateTime? joinedDate,
    int? assignedCount,
    int? resolvedCount,
  }) {
    return OfficerModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      departmentId: departmentId ?? this.departmentId,
      departmentName: departmentName ?? this.departmentName,
      designation: designation ?? this.designation,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      isActive: isActive ?? this.isActive,
      joinedDate: joinedDate ?? this.joinedDate,
      assignedCount: assignedCount ?? this.assignedCount,
      resolvedCount: resolvedCount ?? this.resolvedCount,
    );
  }
}
