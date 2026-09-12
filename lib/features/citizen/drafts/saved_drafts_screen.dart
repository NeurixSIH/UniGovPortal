import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/data/demo_data.dart';
import '../../../core/models/application_model.dart';
import '../../../core/models/application_status.dart';
import '../../../core/models/service_model.dart';
import '../../../core/state/app_state_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';

class SavedDraftsScreen extends StatelessWidget {
  final VoidCallback onBack;
  final ValueChanged<String> onResumeDraft;

  const SavedDraftsScreen({
    super.key,
    required this.onBack,
    required this.onResumeDraft,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final drafts = state.applications.where((a) => a.status == AppStatus.draft).toList();
    final isMobile = MediaQuery.of(context).size.width < 600;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? AppSpacing.m : AppSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Blue Banner Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.l),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.edit_note_rounded, color: Colors.white, size: 28),
                              const SizedBox(width: AppSpacing.s),
                              Text(
                                'Saved Drafts',
                                style: AppTypography.h2.copyWith(color: Colors.white, fontWeight: FontWeight.w800),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Resume your incomplete applications or save new service forms as drafts.',
                            style: AppTypography.bodySmall.copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    AppButton(
                      label: '+ Save New Draft',
                      size: AppButtonSize.small,
                      variant: AppButtonVariant.secondary,
                      onPressed: () => _showCreateDraftDialog(context, state),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.m),
                // Stats indicator pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.s),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.info_outline_rounded, color: Colors.white70, size: 16),
                      const SizedBox(width: AppSpacing.s),
                      Text(
                        '${drafts.length} ${drafts.length == 1 ? 'draft' : 'drafts'} saved • Auto-saved in active session',
                        style: AppTypography.bodySmall.copyWith(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.l),

          // Drafts List or Empty State
          if (drafts.isEmpty)
            _buildEmptyState(context, state)
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: drafts.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.m),
              itemBuilder: (context, index) {
                final draft = drafts[index];
                return _buildDraftCard(context, state, draft);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppStateProvider state) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.xxl),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.primarySurface,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.drafts_outlined, size: 48, color: AppColors.primary),
            ),
            const SizedBox(height: AppSpacing.l),
            Text('No Saved Drafts', style: AppTypography.h2),
            const SizedBox(height: AppSpacing.xs),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Text(
                'You currently do not have any saved or in-progress applications. Start an application and save your progress anytime.',
                style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppSpacing.l),
            AppButton(
              label: 'Save a New Draft Now',
              leadingIcon: Icons.add_rounded,
              onPressed: () => _showCreateDraftDialog(context, state),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDraftCard(BuildContext context, AppStateProvider state, ApplicationModel draft) {
    final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');
    final formattedDate = dateFormat.format(draft.lastUpdated);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        side: const BorderSide(color: AppColors.border, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: ID, Status, and Delete button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBEB),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                        border: Border.all(color: const Color(0xFFFDE68A)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.hourglass_top_rounded, size: 12, color: Color(0xFFD97706)),
                          const SizedBox(width: 4),
                          Text(
                            'DRAFT',
                            style: AppTypography.labelBold.copyWith(
                              fontSize: 10,
                              color: const Color(0xFFB45309),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s),
                    Text(
                      draft.id,
                      style: AppTypography.bodySmall.copyWith(
                        fontFamily: 'monospace',
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, color: AppColors.danger, size: 20),
                  tooltip: 'Delete Draft',
                  onPressed: () => _confirmDeleteDraft(context, state, draft),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s),

            // Service Name and Department
            Text(
              draft.serviceName,
              style: AppTypography.h3.copyWith(fontWeight: FontWeight.w800, fontSize: 18),
            ),
            const SizedBox(height: 2),
            Text(
              draft.departmentName,
              style: AppTypography.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: AppSpacing.m),

            // Form data / progress chips
            if (draft.formData.isNotEmpty) ...[
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: draft.formData.entries.take(3).map((e) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSubtle,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      '${e.key}: ${e.value}',
                      style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.m),
            ],

            const Divider(height: 1, color: AppColors.border),
            const SizedBox(height: AppSpacing.m),

            // Footer row: Last saved timestamp and Resume button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded, size: 14, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text(
                      'Last saved: $formattedDate',
                      style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.textMuted),
                    ),
                  ],
                ),
                AppButton(
                  label: 'Resume Draft',
                  size: AppButtonSize.small,
                  leadingIcon: Icons.play_arrow_rounded,
                  onPressed: () => onResumeDraft(draft.serviceId),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateDraftDialog(BuildContext context, AppStateProvider state) {
    ServiceModel? selectedService = state.services.isNotEmpty ? state.services.first : null;
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusXl)),
              title: Row(
                children: [
                  const Icon(Icons.note_add_rounded, color: AppColors.primary),
                  const SizedBox(width: AppSpacing.s),
                  Text('Save New Draft', style: AppTypography.h3),
                ],
              ),
              content: SizedBox(
                width: 440,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select a government service to initiate and save as an incomplete draft:',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: AppSpacing.m),
                    Text('Select Service', style: AppTypography.labelBold),
                    const SizedBox(height: AppSpacing.xs),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<ServiceModel>(
                          isExpanded: true,
                          value: selectedService,
                          items: state.services.map((s) {
                            return DropdownMenuItem<ServiceModel>(
                              value: s,
                              child: Text(
                                '${s.name} (${s.departmentName.split(' ').first})',
                                style: AppTypography.bodySmall,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (newSrv) {
                            if (newSrv != null) {
                              setModalState(() => selectedService = newSrv);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.m),
                    Text('Draft Notes / Purpose (Optional)', style: AppTypography.labelBold),
                    const SizedBox(height: AppSpacing.xs),
                    TextField(
                      controller: notesController,
                      decoration: InputDecoration(
                        hintText: 'e.g. College admission application draft',
                        hintStyle: AppTypography.bodySmall.copyWith(color: AppColors.textLight),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        ),
                        isDense: true,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
                  ),
                  onPressed: () {
                    if (selectedService == null) return;
                    final srv = selectedService!;
                    final newDraftId = 'DRF-MH-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
                    final newDraft = ApplicationModel(
                      id: newDraftId,
                      serviceId: srv.id,
                      serviceName: srv.name,
                      departmentId: srv.departmentId,
                      departmentName: srv.departmentName,
                      citizenId: 'CIT-2026-9481',
                      citizenName: DemoData.citizenProfile['fullName'] ?? 'Krisha Patel',
                      citizenAadhaar: 'XXXX-XXXX-8924',
                      citizenPhone: '+91 98765 43210',
                      citizenEmail: 'krisha.patel@govmail.in',
                      citizenAddress: 'Flat 302, Green Avenue, Pune, Maharashtra - 411001',
                      status: AppStatus.draft,
                      submissionDate: DateTime.now(),
                      lastUpdated: DateTime.now(),
                      formData: {
                        if (notesController.text.trim().isNotEmpty)
                          'draftNotes': notesController.text.trim(),
                        'serviceType': srv.category,
                      },
                      documents: [],
                      timeline: [
                        TimelineEvent(
                          stage: AppStatus.draft,
                          title: 'Draft Saved',
                          description: 'Citizen saved draft for ${srv.name}.',
                          timestamp: DateTime.now(),
                          actorRole: 'Citizen',
                        ),
                      ],
                    );

                    state.saveDraftApplication(newDraft);
                    Navigator.pop(dialogCtx);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Draft saved successfully: ${srv.name} ($newDraftId)'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  },
                  child: const Text('Save Draft'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDeleteDraft(BuildContext context, AppStateProvider state, ApplicationModel draft) {
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusXl)),
          title: const Text('Delete Draft?'),
          content: Text('Are you sure you want to delete draft "${draft.serviceName}" (${draft.id})? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.danger,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                state.deleteDraftApplication(draft.id);
                Navigator.pop(dialogCtx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Deleted draft ${draft.id}')),
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
