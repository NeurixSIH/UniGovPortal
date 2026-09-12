import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/data/demo_data.dart';
import '../../../core/state/app_state_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_avatar.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/modal_dialogs.dart';

class CitizenProfileScreen extends StatefulWidget {
  final VoidCallback onLogout;

  const CitizenProfileScreen({super.key, required this.onLogout});

  @override
  State<CitizenProfileScreen> createState() => _CitizenProfileScreenState();
}

class _CitizenProfileScreenState extends State<CitizenProfileScreen> {
  int? _activeSection; // null: Main Settings List, 1: Profile, 2: Eligible Schemes, 3: Language, 4: Consent, 5: Notifications, 6: Security

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final citizen = DemoData.citizenProfile;
    final isMobile = MediaQuery.of(context).size.width < 600;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? AppSpacing.m : AppSpacing.l),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Blue Profile Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(isMobile ? AppSpacing.m : AppSpacing.l),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                  boxShadow: const [
                    BoxShadow(color: Color(0x220057B7), blurRadius: 16, offset: Offset(0, 6)),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        AppAvatar(
                          name: citizen['fullName'] ?? 'Krisha Patel',
                          radius: isMobile ? 24 : 32,
                          backgroundColor: Colors.white.withValues(alpha: 0.25),
                          textColor: Colors.white,
                        ),
                        const SizedBox(width: AppSpacing.m),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                citizen['fullName'] ?? '',
                                style: (isMobile ? AppTypography.h3 : AppTypography.h2).copyWith(color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Citizen ID: ${citizen["id"] ?? "MH12345"}',
                                style: AppTypography.bodySmall.copyWith(color: Colors.white70),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.verified_rounded, size: 12, color: Color(0xFF67E8F9)),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        'Aadhaar Verified',
                                        style: AppTypography.labelSmall.copyWith(color: Colors.white),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_activeSection != null)
                          IconButton(
                            onPressed: () => setState(() => _activeSection = null),
                            icon: const Icon(Icons.close_rounded, color: Colors.white),
                            tooltip: 'Close Settings Detail',
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.m),
                    // Profile completion
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.m),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Profile Completion',
                                  style: AppTypography.labelBold.copyWith(color: Colors.white),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.s),
                              Text('80%', style: AppTypography.labelBold.copyWith(color: Colors.white)),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                            child: LinearProgressIndicator(
                              value: 0.80,
                              minHeight: 8,
                              backgroundColor: Colors.white.withValues(alpha: 0.2),
                              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF67E8F9)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.l),

              // Instagram / Settings List View OR Active Section Details
              if (_activeSection == null)
                _buildInstagramSettingsList(context, state, citizen, isMobile)
              else
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.all(isMobile ? AppSpacing.m : AppSpacing.xl),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Back Navigation Bar
                        InkWell(
                          onTap: () => setState(() => _activeSection = null),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: AppColors.primary),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    'Back to Profile Settings',
                                    style: AppTypography.labelBold.copyWith(color: AppColors.primary),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.m),
                        const Divider(),
                        const SizedBox(height: AppSpacing.m),

                        _buildSectionDetailContent(state, citizen, isMobile),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Instagram Style Profile Settings List Menu
  Widget _buildInstagramSettingsList(
    BuildContext context,
    AppStateProvider state,
    Map<String, dynamic> citizen,
    bool isMobile,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
      child: Column(
        children: [
          // Section Title Header
          Padding(
            padding: const EdgeInsets.all(AppSpacing.l),
            child: Row(
              children: [
                const Icon(Icons.settings_outlined, color: AppColors.primary, size: 20),
                const SizedBox(width: AppSpacing.s),
                Expanded(
                  child: Text(
                    'Profile Settings & Account Options',
                    style: AppTypography.h3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // 1. Update Profile & Demographics
          _buildSettingsListItem(
            icon: Icons.person_outline_rounded,
            iconBgColor: AppColors.primarySurface,
            iconColor: AppColors.primary,
            title: 'Update Profile & Demographics',
            subtitle: 'Aadhaar certified identity, mobile & domicile address',
            trailingWidget: const Icon(Icons.chevron_right_rounded, color: AppColors.textLight),
            onTap: () => setState(() => _activeSection = 1),
          ),
          const Divider(height: 1, indent: 64),

          // 2. Eligible Schemes & Subsidies
          _buildSettingsListItem(
            icon: Icons.stars_rounded,
            iconBgColor: const Color(0xFFFFFBEB),
            iconColor: const Color(0xFFD97706),
            title: 'Eligible Schemes & Subsidies',
            subtitle: '4 Government schemes matched with your profile',
            trailingWidget: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    border: Border.all(color: AppColors.successBorder),
                  ),
                  child: Text(
                    '4 Matched',
                    style: AppTypography.labelSmall.copyWith(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right_rounded, color: AppColors.textLight),
              ],
            ),
            onTap: () => setState(() => _activeSection = 2),
          ),
          const Divider(height: 1, indent: 64),

          // 3. Language Option
          _buildSettingsListItem(
            icon: Icons.language_rounded,
            iconBgColor: const Color(0xFFCCFBF1),
            iconColor: const Color(0xFF0D9488),
            title: isMobile ? 'Language' : 'Language (ભાષા / भाषा)',
            subtitle: 'Select interface language for portal',
            trailingWidget: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSubtle,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Text(
                    state.currentLanguage,
                    style: AppTypography.labelSmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 11),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right_rounded, color: AppColors.textLight),
              ],
            ),
            onTap: () => setState(() => _activeSection = 3),
          ),
          const Divider(height: 1, indent: 64),

          // 4. Consent & Privacy
          _buildSettingsListItem(
            icon: Icons.security_rounded,
            iconBgColor: const Color(0xFFECFDF5),
            iconColor: const Color(0xFF059669),
            title: isMobile ? 'Consent' : 'Consent & Privacy',
            subtitle: 'DPDP Act compliance & DigiLocker approvals',
            trailingWidget: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  ),
                  child: Text(
                    '3 Active',
                    style: AppTypography.labelSmall.copyWith(color: AppColors.success, fontSize: 11),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right_rounded, color: AppColors.textLight),
              ],
            ),
            onTap: () => setState(() => _activeSection = 4),
          ),
          const Divider(height: 1, indent: 64),

          // 5. Notification Settings
          _buildSettingsListItem(
            icon: Icons.notifications_none_rounded,
            iconBgColor: const Color(0xFFF5F3FF),
            iconColor: const Color(0xFF7C3AED),
            title: 'Notification Preferences',
            subtitle: 'WhatsApp alerts, SMS updates & Application tracking',
            trailingWidget: const Icon(Icons.chevron_right_rounded, color: AppColors.textLight),
            onTap: () => setState(() => _activeSection = 5),
          ),
          const Divider(height: 1, indent: 64),

          // 6. Security & Hardware Key
          _buildSettingsListItem(
            icon: Icons.shield_outlined,
            iconBgColor: const Color(0xFFEFF6FF),
            iconColor: const Color(0xFF2563EB),
            title: 'Security & Biometric e-Sign',
            subtitle: 'Aadhaar PIN, hardware key & active session log',
            trailingWidget: const Icon(Icons.chevron_right_rounded, color: AppColors.textLight),
            onTap: () => setState(() => _activeSection = 6),
          ),
          const Divider(height: 1, indent: 64),

          // 7. Logout Session (Destructive Red)
          _buildSettingsListItem(
            icon: Icons.logout_rounded,
            iconBgColor: AppColors.dangerLight,
            iconColor: AppColors.danger,
            title: 'Logout Citizen Session',
            subtitle: 'Safely disconnect your Aadhaar e-KYC session',
            titleColor: AppColors.danger,
            trailingWidget: const Icon(Icons.chevron_right_rounded, color: AppColors.danger),
            onTap: () async {
              final confirmed = await ModalDialogs.showConfirmation(
                context: context,
                title: 'Confirm Logout',
                message: 'Are you sure you want to end your Setu session? Any unsaved form draft will be preserved.',
                confirmLabel: 'Logout Now',
                isDestructive: true,
                icon: Icons.logout_rounded,
              );
              if (confirmed == true) {
                state.logout();
                widget.onLogout();
              }
            },
          ),
          const SizedBox(height: AppSpacing.s),
        ],
      ),
    );
  }

  Widget _buildSettingsListItem({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    Color? titleColor,
    required Widget trailingWidget,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconBgColor,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        title,
        style: AppTypography.labelBold.copyWith(
          color: titleColor ?? AppColors.textPrimary,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 12),
      ),
      trailing: trailingWidget,
    );
  }

  Widget _buildSectionDetailContent(AppStateProvider state, Map<String, dynamic> citizen, bool isMobile) {
    switch (_activeSection) {
      case 1:
        return _buildProfileTab(citizen, isMobile);
      case 2:
        return _buildEligibleSchemesTab(citizen, isMobile);
      case 3:
        return _buildLanguageTab(state);
      case 4:
        return _buildConsentTab(citizen);
      case 5:
        return _buildNotificationSettingsTab();
      case 6:
        return _buildSecuritySettingsTab();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildNotificationSettingsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Notification Preferences', style: AppTypography.h3),
        Text('Configure e-Governance alerts across SMS, Email and WhatsApp.', style: AppTypography.bodySmall),
        const SizedBox(height: AppSpacing.l),
        const Divider(),
        const SizedBox(height: AppSpacing.m),

        SwitchListTile(
          value: true,
          onChanged: (val) {},
          title: Text('WhatsApp SLA Status Alerts', style: AppTypography.labelBold),
          subtitle: Text('Receive real-time progress updates when an officer moves your file.', style: AppTypography.bodySmall),
        ),
        const Divider(),
        SwitchListTile(
          value: true,
          onChanged: (val) {},
          title: Text('SMS OTP & Dispatch Confirmations', style: AppTypography.labelBold),
          subtitle: Text('Receive SMS notification on certificate generation.', style: AppTypography.bodySmall),
        ),
        const Divider(),
        SwitchListTile(
          value: false,
          onChanged: (val) {},
          title: Text('New Scheme Alerts & Recommendations', style: AppTypography.labelBold),
          subtitle: Text('Get notified when new subsidies matching your income profile are launched.', style: AppTypography.bodySmall),
        ),
      ],
    );
  }

  Widget _buildSecuritySettingsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Security & Biometric e-Sign', style: AppTypography.h3),
        Text('Manage hardware security keys and active session authentication.', style: AppTypography.bodySmall),
        const SizedBox(height: AppSpacing.l),
        const Divider(),
        const SizedBox(height: AppSpacing.m),

        ListTile(
          leading: const Icon(Icons.fingerprint_rounded, color: AppColors.primary),
          title: Text('Aadhaar Biometric e-Sign', style: AppTypography.labelBold),
          subtitle: Text('Enabled for instant self-attestation of PDF documents.', style: AppTypography.bodySmall),
          trailing: const Icon(Icons.check_circle_rounded, color: AppColors.success),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.devices_rounded, color: AppColors.primary),
          title: Text('Active Session Logs', style: AppTypography.labelBold),
          subtitle: Text('Windows PC • Chrome browser • IP: 103.24.12.98 (Active Now)', style: AppTypography.bodySmall),
          trailing: OutlinedButton(
            onPressed: () {},
            child: const Text('Revoke'),
          ),
        ),
      ],
    );
  }

  // Eligible Schemes Tab (Personalized according to user data)
  Widget _buildEligibleSchemesTab(Map<String, dynamic> citizen, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: const Icon(Icons.stars_rounded, color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: AppSpacing.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Eligible Schemes & Services', style: AppTypography.h3),
                  Text(
                    'Matched using your verified Aadhaar demographic & income records.',
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.m),
        const Divider(),
        const SizedBox(height: AppSpacing.m),

        // Recommendation Banner
        Container(
          padding: const EdgeInsets.all(AppSpacing.m),
          decoration: BoxDecoration(
            color: AppColors.primarySurface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: AppColors.primaryBorder),
          ),
          child: Row(
            children: [
              const Icon(Icons.auto_awesome_rounded, color: AppColors.primary, size: 20),
              const SizedBox(width: AppSpacing.s),
              Expanded(
                child: Text(
                  '4 Government Schemes matched with 95%+ eligibility based on your Income (< ₹2.5L) & Gujarat Domicile.',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.l),

        // Scheme Cards
        _buildSchemeCard(
          title: 'Post-Matric Higher Education Subsidy Scheme',
          department: 'Department of Social Justice & Empowerment',
          matchPercentage: '100% Eligible',
          matchReason: 'Income < ₹2.5L/yr & Verified Category (OBC/EWS)',
          benefitText: '100% Fee Waiver + ₹ 12,000 Annual Book Allowance',
          documentsPreVerified: ['Aadhaar Card', 'Income Certificate', 'Caste Certificate'],
          isMobile: isMobile,
          context: context,
        ),
        const SizedBox(height: AppSpacing.m),

        _buildSchemeCard(
          title: 'PM Kisan Samman Nidhi & Farmer Input Grant',
          department: 'Department of Agriculture & Farmers Welfare',
          matchPercentage: '98% Match',
          matchReason: 'Rural Landholder Domicile Match in Gandhinagar District',
          benefitText: '₹ 6,000 Direct Benefit Transfer (DBT) to Bank Account',
          documentsPreVerified: ['Aadhaar e-KYC', 'Land Record 7/12'],
          isMobile: isMobile,
          context: context,
        ),
        const SizedBox(height: AppSpacing.m),

        _buildSchemeCard(
          title: 'Mukhyamantri Amrutum (MA) Health Cover Card',
          department: 'Health & Family Welfare Department',
          matchPercentage: '100% Eligible',
          matchReason: 'Low Income Family Roster in NFSA Database',
          benefitText: '₹ 5,00,000 Cashless Secondary & Tertiary Health Insurance',
          documentsPreVerified: ['Ration Card', 'Aadhaar e-KYC'],
          isMobile: isMobile,
          context: context,
        ),
        const SizedBox(height: AppSpacing.m),

        _buildSchemeCard(
          title: 'Non-Creamy Layer (NCL) Statutory Certificate',
          department: 'Revenue & Revenue Administration',
          matchPercentage: '100% Eligible',
          matchReason: 'Pre-Approved by Tehsildar Office (Auto-Fill Ready)',
          benefitText: 'Fast-Track 3-Day SLA Delivery with Digital Signature',
          documentsPreVerified: ['Income Tax Return', 'Residential Domicile'],
          isMobile: isMobile,
          context: context,
        ),
      ],
    );
  }

  Widget _buildSchemeCard({
    required String title,
    required String department,
    required String matchPercentage,
    required String matchReason,
    required String benefitText,
    required List<String> documentsPreVerified,
    required bool isMobile,
    required BuildContext context,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(color: Color(0x08000000), blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  border: Border.all(color: AppColors.successBorder),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle_rounded, size: 12, color: AppColors.success),
                    const SizedBox(width: 4),
                    Text(
                      matchPercentage,
                      style: AppTypography.labelSmall.copyWith(color: AppColors.success, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Text(
                'Pre-Verified',
                style: AppTypography.labelSmall.copyWith(color: AppColors.primary, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s),

          Text(title, style: AppTypography.h3.copyWith(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(department, style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11)),
          const SizedBox(height: AppSpacing.s),

          // Benefit Highlight Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.s),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              border: Border.all(color: const Color(0xFFBFDBFE)),
            ),
            child: Row(
              children: [
                const Icon(Icons.card_giftcard_rounded, size: 16, color: AppColors.primary),
                const SizedBox(width: AppSpacing.s),
                Expanded(
                  child: Text(
                    benefitText,
                    style: AppTypography.labelSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s),

          Text('Match Criteria: $matchReason', style: AppTypography.bodySmall.copyWith(fontSize: 11)),
          const SizedBox(height: AppSpacing.s),

          // Pre-verified docs row
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: documentsPreVerified.map((doc) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSubtle,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Text('✓ $doc Pre-attached', style: AppTypography.bodySmall.copyWith(fontSize: 10, color: AppColors.textSecondary)),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.m),

          // Apply button
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: 'Apply Directly with 1-Click e-KYC',
              size: AppButtonSize.small,
              leadingIcon: Icons.bolt_rounded,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Starting fast-track application for: $title'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // C-24: Profile Tab
  Widget _buildProfileTab(Map<String, dynamic> citizen, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: isMobile ? 24 : 28,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.person_rounded, color: Colors.white, size: isMobile ? 26 : 32),
            ),
            const SizedBox(width: AppSpacing.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: AppSpacing.s,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(citizen['fullName'], style: isMobile ? AppTypography.h3 : AppTypography.h2),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.successLight,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                          border: Border.all(color: AppColors.successBorder),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.verified_rounded, size: 12, color: AppColors.success),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                'Aadhaar e-KYC Verified',
                                style: AppTypography.labelSmall.copyWith(color: AppColors.success, fontSize: 10),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Resident Citizen ID: ${citizen["id"]} • Enrolled on ${citizen["verifiedOn"]}',
                    style: AppTypography.bodySmall.copyWith(fontSize: isMobile ? 11 : 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.m),
        const Divider(),
        const SizedBox(height: AppSpacing.m),

        Text('Demographic Record (Read-Only Certified)', style: AppTypography.labelBold),
        const SizedBox(height: 4),
        Text(
          'In adherence to UIDAI regulations, certified identity fields can only be modified through the central Aadhaar Seva Kendra.',
          style: AppTypography.bodySmall.copyWith(fontSize: isMobile ? 11 : 12),
        ),
        const SizedBox(height: AppSpacing.m),

        LayoutBuilder(
          builder: (context, constraints) {
            final fieldWidth = constraints.maxWidth < 600
                ? double.infinity
                : (constraints.maxWidth - AppSpacing.m) / 2;

            return Wrap(
              spacing: AppSpacing.m,
              runSpacing: AppSpacing.m,
              children: [
                SizedBox(
                  width: fieldWidth,
                  child: AppTextField(
                    label: 'Masked Aadhaar Number',
                    readOnly: true,
                    controller: TextEditingController(text: citizen['maskedAadhaar']),
                    prefixIcon: const Icon(Icons.credit_card_rounded, size: 18),
                  ),
                ),
                SizedBox(
                  width: fieldWidth,
                  child: AppTextField(
                    label: 'Date of Birth',
                    readOnly: true,
                    controller: TextEditingController(text: citizen['dob']),
                    prefixIcon: const Icon(Icons.calendar_today_rounded, size: 18),
                  ),
                ),
                SizedBox(
                  width: fieldWidth,
                  child: AppTextField(
                    label: 'Registered Mobile Number',
                    readOnly: true,
                    controller: TextEditingController(text: citizen['mobile']),
                    prefixIcon: const Icon(Icons.phone_iphone_rounded, size: 18),
                  ),
                ),
                SizedBox(
                  width: fieldWidth,
                  child: AppTextField(
                    label: 'Official Email ID',
                    readOnly: true,
                    controller: TextEditingController(text: citizen['email']),
                    prefixIcon: const Icon(Icons.email_outlined, size: 18),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: AppSpacing.m),

        AppTextField(
          label: 'Primary Domicile Address',
          readOnly: true,
          controller: TextEditingController(text: citizen['address']),
          prefixIcon: const Icon(Icons.home_outlined, size: 18),
          maxLines: 2,
        ),
      ],
    );
  }

  // C-25: Language Preference
  Widget _buildLanguageTab(AppStateProvider state) {
    final current = state.currentLanguage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Preferred Interface Language', style: AppTypography.h3),
        Text('Updates labels and portal navigation immediately without logging you out.', style: AppTypography.bodySmall),
        const SizedBox(height: AppSpacing.l),
        const Divider(),
        const SizedBox(height: AppSpacing.l),

        _LanguageCard(
          name: 'English',
          localName: 'English (India)',
          isSelected: current == 'English',
          onTap: () => state.setLanguage('English'),
        ),
        const SizedBox(height: AppSpacing.m),
        _LanguageCard(
          name: 'Hindi',
          localName: 'हिन्दी (Hindi)',
          isSelected: current == 'Hindi',
          onTap: () => state.setLanguage('Hindi'),
        ),
        const SizedBox(height: AppSpacing.m),
        _LanguageCard(
          name: 'Gujarati',
          localName: 'ગુજરાતી (Gujarati)',
          isSelected: current == 'Gujarati',
          onTap: () => state.setLanguage('Gujarati'),
        ),
      ],
    );
  }

  // C-26: Consent and Privacy
  Widget _buildConsentTab(Map<String, dynamic> citizen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Data Privacy & Consent Center', style: AppTypography.h3),
        Text('Review active consents granted for digital government services under the Digital Personal Data Protection (DPDP) Act.', style: AppTypography.bodySmall),
        const SizedBox(height: AppSpacing.l),
        const Divider(),
        const SizedBox(height: AppSpacing.l),

        Container(
          padding: const EdgeInsets.all(AppSpacing.m),
          decoration: BoxDecoration(
            color: AppColors.successLight,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: AppColors.successBorder),
          ),
          child: Row(
            children: [
              const Icon(Icons.shield_rounded, color: AppColors.success, size: 24),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Active DigiLocker & UIDAI Authentication Consent: GRANTED', style: AppTypography.labelBold.copyWith(color: AppColors.success)),
                    Text('Granted on 12 Jan 2026. Valid for cross-departmental verification.', style: AppTypography.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.l),

        Text('Consent Audit Logs:', style: AppTypography.labelBold),
        const SizedBox(height: AppSpacing.s),

        _consentLogItem('Revenue Department (Land & Income)', 'Access to land title and income tax records', 'Active'),
        _consentLogItem('Transport Department (Sarathi)', 'Access to driving license and vehicle RC records', 'Active'),
        _consentLogItem('Health & Family Welfare (PM-JAY)', 'Access to NFSA family demographic roster', 'Active'),
      ],
    );
  }

  Widget _consentLogItem(String dept, String scope, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dept, style: AppTypography.labelBold.copyWith(fontSize: 13)),
                Text(scope, style: AppTypography.bodySmall),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.successLight,
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            ),
            child: Text(status, style: AppTypography.labelSmall.copyWith(color: AppColors.success)),
          ),
        ],
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  final String name;
  final String localName;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageCard({
    required this.name,
    required this.localName,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.m),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primarySurface : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: isSelected ? AppColors.primaryAccent : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppTypography.labelBold.copyWith(fontSize: 14)),
                  Text(localName, style: AppTypography.bodySmall),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.s),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: AppColors.primaryAccent)
            else
              const Icon(Icons.radio_button_unchecked_rounded, color: AppColors.textLight),
          ],
        ),
      ),
    );
  }
}
