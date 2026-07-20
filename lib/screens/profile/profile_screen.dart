import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'edit_profile_screen.dart';
import '../../providers/profile_provider.dart';
import '../../services/auth_service.dart';
import '../auth/role_selection_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final authService = AuthService();

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final token = await authService.getToken();

    if (token == null) return;

    if (!mounted) return;

    await context.read<ProfileProvider>().loadProfile(token);
  }

  Future<void> logout() async {
    await authService.logout();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const RoleSelectionScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
      ),
      body: provider.loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : provider.user == null
              ? const Center(
                  child: Text("Unable to load profile"),
                )
              : ListView(
                  padding: const EdgeInsets.all(20),
                  children: [

                    const CircleAvatar(
                      radius: 50,
                      child: Icon(
                        Icons.person,
                        size: 50,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Center(
                      child: Text(
                        provider.user!["name"],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.email),
                        title: const Text("Email"),
                        subtitle: Text(provider.user!["email"] ?? ""),
                      ),
                    ),

                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.phone),
                        title: const Text("Phone"),
                        subtitle: Text(provider.user!["phone"] ?? ""),
                      ),
                    ),

                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.badge),
                        title: const Text("Role"),
                        subtitle: Text(provider.user!["role"]),
                      ),
                    ),

                    const SizedBox(height: 30),

                    ElevatedButton.icon(
                      onPressed: () async {

  await Navigator.push(

    context,

    MaterialPageRoute(

      builder: (_) => EditProfileScreen(
        user: provider.user!,
      ),

    ),

  );

  final token = await authService.getToken();

  if (token != null && mounted) {
    await context
        .read<ProfileProvider>()
        .loadProfile(token);
  }

},
                      icon: const Icon(Icons.edit),
                      label: const Text("Edit Profile"),
                    ),

                    const SizedBox(height: 15),

                    OutlinedButton.icon(
                      onPressed: logout,
                      icon: const Icon(Icons.logout),
                      label: const Text("Logout"),
                    ),
                  ],
                ),
    );
  }
}