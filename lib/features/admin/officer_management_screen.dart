import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_state_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/modal_dialogs.dart';
import 'add_edit_officer_modal.dart';

class OfficerManagementScreen extends StatefulWidget {
  const OfficerManagementScreen({super.key});

  @override
  State<OfficerManagementScreen> createState() => _OfficerManagementScreenState();
}

class _OfficerManagementScreenState extends State<OfficerManagementScreen> {
  String _searchQuery = '';
  String _deptFilter = 'ALL';
  String _statusFilter = 'ALL'; // ALL, ACTIVE, INACTIVE

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final officers = state.officers;
    final departments = state.departments;

    final filtered = officers.where((o) {
      if (_deptFilter != 'ALL' && o.departmentId != _deptFilter) return false;
      if (_statusFilter == 'ACTIVE' && !o.isActive) return false;
      if (_statusFilter == 'INACTIVE' && o.isActive) return false;

      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        return o.fullName.toLowerCase().contains(q) ||
            o.userId.toLowerCase().contains(q) ||
            o.designation.toLowerCase().contains(q);
      }
      return true;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppSpacing.m,
            runSpacing: AppSpacing.s,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Department Officer Directory', style: AppTypography.h1),
                  Text('Provision, inspect, activate, and deactivate civil service scrutiny officers.', style: AppTypography.bodySmall),
                ],
              ),
              AppButton(
                label: 'Add New Officer',
                variant: AppButtonVariant.primary,
                leadingIcon: Icons.person_add_alt_1_rounded,
                onPressed: () {
                  AddEditOfficerModal.show(
                    context: context,
                    onSaved: (newOfficer) {
                      state.addOfficer(newOfficer);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Officer ${newOfficer.fullName} successfully provisioned!')),
                      );
                    },
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.l),

          // Search & Filters Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.m),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.search_rounded, color: AppColors.textMuted),
                      const SizedBox(width: AppSpacing.s),
                      Expanded(
                        child: TextField(
                          onChanged: (val) => setState(() => _searchQuery = val),
                          decoration: InputDecoration(
                            hintText: 'Search officer by name, user ID, or designation...',
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear_rounded, size: 18),
                                    onPressed: () => setState(() => _searchQuery = ''),
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: AppSpacing.s),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Text('Department: ', style: AppTypography.labelBold.copyWith(fontSize: 12)),
                        const SizedBox(width: AppSpacing.s),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _deptFilter,
                            items: [
                              const DropdownMenuItem(value: 'ALL', child: Text('All Departments')),
                              ...departments.map(
                                (d) => DropdownMenuItem(value: d.id, child: Text(d.name)),
                              ),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _deptFilter = val);
                            },
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xl),

                        Text('Status: ', style: AppTypography.labelBold.copyWith(fontSize: 12)),
                        const SizedBox(width: AppSpacing.s),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _statusFilter,
                            items: const [
                              DropdownMenuItem(value: 'ALL', child: Text('All Statuses')),
                              DropdownMenuItem(value: 'ACTIVE', child: Text('Active Only')),
                              DropdownMenuItem(value: 'INACTIVE', child: Text('Inactive / Suspended Only')),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _statusFilter = val);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.l),

          // Officer Management Table Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.l),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Registered Scrutiny Officers (${filtered.length})', style: AppTypography.h3),
                  const SizedBox(height: AppSpacing.m),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(AppColors.surfaceSubtle),
                      dataRowMaxHeight: 64,
                      columns: const [
                        DataColumn(label: Text('OFFICER NAME & ID')),
                        DataColumn(label: Text('DEPARTMENT')),
                        DataColumn(label: Text('DESIGNATION')),
                        DataColumn(label: Text('STATUS')),
                        DataColumn(label: Text('ACTIVE FILES')),
                        DataColumn(label: Text('RESOLVED')),
                        DataColumn(label: Text('ACTIONS')),
                      ],
                      rows: filtered.map((officer) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: officer.isActive ? const Color(0xFF059669) : AppColors.textLight,
                                    child: Text(officer.fullName[0], style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                  ),
                                  const SizedBox(width: AppSpacing.s),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(officer.fullName, style: AppTypography.labelBold.copyWith(fontSize: 13)),
                                      Text(officer.userId, style: AppTypography.code.copyWith(fontSize: 11, color: AppColors.textMuted)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            DataCell(Text(officer.departmentName, style: AppTypography.bodySmall)),
                            DataCell(Text(officer.designation, style: AppTypography.labelBold.copyWith(fontSize: 12))),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: officer.isActive ? AppColors.successLight : AppColors.dangerLight,
                                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                                  border: Border.all(color: officer.isActive ? AppColors.successBorder : AppColors.dangerBorder),
                                ),
                                child: Text(
                                  officer.isActive ? 'ACTIVE' : 'DEACTIVATED',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: officer.isActive ? AppColors.success : AppColors.danger,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(Text('${officer.assignedCount}', style: AppTypography.labelBold)),
                            DataCell(Text('${officer.resolvedCount}', style: AppTypography.bodySmall)),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined, size: 18),
                                    tooltip: 'Edit Officer Details',
                                    onPressed: () {
                                      AddEditOfficerModal.show(
                                        context: context,
                                        existingOfficer: officer,
                                        onSaved: (updated) {
                                          state.updateOfficer(updated);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Officer ${updated.fullName} updated.')),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      officer.isActive ? Icons.pause_circle_outline_rounded : Icons.play_circle_outline_rounded,
                                      size: 18,
                                      color: officer.isActive ? AppColors.warning : AppColors.success,
                                    ),
                                    tooltip: officer.isActive ? 'Deactivate Account' : 'Reactivate Account',
                                    onPressed: () async {
                                      final confirmed = await ModalDialogs.showConfirmation(
                                        context: context,
                                        title: officer.isActive ? 'Deactivate Officer Account?' : 'Reactivate Officer Account?',
                                        message: officer.isActive
                                            ? 'Deactivating ${officer.fullName} will temporarily suspend their ability to scrutinize and sign certificates. Historical decisions remain preserved.'
                                            : 'Reactivate ${officer.fullName} to permit access to the departmental review queue?',
                                        confirmLabel: officer.isActive ? 'Deactivate' : 'Reactivate',
                                        isDestructive: officer.isActive,
                                        icon: Icons.shield_outlined,
                                      );
                                      if (confirmed == true) {
                                        state.toggleOfficerActive(officer.id);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Officer status updated.')),
                                        );
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.danger),
                                    tooltip: 'Delete Officer Record',
                                    onPressed: () async {
                                      final confirmed = await ModalDialogs.showConfirmation(
                                        context: context,
                                        title: 'Delete Officer Record?',
                                        message: 'WARNING: Deleting is permanently destructive. We strongly recommend "Deactivate" instead so historical audit seals remain legally valid. Proceed with deletion of ${officer.fullName}?',
                                        confirmLabel: 'Permanently Delete',
                                        isDestructive: true,
                                        icon: Icons.warning_amber_rounded,
                                      );
                                      if (confirmed == true) {
                                        state.deleteOfficer(officer.id);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Officer ${officer.fullName} removed from registry.')),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
