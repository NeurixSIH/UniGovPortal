import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/demo_repository.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback onEditProfile;
  final VoidCallback onBack;

  const ProfileScreen({
    super.key,
    required this.onEditProfile,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final repo = DemoRepository();
    final user = repo.citizenUser;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: onBack,
        ),
        title: const Text('My Citizen Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 20),
            onPressed: onEditProfile,
            tooltip: 'Edit Profile',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Card Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryBlue.withAlpha(60),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.white,
                        child: Text(
                          'KP',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppTheme.indiaGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.verified, size: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user.fullName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(40),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Citizen ID: ${user.citizenId}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Completion Progress
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(40),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Profile Verification Score',
                              style: TextStyle(color: Colors.white70, fontSize: 11),
                            ),
                            Text(
                              '80% Completed',
                              style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: const LinearProgressIndicator(
                            value: 0.80,
                            minHeight: 6,
                            backgroundColor: Colors.white24,
                            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.saffron),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Personal Information Section
            _buildSection(
              title: 'Personal Information',
              icon: Icons.person_outline,
              items: [
                _infoRow(Icons.badge_outlined, 'Full Name', user.fullName),
                _infoRow(Icons.cake_outlined, 'Date of Birth', '14 May 1996'),
                _infoRow(Icons.transgender_outlined, 'Gender', user.gender),
                _infoRow(Icons.phone_outlined, 'Mobile Number', user.mobileNumber),
                _infoRow(Icons.email_outlined, 'Email Address', user.email),
              ],
            ),

            const SizedBox(height: 14),

            // Address Information Section
            _buildSection(
              title: 'Residential Address',
              icon: Icons.home_outlined,
              items: [
                _infoRow(Icons.location_on_outlined, 'Address Line', user.address['line1'] ?? 'Flat 402, Shivam Apts'),
                _infoRow(Icons.location_city_outlined, 'City / District', user.city),
                _infoRow(Icons.map_outlined, 'State', user.state),
                _infoRow(Icons.pin_drop_outlined, 'Pincode', user.pincode),
              ],
            ),

            const SizedBox(height: 14),

            // Socio-Economic Details Section
            _buildSection(
              title: 'Socio-Economic & Land Details',
              icon: Icons.account_balance_wallet_outlined,
              items: [
                _infoRow(Icons.currency_rupee, 'Income Bracket', user.incomeBracket.isNotEmpty ? user.incomeBracket : '₹1,50,000 - ₹3,00,000'),
                _infoRow(Icons.category_outlined, 'Category / Caste', user.category),
                _infoRow(Icons.landscape_outlined, 'Land Ownership', user.landOwnership),
              ],
            ),

            const SizedBox(height: 20),

            // Edit Profile Button
            ElevatedButton.icon(
              onPressed: onEditProfile,
              icon: const Icon(Icons.edit, size: 18),
              label: const Text('Edit / Update Personal Details'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> items,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Icon(icon, size: 18, color: AppTheme.primaryBlue),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppTheme.dividerLight),
          ...items,
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppTheme.textMuted),
          const SizedBox(width: 12),
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
