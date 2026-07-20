import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/booking_provider.dart';
import 'config/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/home_provider.dart';
import 'screens/splash/splash_screen.dart';
import 'providers/profile_provider.dart';
import 'providers/worker_provider.dart';
import 'providers/worker_profile_provider.dart';
import 'providers/worker_dashboard_provider.dart';
import 'providers/worker_service_provider.dart';
import 'providers/category_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const KaarigarApp());
}

class KaarigarApp extends StatelessWidget {
  const KaarigarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [


        ChangeNotifierProvider(
          create: (_) => CategoryProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => WorkerServiceProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => WorkerDashboardProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => WorkerProfileProvider(),
        ),

        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => BookingProvider(),
        ), 

        ChangeNotifierProvider<HomeProvider>(
          create: (_) => HomeProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => ProfileProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => WorkerProvider(),
        ),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Kaarigar',
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}