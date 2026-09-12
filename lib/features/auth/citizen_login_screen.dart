import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_state_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';

class CitizenLoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const CitizenLoginScreen({super.key, required this.onLoginSuccess});

  @override
  State<CitizenLoginScreen> createState() => _CitizenLoginScreenState();
}

class _CitizenLoginScreenState extends State<CitizenLoginScreen> {
  bool _isSignUpMode = false; // false = Sign In, true = Sign Up
  
  // Sign In Controllers
  final _fullNameCtrl = TextEditingController(text: 'Rajesh Kumar Sharma');
  final _dobCtrl = TextEditingController(text: '14/08/1988');
  final _addressCtrl = TextEditingController(text: 'Flat 402, Shanti Vihar, Sector 12, Gandhinagar, Gujarat - 382016');
  final _aadhaarCtrl = TextEditingController(text: '5849 2019 8924');

  // Sign Up Extra Controllers
  final _mobileCtrl = TextEditingController(text: '98765 43210');
  final _emailCtrl = TextEditingController(text: 'rajesh.sharma@example.com');
  String _selectedCategory = 'OBC / EWS';
  String _selectedIncome = '< ₹2.5 Lakhs/year';

  bool _isAadhaarOtpStage = false;
  final _otpCtrl = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _dobCtrl.dispose();
    _addressCtrl.dispose();
    _aadhaarCtrl.dispose();
    _mobileCtrl.dispose();
    _emailCtrl.dispose();
    _otpCtrl.dispose();
    super.dispose();
  }

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
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/images/gov_logo.png',
                      height: 56,
                      width: 56,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.account_balance_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.m),
                  Text(
                    'Government Interoperability Hub',
                    style: AppTypography.h2.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Government Unified Portal • Setu e-Services',
                    style: AppTypography.bodyMedium.copyWith(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.s),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                    child: Text(
                      'One Login • Multiple Services • Connected Departments',
                      style: AppTypography.labelSmall.copyWith(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // White Form Card Area
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppSpacing.radiusXl),
                  topRight: Radius.circular(AppSpacing.radiusXl),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.l),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Sign In vs Sign Up Toggle Pills
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceSubtle,
                                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () => setState(() {
                                        _isSignUpMode = false;
                                        _isAadhaarOtpStage = false;
                                        _errorMessage = null;
                                      }),
                                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        decoration: BoxDecoration(
                                          color: !_isSignUpMode ? Colors.white : Colors.transparent,
                                          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                                          boxShadow: !_isSignUpMode
                                              ? const [BoxShadow(color: Color(0x0A000000), blurRadius: 4)]
                                              : null,
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Sign In',
                                          style: AppTypography.labelBold.copyWith(
                                            color: !_isSignUpMode ? AppColors.primary : AppColors.textSecondary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () => setState(() {
                                        _isSignUpMode = true;
                                        _isAadhaarOtpStage = false;
                                        _errorMessage = null;
                                      }),
                                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        decoration: BoxDecoration(
                                          color: _isSignUpMode ? Colors.white : Colors.transparent,
                                          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                                          boxShadow: _isSignUpMode
                                              ? const [BoxShadow(color: Color(0x0A000000), blurRadius: 4)]
                                              : null,
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          'New Registration (Sign Up)',
                                          style: AppTypography.labelBold.copyWith(
                                            color: _isSignUpMode ? AppColors.primary : AppColors.textSecondary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSpacing.l),

                            Text(
                              _isAadhaarOtpStage
                                  ? 'Verify Aadhaar OTP'
                                  : (_isSignUpMode ? 'Register New Citizen Profile' : 'Welcome Back'),
                              style: AppTypography.h2.copyWith(color: AppColors.primary),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              _isAadhaarOtpStage
                                  ? 'Enter the 6-digit OTP sent to mobile registered with Aadhaar ending in ...8924'
                                  : (_isSignUpMode
                                      ? 'Create your verified citizen account with UIDAI e-KYC for instant scheme eligibility.'
                                      : 'Sign in with your Aadhaar e-KYC credentials.'),
                              style: AppTypography.bodyMedium,
                            ),
                            const SizedBox(height: AppSpacing.l),

                            if (_errorMessage != null) ...[
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
                                      child: Text(
                                        _errorMessage!,
                                        style: AppTypography.bodySmall.copyWith(color: AppColors.danger),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: AppSpacing.m),
                            ],

                            if (!_isAadhaarOtpStage) ...[
                              AppTextField(
                                label: 'Full Name (As per Aadhaar)',
                                hint: 'Enter your full legal name',
                                controller: _fullNameCtrl,
                                isRequired: true,
                                prefixIcon: const Icon(Icons.person_outline_rounded, size: 20),
                              ),
                              const SizedBox(height: AppSpacing.m),
                              AppTextField(
                                label: '12-Digit Aadhaar Number',
                                hint: 'XXXX XXXX XXXX',
                                controller: _aadhaarCtrl,
                                isRequired: true,
                                prefixIcon: const Icon(Icons.credit_card_rounded, size: 20),
                              ),
                              const SizedBox(height: AppSpacing.m),

                              if (_isSignUpMode) ...[
                                Row(
                                  children: [
                                    Expanded(
                                      child: AppTextField(
                                        label: 'Mobile Number',
                                        hint: '9876543210',
                                        controller: _mobileCtrl,
                                        isRequired: true,
                                        prefixIcon: const Icon(Icons.phone_android_rounded, size: 20),
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.m),
                                    Expanded(
                                      child: AppTextField(
                                        label: 'Date of Birth',
                                        hint: 'DD/MM/YYYY',
                                        controller: _dobCtrl,
                                        isRequired: true,
                                        prefixIcon: const Icon(Icons.calendar_today_rounded, size: 20),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.m),
                                AppTextField(
                                  label: 'Email Address',
                                  hint: 'citizen@example.com',
                                  controller: _emailCtrl,
                                  prefixIcon: const Icon(Icons.email_outlined, size: 20),
                                ),
                                const SizedBox(height: AppSpacing.m),

                                // Category Dropdown
                                Text('Social Category / Reservation', style: AppTypography.labelBold.copyWith(fontSize: 12)),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.border),
                                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                    color: Colors.white,
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedCategory,
                                      isExpanded: true,
                                      items: const [
                                        DropdownMenuItem(value: 'General', child: Text('General')),
                                        DropdownMenuItem(value: 'OBC / EWS', child: Text('OBC / Economically Weaker Section (EWS)')),
                                        DropdownMenuItem(value: 'Scheduled Caste (SC)', child: Text('Scheduled Caste (SC)')),
                                        DropdownMenuItem(value: 'Scheduled Tribe (ST)', child: Text('Scheduled Tribe (ST)')),
                                      ],
                                      onChanged: (val) => setState(() => _selectedCategory = val!),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.m),

                                // Annual Income Dropdown
                                Text('Annual Household Income', style: AppTypography.labelBold.copyWith(fontSize: 12)),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.border),
                                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                    color: Colors.white,
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedIncome,
                                      isExpanded: true,
                                      items: const [
                                        DropdownMenuItem(value: '< ₹2.5 Lakhs/year', child: Text('Below ₹2.5 Lakhs (Full Scheme Subsidies)')),
                                        DropdownMenuItem(value: '₹2.5L - ₹5 Lakhs', child: Text('₹2.5 Lakhs - ₹5.0 Lakhs')),
                                        DropdownMenuItem(value: '₹5.0L - ₹8 Lakhs', child: Text('₹5.0 Lakhs - ₹8.0 Lakhs')),
                                        DropdownMenuItem(value: '> ₹8.0 Lakhs', child: Text('Above ₹8.0 Lakhs')),
                                      ],
                                      onChanged: (val) => setState(() => _selectedIncome = val!),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.m),
                              ],

                              AppTextField(
                                label: 'Permanent Address',
                                hint: 'Residential address with Pincode',
                                controller: _addressCtrl,
                                maxLines: 2,
                                isRequired: true,
                                prefixIcon: const Icon(Icons.home_outlined, size: 20),
                              ),
                            ] else ...[
                              AppTextField(
                                label: 'Enter 6-digit UIDAI OTP',
                                hint: 'e.g. 123456 (Demo: any 6 digits)',
                                controller: _otpCtrl,
                                isRequired: true,
                                keyboardType: TextInputType.number,
                                prefixIcon: const Icon(Icons.lock_clock_outlined, size: 20),
                                helperText: 'Aadhaar OTP is valid for 10 minutes.',
                              ),
                              const SizedBox(height: AppSpacing.s),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('A fresh OTP was dispatched to your mobile.')),
                                    );
                                  },
                                  child: const Text('Resend OTP'),
                                ),
                              ),
                            ],

                            const SizedBox(height: AppSpacing.xl),

                            AppButton(
                              label: _isAadhaarOtpStage
                                  ? 'Verify & Enter Portal'
                                  : (_isSignUpMode ? 'Register & Verify e-KYC' : 'Generate Aadhaar OTP'),
                              isFullWidth: true,
                              isLoading: _isLoading,
                              size: AppButtonSize.large,
                              leadingIcon: _isAadhaarOtpStage ? Icons.verified_user_rounded : Icons.lock_outline_rounded,
                              onPressed: () async {
                                setState(() {
                                  _isLoading = true;
                                  _errorMessage = null;
                                });

                                await Future.delayed(const Duration(milliseconds: 600));

                                if (!mounted) return;

                                if (!_isAadhaarOtpStage) {
                                  if (_fullNameCtrl.text.trim().isEmpty || _aadhaarCtrl.text.trim().length < 12) {
                                    setState(() {
                                      _isLoading = false;
                                      _errorMessage = 'Please provide a valid 12-digit Aadhaar number and legal name.';
                                    });
                                    return;
                                  }

                                  setState(() {
                                    _isLoading = false;
                                    _isAadhaarOtpStage = true;
                                  });
                                } else {
                                  setState(() => _isLoading = false);
                                  state.login(UserRole.citizen);
                                  widget.onLoginSuccess();
                                }
                              },
                            ),

                            const SizedBox(height: AppSpacing.l),

                            // Security notice footer
                            Container(
                              padding: const EdgeInsets.all(AppSpacing.m),
                              decoration: BoxDecoration(
                                color: AppColors.primarySurface,
                                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                border: Border.all(color: AppColors.primaryBorder),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.shield_rounded, size: 18, color: AppColors.primary),
                                  const SizedBox(width: AppSpacing.s),
                                  Expanded(
                                    child: Text(
                                      'Secured with SHA-256 Bit Encryption & Aadhaar Authentication Regulations 2016.',
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
            ),
          ),
        ],
      ),
    );
  }
}
