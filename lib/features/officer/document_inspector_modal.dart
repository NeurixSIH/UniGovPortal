import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/models/application_model.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';

class DocumentInspectorModal extends StatefulWidget {
  final UploadedDocument document;
  final String applicationId;
  final Function(bool isVerified, String? comment) onVerdict;

  const DocumentInspectorModal({
    super.key,
    required this.document,
    required this.applicationId,
    required this.onVerdict,
  });

  static Future<void> show({
    required BuildContext context,
    required UploadedDocument document,
    required String applicationId,
    required Function(bool isVerified, String? comment) onVerdict,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => DocumentInspectorModal(
        document: document,
        applicationId: applicationId,
        onVerdict: onVerdict,
      ),
    );
  }

  @override
  State<DocumentInspectorModal> createState() => _DocumentInspectorModalState();
}

class _DocumentInspectorModalState extends State<DocumentInspectorModal> {
  double _zoom = 1.0;
  int _rotationQuarter = 0; // 0, 1, 2, 3
  final _commentCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.document.officerComment != null) {
      _commentCtrl.text = widget.document.officerComment!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
      insetPadding: const EdgeInsets.all(AppSpacing.l),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 960, maxHeight: 720),
        child: Column(
          children: [
            // Top Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: AppSpacing.m),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.document_scanner_rounded, color: AppColors.primaryAccent),
                  const SizedBox(width: AppSpacing.m),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.document.name, style: AppTypography.h3),
                        Text(
                          '${widget.document.fileName} • ${(widget.document.fileSizeBytes / 1024).toStringAsFixed(0)} KB • Uploaded on ${DateFormat("dd/MM/yyyy HH:mm").format(widget.document.uploadedAt)}',
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                  ),

                  // Zoom & Rotate Controls
                  IconButton(
                    icon: const Icon(Icons.zoom_out_rounded),
                    tooltip: 'Zoom Out',
                    onPressed: () => setState(() => _zoom = (_zoom > 0.6 ? _zoom - 0.2 : _zoom)),
                  ),
                  Text('${(_zoom * 100).toInt()}%', style: AppTypography.labelSmall),
                  IconButton(
                    icon: const Icon(Icons.zoom_in_rounded),
                    tooltip: 'Zoom In',
                    onPressed: () => setState(() => _zoom = (_zoom < 2.0 ? _zoom + 0.2 : _zoom)),
                  ),
                  const SizedBox(width: AppSpacing.s),
                  IconButton(
                    icon: const Icon(Icons.rotate_right_rounded),
                    tooltip: 'Rotate 90°',
                    onPressed: () => setState(() => _rotationQuarter = (_rotationQuarter + 1) % 4),
                  ),
                  IconButton(
                    icon: const Icon(Icons.download_rounded),
                    tooltip: 'Download File',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Downloading ${widget.document.fileName}...')),
                      );
                    },
                  ),
                  const SizedBox(width: AppSpacing.s),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Main Split Inspector: Document Preview Canvas & Verification Panel
            Expanded(
              child: Row(
                children: [
                  // Left Preview Sandbox Canvas
                  Expanded(
                    flex: 6,
                    child: Container(
                      color: const Color(0xFF0F172A),
                      child: Center(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            child: RotatedBox(
                              quarterTurns: _rotationQuarter,
                              child: Transform.scale(
                                scale: _zoom,
                                child: Container(
                                  width: 460,
                                  height: 600,
                                  margin: const EdgeInsets.all(32),
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: const [
                                      BoxShadow(color: Color(0x3D000000), blurRadius: 20, offset: Offset(0, 8)),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Mock Document Header
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Icon(Icons.account_balance_rounded, size: 28, color: AppColors.primary),
                                          Text('OFFICIAL ATTESTED COPY', style: AppTypography.code.copyWith(fontSize: 10, color: AppColors.textMuted)),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Container(height: 1.5, color: const Color(0xFFE2E8F0)),
                                      const SizedBox(height: 16),

                                      Text(widget.document.name.toUpperCase(), style: AppTypography.labelBold.copyWith(fontSize: 14)),
                                      const SizedBox(height: 8),
                                      Text('Document Reference ID: ${widget.applicationId}/${widget.document.docId}', style: AppTypography.code.copyWith(fontSize: 11)),
                                      const SizedBox(height: 16),

                                      // Simulated official document lines
                                      Container(height: 12, width: 380, color: const Color(0xFFF1F5F9)),
                                      const SizedBox(height: 8),
                                      Container(height: 12, width: 320, color: const Color(0xFFF1F5F9)),
                                      const SizedBox(height: 8),
                                      Container(height: 12, width: 400, color: const Color(0xFFF1F5F9)),
                                      const SizedBox(height: 8),
                                      Container(height: 12, width: 260, color: const Color(0xFFF1F5F9)),
                                      const Spacer(),

                                      // Official stamp simulation
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              border: Border.all(color: const Color(0xFF93C5FD), width: 1.5),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text('EMBLEM SEAL\nGOVT OF GUJARAT', style: AppTypography.code.copyWith(fontSize: 9, color: const Color(0xFF1D4ED8)), textAlign: TextAlign.center),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              border: Border.all(color: const Color(0xFF059669), width: 1.5),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text('GAZETTED OFFICER\nATTESTED RECORD', style: AppTypography.code.copyWith(fontSize: 9, color: const Color(0xFF059669)), textAlign: TextAlign.center),
                                          ),
                                        ],
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
                  ),

                  // Right Verification Panel
                  Container(
                    width: 320,
                    padding: const EdgeInsets.all(AppSpacing.l),
                    decoration: const BoxDecoration(
                      border: Border(left: BorderSide(color: AppColors.border)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Officer Adjudication', style: AppTypography.h3),
                        const SizedBox(height: 4),
                        Text('Scrutinize the document quality, legibility, and authenticity.', style: AppTypography.bodySmall),
                        const SizedBox(height: AppSpacing.l),

                        AppTextField(
                          label: 'Verification Remarks / Deficiency Note',
                          hint: 'Enter remarks if flagging for correction...',
                          controller: _commentCtrl,
                          maxLines: 4,
                        ),
                        const Spacer(),

                        // Mark Invalid or Verify Buttons
                        AppButton(
                          label: 'Mark as Verified & Authentic',
                          variant: AppButtonVariant.success,
                          isFullWidth: true,
                          leadingIcon: Icons.check_circle_rounded,
                          onPressed: () {
                            widget.onVerdict(true, _commentCtrl.text.trim());
                            Navigator.of(context).pop();
                          },
                        ),
                        const SizedBox(height: AppSpacing.m),
                        AppButton(
                          label: 'Flag as Deficient / Illegible',
                          variant: AppButtonVariant.danger,
                          isFullWidth: true,
                          leadingIcon: Icons.warning_amber_rounded,
                          onPressed: () {
                            widget.onVerdict(false, _commentCtrl.text.trim());
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
