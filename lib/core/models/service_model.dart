import 'package:flutter/material.dart';

enum FormFieldType {
  text,
  number,
  dropdown,
  date,
  textarea,
  aadhaarNumber,
  panNumber,
  radio,
}

class FormFieldOption {
  final String label;
  final String value;

  const FormFieldOption({required this.label, required this.value});
}

class FormFieldDefinition {
  final String key;
  final String label;
  final String hint;
  final FormFieldType type;
  final List<FormFieldOption>? options;
  final bool required;
  final String? helperText;
  final String? defaultValue;
  final String? prefixText;
  final String? sectionTitle;

  const FormFieldDefinition({
    required this.key,
    required this.label,
    required this.hint,
    this.type = FormFieldType.text,
    this.options,
    this.required = true,
    this.helperText,
    this.defaultValue,
    this.prefixText,
    this.sectionTitle,
  });
}

class RequiredDocumentDefinition {
  final String id;
  final String name;
  final String description;
  final List<String> allowedFormats;
  final double maxSizeMB;
  final bool isMandatory;

  const RequiredDocumentDefinition({
    required this.id,
    required this.name,
    required this.description,
    this.allowedFormats = const ['PDF', 'JPG', 'PNG'],
    this.maxSizeMB = 5.0,
    this.isMandatory = true,
  });
}

class ServiceModel {
  final String id;
  final String code;
  final String departmentId;
  final String departmentName;
  final String name;
  final String category;
  final String description;
  final String eligibility;
  final int processingTimeDays;
  final double governmentFee;
  final IconData icon;
  final bool isPopular;
  final List<String> processSteps;
  final List<RequiredDocumentDefinition> requiredDocuments;
  final List<FormFieldDefinition> formFields;

  const ServiceModel({
    required this.id,
    required this.code,
    required this.departmentId,
    required this.departmentName,
    required this.name,
    required this.category,
    required this.description,
    required this.eligibility,
    required this.processingTimeDays,
    required this.governmentFee,
    required this.icon,
    this.isPopular = false,
    required this.processSteps,
    required this.requiredDocuments,
    required this.formFields,
  });
}
