import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_state_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/modal_dialogs.dart';

class OfficerProfileScreen extends StatefulWidget {
  final VoidCallback onLogout;

  const OfficerProfileScreen({super.key, required this.onLogout});

  @override
  State<OfficerProfileScreen> createState() => _OfficerProfileScreenState();
}

class _OfficerProfileScreenState extends State<OfficerProfileScreen> {
  late TextEditingController _userIdCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _deptCtrl;

  @override
  void initState() {
    super.initState();
    _userIdCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
    _phoneCtrl = TextEditingController();
    _deptCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _userIdCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _deptCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final officer = state.currentOfficer;

    _userIdCtrl.text = officer?.userId ?? 'sdm_priya.verma';
    _emailCtrl.text = officer?.email ?? 'priya.verma@gujarat.gov.in';
    _phoneCtrl.text = officer?.phone ?? '+91 94280 11928';
    _deptCtrl.text = officer?.departmentName ?? 'Revenue & Land Records';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.l),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Department Officer Profile', style: AppTypography.h1),
              Text('Civil Service credentials, official department designation, and security settings.', style: AppTypography.bodySmall),
              const SizedBox(height: AppSpacing.l),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: const Color(0xFF059669),
                            child: const Icon(Icons.shield_rounded, color: Colors.white, size: 36),
                          ),
                          const SizedBox(width: AppSpacing.m),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(officer?.fullName ?? 'Priya Verma, IAS', style: AppTypography.h2),
                                Text(
                                  '${officer?.designation ?? "Sub-Divisional Magistrate"} • ${officer?.departmentName ?? "Revenue"}',
                                  style: AppTypography.bodySmall.copyWith(color: AppColors.primaryAccent),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Officer ID: ${officer?.id ?? "OFF-REV-01"} • Joined: ${officer != null ? DateFormat("MMMM yyyy").format(officer.joinedDate) : "2023"}',
                                  style: AppTypography.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.l),
                      const Divider(),
                      const SizedBox(height: AppSpacing.l),

                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isCompact = constraints.maxWidth < 600;
                          final fieldWidth = isCompact ? double.infinity : 340.0;
                          
                          return Wrap(
                            spacing: AppSpacing.l,
                            runSpacing: AppSpacing.m,
                            children: [
                              SizedBox(
                                width: fieldWidth,
                                child: AppTextField(
                                  label: 'Officer User ID / Single Sign-On',
                                  readOnly: true,
                                  controller: _userIdCtrl,
                                  prefixIcon: const Icon(Icons.person_outline, size: 18),
                                ),
                              ),
                              SizedBox(
                                width: fieldWidth,
                                child: AppTextField(
                                  label: 'Official Government Email',
                                  readOnly: true,
                                  controller: _emailCtrl,
                                  prefixIcon: const Icon(Icons.email_outlined, size: 18),
                                ),
                              ),
                              SizedBox(
                                width: fieldWidth,
                                child: AppTextField(
                                  label: 'Official Mobile Number',
                                  readOnly: true,
                                  controller: _phoneCtrl,
                                  prefixIcon: const Icon(Icons.phone_android_rounded, size: 18),
                                ),
                              ),
                              SizedBox(
                                width: fieldWidth,
                                child: AppTextField(
                                  label: 'Assigned Department',
                                  readOnly: true,
                                  controller: _deptCtrl,
                                  prefixIcon: const Icon(Icons.business_rounded, size: 18),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.l),

                      // Password change section placeholder
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.m),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceSubtle,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final textCol = Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Digital Signature Certificate (DSC) & Password', style: AppTypography.labelBold),
                                Text('Last changed 42 days ago. Mandated rotation every 90 days.', style: AppTypography.bodySmall),
                              ],
                            );
                            
                            final btn = AppButton(
                              label: 'Change Password',
                              variant: AppButtonVariant.outline,
                              size: AppButtonSize.small,
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Password rotation modal dispatched to NIC gateway.')),
                                );
                              },
                            );

                            if (constraints.maxWidth < 500) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  textCol,
                                  const SizedBox(height: AppSpacing.m),
                                  SizedBox(width: double.infinity, child: btn),
                                ],
                              );
                            }

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child: textCol),
                                const SizedBox(width: AppSpacing.m),
                                btn,
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Logout Row
              Container(
                padding: const EdgeInsets.all(AppSpacing.l),
                decoration: BoxDecoration(
                  color: AppColors.dangerLight,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  border: Border.all(color: AppColors.dangerBorder),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final textCol = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Officer Session Termination', style: AppTypography.labelBold.copyWith(color: AppColors.danger)),
                        Text('Sign out from departmental scrutiny workstation and lock digital keys.', style: AppTypography.bodySmall),
                      ],
                    );
                    
                    final btn = AppButton(
                      label: 'Logout Workstation',
                      variant: AppButtonVariant.danger,
                      leadingIcon: Icons.logout_rounded,
                      onPressed: () async {
                        final confirmed = await ModalDialogs.showConfirmation(
                          context: context,
                          title: 'Confirm Officer Logout',
                          message: 'Are you sure you want to end your departmental officer session?',
                          confirmLabel: 'Logout Now',
                          isDestructive: true,
                          icon: Icons.logout_rounded,
                        );
                        if (confirmed == true) {
                          state.logout();
                          widget.onLogout();
                        }
                      },
                    );

                    if (constraints.maxWidth < 500) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          textCol,
                          const SizedBox(height: AppSpacing.m),
                          btn,
                        ],
                      );
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: textCol),
                        const SizedBox(width: AppSpacing.m),
                        btn,
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
