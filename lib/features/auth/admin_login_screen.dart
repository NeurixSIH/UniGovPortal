import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_state_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';

class AdminLoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const AdminLoginScreen({super.key, required this.onLoginSuccess});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _userIdCtrl = TextEditingController(text: 'admin_vikram.sen');
  final _passwordCtrl = TextEditingController(text: 'AdminMaster#2026');
  bool _isLoading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          // Blue Government Header
          Expanded(
            flex: 2,
            child: Container(
              color: AppColors.primary,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: AppSpacing.xl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 2),
                    ),
                    child: const Icon(Icons.admin_panel_settings_rounded, color: Colors.white, size: 34),
                  ),
                  const SizedBox(height: AppSpacing.m),
                  Text(
                    'SYSTEM ADMINISTRATION PORTAL',
                    style: AppTypography.labelBold.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                      letterSpacing: 1.5,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'System Admin Console',
                    style: AppTypography.h1.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                    child: Text(
                      'Role-Based Access Control & User Administration',
                      style: AppTypography.bodySmall.copyWith(color: Colors.white, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // White Card Body
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_error != null) ...[
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.m),
                            decoration: BoxDecoration(
                              color: AppColors.dangerLight,
                              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                              border: Border.all(color: AppColors.dangerBorder),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.error_outline_rounded, color: AppColors.danger, size: 20),
                                const SizedBox(width: AppSpacing.s),
                                Expanded(
                                  child: Text(_error!, style: AppTypography.bodySmall.copyWith(color: AppColors.danger)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSpacing.m),
                        ],

                        AppTextField(
                          label: 'Root Admin User ID',
                          hint: 'e.g. admin_vikram.sen',
                          controller: _userIdCtrl,
                          isRequired: true,
                          prefixIcon: const Icon(Icons.supervisor_account_rounded, size: 20, color: AppColors.primary),
                        ),
                        const SizedBox(height: AppSpacing.m),

                        AppTextField(
                          label: 'Master Console Password',
                          hint: '••••••••••••',
                          controller: _passwordCtrl,
                          obscureText: true,
                          isRequired: true,
                          prefixIcon: const Icon(Icons.key_rounded, size: 20, color: AppColors.primary),
                        ),
                        const SizedBox(height: AppSpacing.xl),

                        AppButton(
                          label: 'Authenticate & Enter Admin Console',
                          isFullWidth: true,
                          isLoading: _isLoading,
                          size: AppButtonSize.large,
                          leadingIcon: Icons.verified_user_rounded,
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                              _error = null;
                            });

                            await Future.delayed(const Duration(milliseconds: 600));

                            if (!mounted) return;
                            setState(() => _isLoading = false);

                            if (_userIdCtrl.text.trim().isEmpty || _passwordCtrl.text.trim().isEmpty) {
                              setState(() => _error = 'Please enter administrator credentials.');
                              return;
                            }

                            state.login(UserRole.admin);
                            widget.onLoginSuccess();
                          },
                        ),

                        const SizedBox(height: AppSpacing.l),
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.m),
                          decoration: BoxDecoration(
                            color: AppColors.primarySurface,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                            border: Border.all(color: AppColors.primaryBorder),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.verified_user_outlined, size: 18, color: AppColors.primary),
                              const SizedBox(width: AppSpacing.s),
                              Expanded(
                                child: Text(
                                  'Root Level System Admin Access. Multi-factor hardware security key enabled.',
                                  style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.primary),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
