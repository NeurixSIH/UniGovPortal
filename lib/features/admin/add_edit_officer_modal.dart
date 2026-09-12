import 'package:flutter/material.dart';
import '../../core/models/officer_model.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';

class AddEditOfficerModal extends StatefulWidget {
  final OfficerModel? existingOfficer;
  final ValueChanged<OfficerModel> onSaved;

  const AddEditOfficerModal({
    super.key,
    this.existingOfficer,
    required this.onSaved,
  });

  static Future<void> show({
    required BuildContext context,
    OfficerModel? existingOfficer,
    required ValueChanged<OfficerModel> onSaved,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AddEditOfficerModal(
        existingOfficer: existingOfficer,
        onSaved: onSaved,
      ),
    );
  }

  @override
  State<AddEditOfficerModal> createState() => _AddEditOfficerModalState();
}

class _AddEditOfficerModalState extends State<AddEditOfficerModal> {
  late TextEditingController _fullNameCtrl;
  late TextEditingController _userIdCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _designationCtrl;
  late TextEditingController _tempPasswordCtrl;
  late String _selectedDeptId;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    final o = widget.existingOfficer;
    _fullNameCtrl = TextEditingController(text: o?.fullName ?? '');
    _userIdCtrl = TextEditingController(text: o?.userId ?? '');
    _emailCtrl = TextEditingController(text: o?.email ?? '');
    _phoneCtrl = TextEditingController(text: o?.phone ?? '+91 94280 ');
    _designationCtrl = TextEditingController(text: o?.designation ?? 'Revenue Inspector');
    _tempPasswordCtrl = TextEditingController(text: o == null ? 'GovOfficer@2026' : '');
    _selectedDeptId = o?.departmentId ?? 'dept-rev';
    _isActive = o?.isActive ?? true;
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingOfficer != null;

    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
      insetPadding: const EdgeInsets.all(AppSpacing.l),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 580),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F3FF),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                    child: const Icon(Icons.person_add_alt_1_rounded, color: Color(0xFF7C3AED), size: 24),
                  ),
                  const SizedBox(width: AppSpacing.m),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(isEditing ? 'Edit Department Officer' : 'Add New Department Officer', style: AppTypography.h3),
                        Text('Provision departmental credentials and statutory review authority.', style: AppTypography.bodySmall),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.l),
              const Divider(),
              const SizedBox(height: AppSpacing.l),

              AppTextField(
                label: 'Officer Full Legal Name',
                hint: 'e.g. Ramesh Chandra, IAS',
                controller: _fullNameCtrl,
                isRequired: true,
                prefixIcon: const Icon(Icons.person_outline, size: 18),
              ),
              const SizedBox(height: AppSpacing.m),

              LayoutBuilder(
                builder: (context, constraints) {
                  final isCompact = constraints.maxWidth < 450;
                  final userIdField = AppTextField(
                    label: 'Assigned User ID',
                    hint: 'e.g. sdm_ramesh.chandra',
                    controller: _userIdCtrl,
                    isRequired: true,
                    prefixIcon: const Icon(Icons.badge_outlined, size: 18),
                  );
                  final designationField = AppTextField(
                    label: 'Official Designation',
                    hint: 'e.g. Sub-Divisional Magistrate',
                    controller: _designationCtrl,
                    isRequired: true,
                    prefixIcon: const Icon(Icons.military_tech_outlined, size: 18),
                  );

                  if (isCompact) {
                    return Column(
                      children: [
                        userIdField,
                        const SizedBox(height: AppSpacing.m),
                        designationField,
                      ],
                    );
                  }

                  return Row(
                    children: [
                      Expanded(child: userIdField),
                      const SizedBox(width: AppSpacing.m),
                      Expanded(child: designationField),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppSpacing.m),

              // Department Selector
              Text('Department Assignment', style: AppTypography.labelBold),
              const SizedBox(height: AppSpacing.s),
              DropdownButtonFormField<String>(
                value: _selectedDeptId,
                decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
                items: const [
                  DropdownMenuItem(value: 'dept-rev', child: Text('Revenue & Land Records')),
                  DropdownMenuItem(value: 'dept-fcs', child: Text('Food, Civil Supplies & Consumer Affairs')),
                  DropdownMenuItem(value: 'dept-trn', child: Text('Transport & Highways (Sarathi/Vahan)')),
                  DropdownMenuItem(value: 'dept-hlt', child: Text('Health & Family Welfare (MoHFW)')),
                  DropdownMenuItem(value: 'dept-sje', child: Text('Social Justice & Empowerment')),
                  DropdownMenuItem(value: 'dept-urb', child: Text('Urban Development & Municipal Services')),
                  DropdownMenuItem(value: 'dept-lbr', child: Text('Labour, Employment & Workers Welfare')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _selectedDeptId = val);
                },
              ),
              const SizedBox(height: AppSpacing.m),

              LayoutBuilder(
                builder: (context, constraints) {
                  final isCompact = constraints.maxWidth < 450;
                  final emailField = AppTextField(
                    label: 'Government Email ID',
                    hint: 'e.g. ramesh.c@gujarat.gov.in',
                    controller: _emailCtrl,
                    isRequired: true,
                    prefixIcon: const Icon(Icons.email_outlined, size: 18),
                  );
                  final phoneField = AppTextField(
                    label: 'Official Mobile Number',
                    hint: '+91 94280 12345',
                    controller: _phoneCtrl,
                    isRequired: true,
                    prefixIcon: const Icon(Icons.phone_android_rounded, size: 18),
                  );

                  if (isCompact) {
                    return Column(
                      children: [
                        emailField,
                        const SizedBox(height: AppSpacing.m),
                        phoneField,
                      ],
                    );
                  }

                  return Row(
                    children: [
                      Expanded(child: emailField),
                      const SizedBox(width: AppSpacing.m),
                      Expanded(child: phoneField),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppSpacing.m),

              if (!isEditing) ...[
                AppTextField(
                  label: 'Temporary Initial Password',
                  hint: 'Min 8 characters',
                  controller: _tempPasswordCtrl,
                  isRequired: true,
                  helperText: 'Officer will be prompted to rotate password & register DSC on first login.',
                  prefixIcon: const Icon(Icons.key_rounded, size: 18),
                ),
                const SizedBox(height: AppSpacing.m),
              ],

              // Status Switch
              Row(
                children: [
                  Switch(
                    value: _isActive,
                    activeColor: AppColors.success,
                    onChanged: (val) => setState(() => _isActive = val),
                  ),
                  const SizedBox(width: AppSpacing.s),
                  Text(_isActive ? 'Active & Permitted to Scrutinize' : 'Suspended / Inactive', style: AppTypography.labelBold),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              LayoutBuilder(
                builder: (context, constraints) {
                  final isCompact = constraints.maxWidth < 400;
                  final cancelBtn = AppButton(
                    label: 'Cancel',
                    variant: AppButtonVariant.outline,
                    onPressed: () => Navigator.of(context).pop(),
                  );
                  final saveBtn = AppButton(
                    label: isEditing ? 'Update Officer' : 'Save & Issue Credentials',
                    variant: AppButtonVariant.primary,
                    leadingIcon: Icons.check_rounded,
                    onPressed: () {
                      if (_fullNameCtrl.text.trim().isEmpty || _userIdCtrl.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please fill all mandatory fields.')),
                        );
                        return;
                      }

                      String deptName = 'Revenue & Land Records';
                      if (_selectedDeptId == 'dept-fcs') deptName = 'Food, Civil Supplies & Consumer Affairs';
                      if (_selectedDeptId == 'dept-trn') deptName = 'Transport & Highways (Sarathi/Vahan)';
                      if (_selectedDeptId == 'dept-hlt') deptName = 'Health & Family Welfare (MoHFW)';
                      if (_selectedDeptId == 'dept-sje') deptName = 'Social Justice & Empowerment';
                      if (_selectedDeptId == 'dept-urb') deptName = 'Urban Development & Municipal Services';
                      if (_selectedDeptId == 'dept-lbr') deptName = 'Labour, Employment & Workers Welfare';

                      final updatedOfficer = OfficerModel(
                        id: widget.existingOfficer?.id ?? 'off-${DateTime.now().millisecondsSinceEpoch}',
                        userId: _userIdCtrl.text.trim(),
                        fullName: _fullNameCtrl.text.trim(),
                        departmentId: _selectedDeptId,
                        departmentName: deptName,
                        designation: _designationCtrl.text.trim(),
                        email: _emailCtrl.text.trim(),
                        phone: _phoneCtrl.text.trim(),
                        isActive: _isActive,
                        joinedDate: widget.existingOfficer?.joinedDate ?? DateTime.now(),
                        assignedCount: widget.existingOfficer?.assignedCount ?? 0,
                        resolvedCount: widget.existingOfficer?.resolvedCount ?? 0,
                      );

                      widget.onSaved(updatedOfficer);
                      Navigator.of(context).pop();
                    },
                  );

                  if (isCompact) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        saveBtn,
                        const SizedBox(height: AppSpacing.m),
                        cancelBtn,
                      ],
                    );
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      cancelBtn,
                      const SizedBox(width: AppSpacing.m),
                      saveBtn,
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
