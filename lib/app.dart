import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/screens/welcome/welcome_screen.dart';

// Colours derived from bg.png (dark navy question-mark pattern):
//   dominant bg  → #0A1428  (deep navy)
//   seed accent  → #6C63FF  (indigo-violet — natural complement to navy)
const _bgNavy = Color(0xFF0A1428);
const _accentIndigo = Color(0xFF6C63FF);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Animate.restartOnHotReload = true;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QuizMaster',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _accentIndigo,
          brightness: Brightness.dark,
        ),
        // Match the bg image so scaffold colour is invisible under AppBackground
        scaffoldBackgroundColor: _bgNavy,
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          color: const Color(0xFF151F38), // navy-tinted card surface
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          shadowColor: Colors.black54,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          filled: true,
          fillColor: Colors.white.withOpacity(0.07),
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: const Color(0xFF151F38),
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: Colors.white.withOpacity(0.08)),
          ),
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          contentTextStyle: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.white70,
            height: 1.5,
          ),
          elevation: 24,
          shadowColor: Colors.black87,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: const Color(0xFF1E2E50),
          contentTextStyle: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.white.withOpacity(0.08)),
          ),
          behavior: SnackBarBehavior.floating,
          elevation: 8,
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}
