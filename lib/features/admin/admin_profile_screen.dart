import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_state_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/modal_dialogs.dart';

class AdminProfileScreen extends StatelessWidget {
  final VoidCallback onLogout;

  const AdminProfileScreen({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.l),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('System Administrator Profile', style: AppTypography.h1),
              Text('Root administrator credentials, system logs, and security controls.', style: AppTypography.bodySmall),
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
                            backgroundColor: const Color(0xFF7C3AED),
                            child: const Icon(Icons.admin_panel_settings_rounded, color: Colors.white, size: 36),
                          ),
                          const SizedBox(width: AppSpacing.m),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Vikram Sen', style: AppTypography.h2),
                                Text(
                                  'Senior System Administrator • National Informatics Centre (NIC)',
                                  style: AppTypography.bodySmall.copyWith(color: AppColors.primaryAccent),
                                ),
                                const SizedBox(height: 4),
                                Text('User ID: admin_vikram.sen • Role: Super Admin (Root)', style: AppTypography.bodySmall),
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
                                  label: 'Administrator Identity',
                                  readOnly: true,
                                  controller: TextEditingController(text: 'Vikram Sen (EMP-NIC-9041)'),
                                  prefixIcon: const Icon(Icons.badge_outlined, size: 18),
                                ),
                              ),
                              SizedBox(
                                width: fieldWidth,
                                child: AppTextField(
                                  label: 'Root Admin Email',
                                  readOnly: true,
                                  controller: TextEditingController(text: 'vikram.sen@nic.in'),
                                  prefixIcon: const Icon(Icons.email_outlined, size: 18),
                                ),
                              ),
                              SizedBox(
                                width: fieldWidth,
                                child: AppTextField(
                                  label: 'System Access Level',
                                  readOnly: true,
                                  controller: TextEditingController(text: 'Level 5 (Unrestricted SuperAdmin)'),
                                  prefixIcon: const Icon(Icons.lock_open_rounded, size: 18),
                                ),
                              ),
                              SizedBox(
                                width: fieldWidth,
                                child: AppTextField(
                                  label: '2-Factor Authentication Device',
                                  readOnly: true,
                                  controller: TextEditingController(text: 'FIDO2 Hardware Key (Active)'),
                                  prefixIcon: const Icon(Icons.security_rounded, size: 18),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Logout Card (A-10)
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
                        Text('Terminate Admin Session', style: AppTypography.labelBold.copyWith(color: AppColors.danger)),
                        Text('Exit super-administrator console and revoke temporary privilege elevation.', style: AppTypography.bodySmall),
                      ],
                    );
                    
                    final btn = AppButton(
                      label: 'Exit Admin Console',
                      variant: AppButtonVariant.danger,
                      leadingIcon: Icons.logout_rounded,
                      onPressed: () async {
                        final confirmed = await ModalDialogs.showConfirmation(
                          context: context,
                          title: 'Terminate Root Session?',
                          message: 'Are you sure you want to exit the System Admin console?',
                          confirmLabel: 'Logout Admin',
                          isDestructive: true,
                          icon: Icons.logout_rounded,
                        );
                        if (confirmed == true) {
                          state.logout();
                          onLogout();
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
