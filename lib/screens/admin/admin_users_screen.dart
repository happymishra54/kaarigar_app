import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/admin_user_provider.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() =>
      _AdminUsersScreenState();
}

class _AdminUsersScreenState
    extends State<AdminUsersScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<AdminUserProvider>().loadUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        context.watch<AdminUserProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Users"),
      ),
      body: provider.loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () =>
                  provider.loadUsers(),
              child: ListView.builder(
                itemCount: provider.users.length,
                itemBuilder: (_, index) {
  final user = provider.users[index];

  return Card(
    elevation: 3,
    margin: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 8,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              CircleAvatar(
                radius: 24,
                child: Text(
                  user.name[0].toUpperCase(),
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      user.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(user.phone),

                    // if (user.email.isNotEmpty)
                    //   Text(user.email),

                    const SizedBox(height: 4),

                    Chip(
                      label: Text(user.role.toUpperCase()),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Divider(height: 25),

          Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [

    // Edit
    Tooltip(
      message: "Edit User",
      child: IconButton(
        icon: const Icon(
          Icons.edit,
          color: Colors.blue,
        ),
        onPressed: () async {

  final nameController =
      TextEditingController(text: user.name);

  final emailController =
      TextEditingController(text: user.email);

  final phoneController =
      TextEditingController(text: user.phone);

  final result = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Edit User"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Name",
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: "Phone",
              ),
              keyboardType: TextInputType.phone,
            ),

          ],
        ),
      ),
      actions: [

        TextButton(
          onPressed: () {
            Navigator.pop(context,false);
          },
          child: const Text("Cancel"),
        ),

        ElevatedButton(
          onPressed: () {
            Navigator.pop(context,true);
          },
          child: const Text("Save"),
        ),

      ],
    ),
  );

  if (result == true) {

    await provider.updateUser(
      id: user.id,
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
    );

    if (context.mounted) {

      provider.loadUsers();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User updated successfully"),
        ),
      );
    }
  }
},
      ),
    ),

    // Toggle Status
    Tooltip(
      message: user.status == 1
          ? "Deactivate User"
          : "Activate User",
      child: IconButton(
        icon: Icon(
          user.status == 1
              ? Icons.toggle_on
              : Icons.toggle_off,
          size: 36,
          color: user.status == 1
              ? Colors.green
              : Colors.grey,
        ),
        onPressed: () async {
          await provider.toggleStatus(user.id);

          if (context.mounted) {
            provider.loadUsers();
          }
        },
      ),
    ),

    // Delete
    Tooltip(
      message: "Delete User",
      child: IconButton(
        icon: const Icon(
          Icons.delete,
          color: Colors.red,
        ),
        onPressed: () async {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Delete User"),
              content: Text(
                "Delete ${user.name} permanently?",
              ),
              actions: [
                TextButton(
                  onPressed: () =>
                      Navigator.pop(context, false),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () =>
                      Navigator.pop(context, true),
                  child: const Text("Delete"),
                ),
              ],
            ),
          );

          if (confirm == true) {
            await provider.deleteUser(user.id);

            if (context.mounted) {
              provider.loadUsers();
            }
          }
        },
      ),
    ),
  ],
)
        ],
      ),
    ),
  );
}
              ),
            ),
    );
  }
}