import 'package:flutter/material.dart';

class DepartmentModel {
  final String id;
  final String code;
  final String name;
  final String description;
  final IconData icon;
  final String nodalMinistry;
  final int activeServicesCount;
  final String helpline;
  final String officialPortalUrl;

  const DepartmentModel({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.icon,
    required this.nodalMinistry,
    required this.activeServicesCount,
    required this.helpline,
    required this.officialPortalUrl,
  });
}
