import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/constants/app_colors.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'core/utils/shared_prefs_helper.dart';

class HealthyBiteApp extends StatelessWidget {
  const HealthyBiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = SharedPrefsHelper.getBool('isLoggedIn') ?? false;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HealthyBite',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
        scaffoldBackgroundColor: AppColors.background,
      ),
      home: isLoggedIn ? const HomeScreen() : const LoginScreen(),
    );
  }
}