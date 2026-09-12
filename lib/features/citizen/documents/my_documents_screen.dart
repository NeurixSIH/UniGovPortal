import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/models/application_model.dart';
import '../../../core/state/app_state_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/status_badge.dart';

class MyDocumentsScreen extends StatefulWidget {
  final VoidCallback? onUploadNew;

  const MyDocumentsScreen({
    super.key,
    this.onUploadNew,
  });

  @override
  State<MyDocumentsScreen> createState() => _MyDocumentsScreenState();
}

class _MyDocumentsScreenState extends State<MyDocumentsScreen> {
  String _filterStatus = 'ALL'; // ALL, VERIFIED, PENDING, REJECTED
  String _searchQuery = '';
  bool _isSimulatingUpload = false;
  String? _uploadSuccessMessage;

  void _handleSimulatedUpload(String docName) {
    setState(() {
      _isSimulatingUpload = true;
      _uploadSuccessMessage = null;
    });

    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() {
        _isSimulatingUpload = false;
        _uploadSuccessMessage = '$docName: ✓ Uploaded successfully';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$docName uploaded successfully to Digilocker registry'),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 2),
        ),
      );
    });
  }

  void _previewDocument(BuildContext context, UploadedDocument doc) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
        title: Row(
          children: [
            const Icon(Icons.description_rounded, color: AppColors.primary),
            const SizedBox(width: AppSpacing.s),
            Expanded(child: Text(doc.name, style: AppTypography.h3, overflow: TextOverflow.ellipsis)),
          ],
        ),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Document Reference: ${doc.docId}', style: AppTypography.bodySmall),
              const SizedBox(height: AppSpacing.m),
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surfaceSubtle,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(color: AppColors.border),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.picture_as_pdf_rounded, size: 48, color: AppColors.danger),
                      const SizedBox(height: AppSpacing.s),
                      Text('PDF Document Preview', style: AppTypography.labelBold),
                      Text('Authenticated via DigiLocker URI', style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.m),
              Text(
                'Status: ${doc.isVerified ? "Verified by Municipal Officer" : "Pending Verification"}',
                style: AppTypography.bodySmall.copyWith(
                  color: doc.isVerified ? AppColors.success : AppColors.warning,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        actions: [
          AppButton(
            label: 'Close',
            variant: AppButtonVariant.outline,
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final isMobile = MediaQuery.of(context).size.width < 700;

    // Collect all unique documents across applications
    final Map<String, UploadedDocument> docsMap = {};
    for (final app in state.applications) {
      for (final d in app.documents) {
        if (!docsMap.containsKey(d.docId)) {
          docsMap[d.docId] = d;
        }
      }
    }

    final allDocs = docsMap.values.toList();
    final filtered = allDocs.where((doc) {
      if (_filterStatus == 'VERIFIED' && !doc.isVerified) return false;
      if (_filterStatus == 'PENDING' && doc.isVerified) return false;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        return doc.name.toLowerCase().contains(q) || doc.docId.toLowerCase().contains(q);
      }
      return true;
    }).toList();

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? AppSpacing.m : AppSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header summary card
          AppCard(
            color: AppColors.primary,
            border: BorderSide.none,
            padding: const EdgeInsets.all(AppSpacing.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.s),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.folder_shared_rounded, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: AppSpacing.m),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'My Verified Documents',
                            style: AppTypography.h2.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Text(
                            'Digital Locker integration with Maharashtra State Data Exchange',
                            style: AppTypography.bodySmall.copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.m),
                Row(
                  children: [
                    _buildStatPill('Total', '${allDocs.length}', Colors.white),
                    const SizedBox(width: AppSpacing.s),
                    _buildStatPill('Verified', '${allDocs.where((d) => d.isVerified).length}', const Color(0xFF86EFAC)),
                    const SizedBox(width: AppSpacing.s),
                    _buildStatPill('Pending', '${allDocs.where((d) => !d.isVerified).length}', const Color(0xFFFDE68A)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.m),

          if (_isSimulatingUpload) ...[
            Container(
              padding: const EdgeInsets.all(AppSpacing.m),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(color: AppColors.infoBorder),
              ),
              child: Row(
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  ),
                  const SizedBox(width: AppSpacing.m),
                  Text('Uploading document to secure server...', style: AppTypography.labelBold),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.m),
          ],

          if (_uploadSuccessMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(AppSpacing.m),
              decoration: BoxDecoration(
                color: AppColors.successLight,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(color: AppColors.successBorder),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 20),
                  const SizedBox(width: AppSpacing.s),
                  Expanded(
                    child: Text(_uploadSuccessMessage!, style: AppTypography.labelBold.copyWith(color: AppColors.success)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.m),
          ],

          // Search & Filter controls
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Column(
              children: [
                TextField(
                  onChanged: (v) => setState(() => _searchQuery = v),
                  style: AppTypography.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Search documents by title or reference ID...',
                    prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppColors.textMuted),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
                const SizedBox(height: AppSpacing.s),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All Documents', 'ALL'),
                      const SizedBox(width: AppSpacing.s),
                      _buildFilterChip('Verified', 'VERIFIED'),
                      const SizedBox(width: AppSpacing.s),
                      _buildFilterChip('Pending Verification', 'PENDING'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.m),

          // Document cards
          if (filtered.isEmpty)
            AppCard(
              padding: const EdgeInsets.all(AppSpacing.xxxl),
              child: Center(
                child: Column(
                  children: [
                    const Icon(Icons.description_outlined, size: 48, color: AppColors.textLight),
                    const SizedBox(height: AppSpacing.m),
                    Text('No documents found', style: AppTypography.h3),
                    const SizedBox(height: AppSpacing.xs),
                    Text('Upload required documents for pending applications', style: AppTypography.bodySmall),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.s),
              itemBuilder: (context, idx) {
                final doc = filtered[idx];
                return _buildDocumentCard(context, doc, isMobile);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildStatPill(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$label: ', style: const TextStyle(color: Colors.white70, fontSize: 11)),
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String key) {
    final isSelected = _filterStatus == key;
    return ChoiceChip(
      label: Text(label, style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : AppColors.textPrimary)),
      selected: isSelected,
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.surfaceSubtle,
      onSelected: (_) => setState(() => _filterStatus = key),
    );
  }

  Widget _buildDocumentCard(BuildContext context, UploadedDocument doc, bool isMobile) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: doc.isVerified ? AppColors.successLight : AppColors.warningLight,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Icon(
                  doc.isVerified ? Icons.verified_user_rounded : Icons.pending_actions_rounded,
                  color: doc.isVerified ? AppColors.success : AppColors.warning,
                  size: 22,
                ),
              ),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(doc.name, style: AppTypography.labelBold.copyWith(fontSize: 14)),
                    const SizedBox(height: 2),
                    Text('Doc ID: ${doc.docId}', style: AppTypography.code.copyWith(fontSize: 11, color: AppColors.textMuted)),
                    Text(
                      'Uploaded: ${DateFormat("dd MMM yyyy").format(doc.uploadedAt)}',
                      style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              doc.isVerified ? StatusBadge.verified(isCompact: true) : StatusBadge.pending(isCompact: true),
            ],
          ),
          const SizedBox(height: AppSpacing.m),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.s),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.visibility_rounded, size: 16),
                label: const Text('Preview', style: TextStyle(fontSize: 12)),
                onPressed: () => _previewDocument(context, doc),
              ),
              const SizedBox(width: AppSpacing.s),
              OutlinedButton.icon(
                icon: const Icon(Icons.sync_rounded, size: 16),
                label: const Text('Replace', style: TextStyle(fontSize: 12)),
                onPressed: () => _handleSimulatedUpload(doc.name),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
