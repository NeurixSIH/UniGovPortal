import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_icons_emblem.dart';
import '../../data/demo_repository.dart';
import '../../models/document_model.dart';

class MyDocumentsScreen extends StatefulWidget {
  final VoidCallback onBack;

  const MyDocumentsScreen({
    super.key,
    required this.onBack,
  });

  @override
  State<MyDocumentsScreen> createState() => _MyDocumentsScreenState();
}

class _MyDocumentsScreenState extends State<MyDocumentsScreen> {
  final DemoRepository _repo = DemoRepository();
  String _searchQuery = '';
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Verified', 'Pending', 'Rejected'];

  void _showUploadDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: const Row(
            children: [
              Icon(Icons.upload_file, color: AppTheme.primaryBlue),
              SizedBox(width: 8),
              Text('Upload New Document', style: TextStyle(fontSize: 16)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Upload certificate or document to your digital locker for reuse across all government portals.',
                style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Document Type'),
                items: const [
                  DropdownMenuItem(value: 'Caste Certificate', child: Text('Caste Certificate')),
                  DropdownMenuItem(value: 'Domicile Certificate', child: Text('Domicile Certificate')),
                  DropdownMenuItem(value: 'Non-Creamy Layer Certificate', child: Text('Non-Creamy Layer Certificate')),
                  DropdownMenuItem(value: 'Bank Passbook', child: Text('Bank Passbook')),
                ],
                onChanged: (_) {},
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.borderLight),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.cloud_upload_outlined, size: 36, color: AppTheme.primaryBlue),
                    SizedBox(height: 6),
                    Text('Tap to select file (PDF/JPG up to 5MB)', style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                  ],
                ),
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
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Document submitted for automated verification.')),
                );
              },
              child: const Text('Upload & Verify'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _repo.documents.where((d) {
      final matchesSearch = d.documentType.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          d.documentNumber.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          d.issuedBy.toLowerCase().contains(_searchQuery.toLowerCase());

      if (_selectedFilter == 'All') return matchesSearch;
      if (_selectedFilter == 'Verified') return matchesSearch && d.status == DocumentModel.statusVerified;
      if (_selectedFilter == 'Pending') return matchesSearch && d.status == DocumentModel.statusPending;
      if (_selectedFilter == 'Rejected') return matchesSearch && d.status == DocumentModel.statusRejected;
      return matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: widget.onBack,
        ),
        title: const Text('My Documents'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, size: 22),
            tooltip: 'Upload Document',
            onPressed: _showUploadDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter Bar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            color: Colors.white,
            child: Column(
              children: [
                TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Search documents...',
                    prefixIcon: const Icon(Icons.search, size: 20, color: AppTheme.textSecondary),
                    filled: true,
                    fillColor: const Color(0xFFF1F5F9),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: _filters.map((f) {
                    final isSelected = _selectedFilter == f;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(f),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) setState(() => _selectedFilter = f);
                        },
                        selectedColor: AppTheme.primaryBlue,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppTheme.textPrimary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // Reusability Callout Banner
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlueLight.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.primaryBlue.withAlpha(60)),
            ),
            child: const Row(
              children: [
                Icon(Icons.autorenew, color: AppTheme.primaryBlue, size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Verified documents can be reused for eligible applications without re-uploading.',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryBlueDark,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Documents List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final doc = filtered[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.borderLight),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(5),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryBlueLight.withAlpha(20),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.description_outlined, color: AppTheme.primaryBlue, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  doc.documentType,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Doc No: ${doc.documentNumber}',
                                  style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                                ),
                                Text(
                                  'Issuer: ${doc.issuedBy}',
                                  style: const TextStyle(fontSize: 10, color: AppTheme.textMuted),
                                ),
                              ],
                            ),
                          ),
                          StatusBadgeWidget(status: doc.status, compact: true),
                        ],
                      ),
                      if (doc.rejectionReason != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.statusRejectedLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.info, size: 14, color: AppTheme.statusRejected),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Reason: ${doc.rejectionReason}',
                                  style: const TextStyle(fontSize: 10, color: AppTheme.statusRejected, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Uploaded: 12 Jan 2025',
                            style: TextStyle(fontSize: 10, color: AppTheme.textMuted),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.visibility_outlined, size: 18, color: AppTheme.primaryBlue),
                                constraints: const BoxConstraints(),
                                padding: const EdgeInsets.all(4),
                                onPressed: () {},
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.file_download_outlined, size: 18, color: AppTheme.primaryBlue),
                                constraints: const BoxConstraints(),
                                padding: const EdgeInsets.all(4),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Upload New Document Floating/Bottom Action
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: _showUploadDialog,
              icon: const Icon(Icons.cloud_upload_outlined, size: 18),
              label: const Text('Upload New Document'),
            ),
          ),
        ],
      ),
    );
  }
}
