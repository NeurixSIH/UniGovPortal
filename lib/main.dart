import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'models/user_model.dart';
import 'services/user_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const UniGovApp());
}

class UniGovApp extends StatelessWidget {
  const UniGovApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UniGov Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const UsersListScreen(),
    );
  }
}

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  final UserService _userService = UserService();
  String _selectedRoleFilter = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UniGov - Users Collection'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            tooltip: 'Add Sample User',
            onPressed: () => _addSampleUser(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('All Roles'),
                    selected: _selectedRoleFilter == 'all',
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedRoleFilter = 'all');
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Citizen'),
                    selected: _selectedRoleFilter == UserModel.roleCitizen,
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedRoleFilter = UserModel.roleCitizen);
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Dept Admin'),
                    selected: _selectedRoleFilter == UserModel.roleDepartmentAdmin,
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedRoleFilter = UserModel.roleDepartmentAdmin);
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('System Admin'),
                    selected: _selectedRoleFilter == UserModel.roleSystemAdmin,
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedRoleFilter = UserModel.roleSystemAdmin);
                    },
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          // Users List
          Expanded(
            child: StreamBuilder<List<UserModel>>(
              stream: _selectedRoleFilter == 'all'
                  ? _userService.streamAllUsers()
                  : _userService.streamUsersByRole(_selectedRoleFilter),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('Error loading users: ${snapshot.error}'),
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final users = snapshot.data ?? [];
                if (users.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.people_outline, size: 64, color: Colors.grey),
                        const SizedBox(height: 12),
                        const Text(
                          'No users in Firestore collection yet',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text('Create Sample User'),
                          onPressed: () => _addSampleUser(context),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getRoleColor(user.role),
                          child: Text(
                            user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : 'U',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(
                          user.fullName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${user.email} • ${user.mobileNumber}'),
                            Text('Role: ${user.role} | Status: ${user.status}'),
                            Text('City: ${user.city}, ${user.state} (${user.pincode})'),
                            Text('Income: ₹${user.income} | Category: ${user.category}'),
                          ],
                        ),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                          onPressed: () async {
                            await _userService.deleteUser(user.userId);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Deleted user ${user.fullName}')),
                              );
                            }
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case UserModel.roleSystemAdmin:
        return Colors.deepPurple;
      case UserModel.roleDepartmentAdmin:
        return Colors.indigo;
      case UserModel.roleCitizen:
      default:
        return Colors.teal;
    }
  }

  Future<void> _addSampleUser(BuildContext context) async {
    final newId = 'USR_${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    final sampleUser = UserModel(
      userId: newId,
      fullName: 'Priya Patel',
      email: 'priya.patel@example.com',
      mobileNumber: '+919876543211',
      dob: Timestamp.fromDate(DateTime(1998, 8, 20)),
      gender: 'Female',
      address: {
        'line1': 'B-304, Green City',
        'city': 'Surat',
        'state': 'Gujarat',
        'pincode': '395007',
      },
      city: 'Surat',
      state: 'Gujarat',
      pincode: '395007',
      income: 500000,
      category: 'OBC',
      role: UserModel.roleCitizen,
      status: UserModel.statusActive,
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
    );

    try {
      await _userService.addUser(sampleUser);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Added user: ${sampleUser.fullName} ($newId)')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding user: $e')),
        );
      }
    }
  }
}
