import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_icons_emblem.dart';
import '../../data/demo_repository.dart';
import '../../models/application_model.dart';

class ApplicationReviewScreen extends StatefulWidget {
  final String applicationId;
  final VoidCallback onBack;

  const ApplicationReviewScreen({
    super.key,
    this.applicationId = 'APP20260904',
    required this.onBack,
  });

  @override
  State<ApplicationReviewScreen> createState() => _ApplicationReviewScreenState();
}

class _ApplicationReviewScreenState extends State<ApplicationReviewScreen> {
  final DemoRepository _repo = DemoRepository();
  final TextEditingController _remarksController = TextEditingController(
    text: 'All eligibility criteria satisfied and verified via Interoperability Hub.',
  );

  @override
  void dispose() {
    _remarksController.dispose();
    super.dispose();
  }

  void _confirmAction(String newStatus, String title, Color color, IconData icon) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Row(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 16)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to change the status of ${widget.applicationId} to $newStatus?',
                style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 12),
              const Text('Officer Endorsement Remarks:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                _remarksController.text.trim().isNotEmpty
                    ? _remarksController.text.trim()
                    : 'No remarks entered.',
                style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _repo.reviewApplication(
                  widget.applicationId,
                  newStatus,
                  _remarksController.text.trim(),
                  _repo.deptOfficer.fullName,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Application ${widget.applicationId} marked as $newStatus.'),
                    backgroundColor: color,
                  ),
                );

                widget.onBack();
              },
              style: ElevatedButton.styleFrom(backgroundColor: color),
              child: const Text('Confirm', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = _repo.applications.firstWhere(
      (a) => a.applicationId == widget.applicationId,
      orElse: () => _repo.applications.first,
    );
    final user = _repo.citizenUser;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: widget.onBack,
        ),
        title: const Text('Application Review'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.borderLight),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        app.applicationId,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Service: Income Certificate',
                        style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                  StatusBadgeWidget(status: app.status),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Section 1: Citizen Information (Pulled from Interop Hub)
            _buildSection(
              title: '1. Citizen Info (Interoperability Hub)',
              icon: Icons.hub_outlined,
              badge: 'Verified Hub Data',
              badgeColor: AppTheme.primaryBlue,
              children: [
                _row('Applicant Name', user.fullName),
                _row('Citizen ID', user.citizenId),
                _row('Age / Gender', '29 Yrs / ${user.gender}'),
                _row('Address Line', user.address['line1']),
                _row('City / State', '${user.city}, ${user.state}'),
                _row('Pincode', user.pincode),
                _row('Aadhaar Linkage', 'Active (Biometrically Seeded)'),
              ],
            ),

            const SizedBox(height: 14),

            // Section 2: Application Details (User-Submitted)
            _buildSection(
              title: '2. Application Details (User Declared)',
              icon: Icons.assignment_outlined,
              badge: 'Self-Declared',
              badgeColor: AppTheme.tealAccent,
              children: [
                _row('Annual Income', '₹2,50,000 / annum'),
                _row('Purpose', 'Education Fee Concession & Scholarship'),
                _row('Financial Year', '2025-2026'),
                _row('Family Members', '3 Members'),
              ],
            ),

            const SizedBox(height: 14),

            // Section 3: Submitted Documents Checklist
            _buildSection(
              title: '3. Submitted Documents Checklist',
              icon: Icons.folder_shared_outlined,
              children: [
                _docCheckTile('Aadhaar Card', 'UIDAI Electronic Record', 'Verified', true),
                _docCheckTile('Income Proof', 'Bank statement via Interop Gateway', 'Verified', true),
                _docCheckTile('Address Proof', 'MSEDCL Bill #889210452', 'Verified', true),
              ],
            ),

            const SizedBox(height: 14),

            // Section 4: Eligibility Engine Result
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.statusSuccessLight,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.statusSuccess.withAlpha(80)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle, color: AppTheme.statusSuccess, size: 24),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Eligibility Engine: ✓ ELIGIBLE',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.statusSuccess),
                        ),
                        Text(
                          'Annual income is under ₹8.00 Lakhs ceiling. Domicile criteria met.',
                          style: TextStyle(fontSize: 11, color: Color(0xFF2E7D32)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Section 5: Department Remarks
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Department Officer Remarks *',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _remarksController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      hintText: 'Enter endorsement or requirement remarks...',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Action Buttons: Approve, Request Documents, Reject
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _confirmAction(
                      ApplicationModel.statusApproved,
                      'Approve Application',
                      AppTheme.statusSuccess,
                      Icons.check_circle_outline,
                    ),
                    icon: const Icon(Icons.check, size: 16),
                    label: const Text('Approve', style: TextStyle(fontSize: 13)),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.statusSuccess),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _confirmAction(
                      ApplicationModel.statusDocumentsRequired,
                      'Request Documents',
                      const Color(0xFF8E24AA),
                      Icons.file_present_outlined,
                    ),
                    icon: const Icon(Icons.upload, size: 16),
                    label: const Text('Request Docs', style: TextStyle(fontSize: 12)),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8E24AA)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _confirmAction(
                      ApplicationModel.statusRejected,
                      'Reject Application',
                      AppTheme.statusRejected,
                      Icons.cancel_outlined,
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.statusRejected,
                      side: const BorderSide(color: AppTheme.statusRejected),
                    ),
                    child: const Text('Reject', style: TextStyle(fontSize: 13)),
                  ),
                ),
              ],
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
    String? badge,
    Color? badgeColor,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 18, color: AppTheme.primaryBlue),
                  const SizedBox(width: 8),
                  Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                ],
              ),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: (badgeColor ?? AppTheme.primaryBlue).withAlpha(20),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    badge,
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: badgeColor ?? AppTheme.primaryBlue),
                  ),
                ),
            ],
          ),
          const Divider(height: 16, color: AppTheme.dividerLight),
          ...children,
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
          ),
        ],
      ),
    );
  }

  Widget _docCheckTile(String name, String source, String status, bool verified) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: AppTheme.statusSuccess, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                Text(source, style: const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
              ],
            ),
          ),
          StatusBadgeWidget(status: status, compact: true),
        ],
      ),
    );
  }
}
