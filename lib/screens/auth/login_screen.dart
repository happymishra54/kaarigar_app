import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../worker/worker_bottom_nav.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_textfield.dart';
import '../../widgets/primary_button.dart';
import '../customer/customer_bottom_nav.dart';
import 'register_screen.dart';
import '../worker/complete_profile_screen.dart';
import '../../services/worker_profile_service.dart';


class LoginScreen extends StatefulWidget {
  final String role;

  const LoginScreen({
    super.key,
    required this.role,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController loginController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  bool obscure = true;

  @override
  void dispose() {
    loginController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final auth = context.read<AuthProvider>();

    try {
      final success = await auth.login(
        login: loginController.text.trim(),
        password: passwordController.text,
        role: widget.role,
      );

      if (!mounted) return;

      if (success) {
        if (widget.role == "customer") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const CustomerBottomNav(),
            ),
          );
                } else {

          final workerProfileService =
              WorkerProfileService();


          final profileStatus =
              await workerProfileService.checkProfileStatus();


          final isCompleted =
    profileStatus["completed"] == true;


          final profile =
              profileStatus["profile"];


          if (!mounted) return;


          if (isCompleted) {

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    WorkerBottomNav(
    profile: profile,
),
              ),
            );


          } else {

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    CompleteProfileScreen(profile: profile),
              ),
            );

          }

        }
      }
    } catch (e) {
      if (!mounted) return;

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
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 30),

                const Icon(
                  Icons.home_repair_service,
                  size: 80,
                  color: Colors.blue,
                ),

                const SizedBox(height: 20),

                const Center(
                  child: Text(
                    "Welcome Back",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Center(
                  child: Text(
                    "Login as ${widget.role.toUpperCase()}",
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                AppTextField(
                  controller: loginController,
                  hint: "Email or Mobile",
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter email or mobile";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                AppTextField(
                  controller: passwordController,
                  hint: "Password",
                  icon: Icons.lock,
                  obscure: obscure,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter password";
                    }
                    return null;
                  },
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscure
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        obscure = !obscure;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 10),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: Forgot Password Screen
                    },
                    child: const Text(
                      "Forgot Password?",
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                PrimaryButton(
                  text: "LOGIN",
                  loading: auth.loading,
                  onPressed: login,
                ),

                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                    ),
                    TextButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RegisterScreen(
          role: widget.role,
        ),
      ),
    );
  },
  child: const Text("Register"),
)
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}