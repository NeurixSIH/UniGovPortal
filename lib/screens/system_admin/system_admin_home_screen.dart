import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_icons_emblem.dart';
import '../../data/demo_repository.dart';
import '../../models/user_model.dart';

class SystemAdminHomeScreen extends StatefulWidget {
  final Function(String route) onNavigate;

  const SystemAdminHomeScreen({
    super.key,
    required this.onNavigate,
  });

  @override
  State<SystemAdminHomeScreen> createState() => _SystemAdminHomeScreenState();
}

class _SystemAdminHomeScreenState extends State<SystemAdminHomeScreen> {
  final DemoRepository _repo = DemoRepository();

  void _showAddOfficerDialog() {
    final nameCtrl = TextEditingController();
    final idCtrl = TextEditingController(text: 'OFF_REV_${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}');
    final emailCtrl = TextEditingController();
    final mobileCtrl = TextEditingController();
    String dept = 'Revenue Department';
    String role = UserModel.roleDepartmentAdmin;
    String status = UserModel.statusActive;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDlgState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              title: const Row(
                children: [
                  Icon(Icons.person_add, color: AppTheme.primaryBlue),
                  SizedBox(width: 8),
                  Text('Add New Officer', style: TextStyle(fontSize: 16)),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Full Name *')),
                    const SizedBox(height: 10),
                    TextField(controller: idCtrl, decoration: const InputDecoration(labelText: 'User ID *')),
                    const SizedBox(height: 10),
                    TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Official Email *')),
                    const SizedBox(height: 10),
                    TextField(controller: mobileCtrl, decoration: const InputDecoration(labelText: 'Mobile Number *')),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: dept,
                      decoration: const InputDecoration(labelText: 'Department *'),
                      items: const [
                        DropdownMenuItem(value: 'Revenue Department', child: Text('Revenue Department')),
                        DropdownMenuItem(value: 'Municipal Corporation', child: Text('Municipal Corporation')),
                        DropdownMenuItem(value: 'Land Records', child: Text('Land Records')),
                        DropdownMenuItem(value: 'Agriculture Department', child: Text('Agriculture Department')),
                      ],
                      onChanged: (v) => setDlgState(() => dept = v ?? dept),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    if (nameCtrl.text.isNotEmpty) {
                      final newOfficer = UserModel(
                        userId: idCtrl.text,
                        fullName: nameCtrl.text,
                        email: emailCtrl.text.isNotEmpty ? emailCtrl.text : '${nameCtrl.text.toLowerCase().replaceAll(' ', '.')}@maha.gov.in',
                        mobileNumber: mobileCtrl.text.isNotEmpty ? mobileCtrl.text : '+91 98000 00000',
                        dob: Timestamp.now(),
                        gender: 'Male',
                        address: {'city': 'Pune', 'state': 'Maharashtra', 'pincode': '411001'},
                        city: 'Pune',
                        state: 'Maharashtra',
                        pincode: '411001',
                        income: 700000,
                        category: 'General',
                        role: role,
                        status: status,
                        departmentId: dept,
                        createdAt: Timestamp.now(),
                        updatedAt: Timestamp.now(),
                      );
                      _repo.addOfficer(newOfficer);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Officer ${newOfficer.fullName} added successfully.')),
                      );
                    }
                  },
                  child: const Text('Save Officer'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditOfficerDialog(UserModel officer) {
    final nameCtrl = TextEditingController(text: officer.fullName);
    final emailCtrl = TextEditingController(text: officer.email);
    final mobileCtrl = TextEditingController(text: officer.mobileNumber);
    String dept = officer.departmentId.isNotEmpty ? officer.departmentId : 'Revenue Department';
    String status = officer.status;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDlgState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              title: const Row(
                children: [
                  Icon(Icons.edit, color: AppTheme.primaryBlue),
                  SizedBox(width: 8),
                  Text('Update Officer Details', style: TextStyle(fontSize: 16)),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Full Name')),
                    const SizedBox(height: 10),
                    TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Official Email')),
                    const SizedBox(height: 10),
                    TextField(controller: mobileCtrl, decoration: const InputDecoration(labelText: 'Mobile Number')),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: dept,
                      decoration: const InputDecoration(labelText: 'Department'),
                      items: const [
                        DropdownMenuItem(value: 'Revenue Department', child: Text('Revenue Department')),
                        DropdownMenuItem(value: 'Municipal Corporation', child: Text('Municipal Corporation')),
                        DropdownMenuItem(value: 'Land Records', child: Text('Land Records')),
                        DropdownMenuItem(value: 'Agriculture Department', child: Text('Agriculture Department')),
                      ],
                      onChanged: (v) => setDlgState(() => dept = v ?? dept),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Account Active:', style: TextStyle(fontSize: 12)),
                        Switch(
                          value: status == UserModel.statusActive,
                          activeColor: AppTheme.statusSuccess,
                          onChanged: (val) {
                            setDlgState(() => status = val ? UserModel.statusActive : UserModel.statusBlocked);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    final updated = officer.copyWith(
                      fullName: nameCtrl.text,
                      email: emailCtrl.text,
                      mobileNumber: mobileCtrl.text,
                      departmentId: dept,
                      status: status,
                      updatedAt: Timestamp.now(),
                    );
                    _repo.updateOfficer(updated);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Officer ${officer.userId} updated.')),
                    );
                  },
                  child: const Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmDialog(UserModel officer) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: AppTheme.statusRejected),
              SizedBox(width: 8),
              Text('Delete Officer', style: TextStyle(fontSize: 16)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Are you sure you want to delete this officer from the system?',
                style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.statusRejectedLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(officer.fullName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Text('ID: ${officer.userId} • ${officer.departmentId}', style: const TextStyle(fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                _repo.deleteOfficer(officer.userId);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Deleted officer ${officer.fullName}.'),
                    backgroundColor: AppTheme.statusRejected,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.statusRejected),
              child: const Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _repo,
      builder: (context, _) {
        final officers = _repo.officers;
        final activeCount = officers.where((o) => o.status == UserModel.statusActive).length;

        return Scaffold(
          backgroundColor: AppTheme.backgroundLight,
          appBar: AppBar(
            title: const Text('System Admin Console'),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined, size: 22),
                onPressed: () => widget.onNavigate('system_settings'),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // System Summary Metrics
                const Text(
                  'State Interoperability Directory',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _statCard('${officers.length}', 'Total Officers', AppTheme.primaryBlue),
                    const SizedBox(width: 8),
                    _statCard('$activeCount', 'Active Officers', AppTheme.statusSuccess),
                    const SizedBox(width: 8),
                    _statCard('4', 'Departments', const Color(0xFF8E24AA)),
                    const SizedBox(width: 8),
                    _statCard('6', 'Active Services', AppTheme.tealAccent),
                  ],
                ),

                const SizedBox(height: 20),

                // Officer Management Header & Add Action
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Officer Management',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: _showAddOfficerDialog,
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Add Officer', style: TextStyle(fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        minimumSize: const Size(110, 36),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Officers List
                ...officers.map((officer) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.borderLight),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: DepartmentHelper.getColor(officer.departmentId).withAlpha(20),
                          child: Icon(
                            DepartmentHelper.getIcon(officer.departmentId),
                            size: 18,
                            color: DepartmentHelper.getColor(officer.departmentId),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                officer.fullName,
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'ID: ${officer.userId} • ${officer.departmentId}',
                                style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                              ),
                              Text(
                                officer.email,
                                style: const TextStyle(fontSize: 10, color: AppTheme.textMuted),
                              ),
                            ],
                          ),
                        ),
                        StatusBadgeWidget(status: officer.status, compact: true),
                        PopupMenuButton<String>(
                          onSelected: (val) {
                            if (val == 'edit') _showEditOfficerDialog(officer);
                            if (val == 'delete') _showDeleteConfirmDialog(officer);
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit, size: 16), SizedBox(width: 8), Text('Edit')])),
                            const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete, size: 16, color: Colors.red), SizedBox(width: 8), Text('Delete', style: TextStyle(color: Colors.red))])),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _statCard(String count, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderLight),
        ),
        child: Column(
          children: [
            Text(count, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 2),
            Text(label, textAlign: TextAlign.center, maxLines: 2, style: const TextStyle(fontSize: 9, color: AppTheme.textSecondary)),
          ],
        ),
      ),
    );
  }
}
