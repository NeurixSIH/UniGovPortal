import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_icons_emblem.dart';
import '../../data/demo_repository.dart';

class ServiceDetailsEligibilityScreen extends StatelessWidget {
  final String serviceId;
  final VoidCallback onContinue;
  final VoidCallback onBack;

  const ServiceDetailsEligibilityScreen({
    super.key,
    required this.serviceId,
    required this.onContinue,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final repo = DemoRepository();
    final service = repo.services.firstWhere(
      (s) => s.serviceId == serviceId,
      orElse: () => repo.services.first,
    );
    final user = repo.citizenUser;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: onBack,
        ),
        title: const Text('Service Details & Eligibility'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Title & Department Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: DepartmentHelper.getColor(service.departmentId).withAlpha(25),
                        child: Icon(
                          DepartmentHelper.getIcon(service.departmentId),
                          color: DepartmentHelper.getColor(service.departmentId),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              service.serviceName,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              service.departmentId,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: DepartmentHelper.getColor(service.departmentId),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlueLight.withAlpha(20),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          service.fee == 0 ? 'Fee: ₹0' : 'Fee: ₹${service.fee}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    service.description,
                    style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.4),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _badge(Icons.speed, 'Turnaround: ${service.processingTime}'),
                      const SizedBox(width: 10),
                      _badge(Icons.devices, 'Type: ${service.applicationType}'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Large Green Auto-Eligibility Evaluation Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE8F5E9), Color(0xFFF1F8E9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.statusSuccess.withAlpha(120), width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.statusSuccess.withAlpha(20),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppTheme.statusSuccess,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check, color: Colors.white, size: 18),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'You are Eligible!',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.statusSuccess,
                              ),
                            ),
                            Text(
                              'Auto-evaluated from Krisha Patel\'s verified profile',
                              style: TextStyle(fontSize: 11, color: Color(0xFF2E7D32)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          '100% Match',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.statusSuccess),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Divider(height: 1, color: Color(0xFFC8E6C9)),
                  const SizedBox(height: 10),

                  _checkRow('Income requirement satisfied', 'Declared ₹2,50,000 is under ₹8,00,000 threshold'),
                  _checkRow('Category requirement satisfied', '${user.category} category is eligible for concession'),
                  _checkRow('Address verified', 'Verified Maharashtra domicile at ${user.city}'),
                  _checkRow('Land ownership requirement satisfied', '${user.landOwnership} satisfies smallholder guidelines'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Required Documents Checklist
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.folder_shared_outlined, size: 18, color: AppTheme.primaryBlue),
                      SizedBox(width: 8),
                      Text(
                        'Required Documents (Auto-Linked)',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _docRow('Aadhaar Card', 'Auto-fetched from DigiLocker (Verified)', true),
                  _docRow('Income Proof', 'Bank statement / Self-declaration linked', true),
                  _docRow('Address Proof', 'MSEDCL Electricity bill verified', true),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlueLight.withAlpha(20),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.auto_awesome, color: AppTheme.primaryBlue, size: 16),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'No document upload needed! All 3 verified documents will be automatically attached from your Citizen Vault.',
                            style: TextStyle(fontSize: 11, color: AppTheme.primaryBlueDark, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Continue Application Button
            ElevatedButton.icon(
              onPressed: onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                minimumSize: const Size.fromHeight(50),
              ),
              icon: const Icon(Icons.arrow_forward, size: 18),
              label: const Text(
                'Continue Application',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _badge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppTheme.textSecondary),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }

  Widget _checkRow(String title, String detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, size: 16, color: AppTheme.statusSuccess),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                Text(detail, style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _docRow(String title, String status, bool verified) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(verified ? Icons.check_circle_outline : Icons.circle_outlined, size: 16, color: AppTheme.statusSuccess),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                Text(status, style: const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
              ],
            ),
          ),
          const StatusBadgeWidget(status: 'verified', compact: true),
        ],
      ),
    );
  }
}
