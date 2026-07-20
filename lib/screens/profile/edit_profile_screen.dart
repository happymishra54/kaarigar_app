import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/profile_provider.dart';
import '../../services/auth_service.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const EditProfileScreen({
    super.key,
    required this.user,
  });

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {

  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  final auth = AuthService();

  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(text: widget.user["name"]);

    emailController =
        TextEditingController(text: widget.user["email"]);

    phoneController =
        TextEditingController(text: widget.user["phone"]);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> save() async {

    if (!_formKey.currentState!.validate()) return;

    final token = await auth.getToken();

    if (token == null) return;

    final provider =
        context.read<ProfileProvider>();

    try {

      await provider.update(
        token: token,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
      );

      if (!mounted) return;

      await provider.loadProfile(token);

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Profile Updated Successfully",
          ),
        ),
      );

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );

    }

  }

  @override
  Widget build(BuildContext context) {

    final provider =
        context.watch<ProfileProvider>();

    return Scaffold(

      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Form(

          key: _formKey,

          child: Column(

            children: [

              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                ),
                validator: (v) =>
                    v!.isEmpty ? "Required" : null,
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                ),
                validator: (v) =>
                    v!.isEmpty ? "Required" : null,
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: "Phone",
                ),
                validator: (v) =>
                    v!.isEmpty ? "Required" : null,
              ),

              const SizedBox(height: 35),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed:
                      provider.loading ? null : save,
                  child: provider.loading
                      ? const CircularProgressIndicator()
                      : const Text(
                          "SAVE CHANGES",
                        ),
                ),
              ),

            ],

          ),

        ),

      ),

    );

  }

}