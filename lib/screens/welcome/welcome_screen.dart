import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:quiz_app/screens/auth/auth_screen.dart';
import 'package:quiz_app/screens/home/home_screen.dart';
import 'package:quiz_app/services/auth_service.dart';
import 'package:quiz_app/widgets/app_background.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isLoading = false;
  StreamSubscription<User?>? _authSub;

  @override
  void initState() {
    super.initState();
    _authSub = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null && mounted) _goToHome();
    });
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final success = await AuthService.signInWithGoogle();
      if (mounted && !success) setState(() => _isLoading = false);
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google sign-in failed: $e')),
        );
      }
    }
  }

  void _goToHome() => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );

  void _goToEmailAuth() => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AuthScreen()),
      );

  void _continueAsGuest() => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: AppBackground(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  const Spacer(),

                  // Logo
                  Image.asset('assets/answer.png', width: 160, height: 160)
                      .animate()
                      .scale(
                        begin: const Offset(0.4, 0.4),
                        duration: 700.ms,
                        curve: Curves.elasticOut,
                      )
                      .fadeIn(duration: 400.ms),

                  const SizedBox(height: 24),

                  // App name
                  Text(
                    'QuizMaster',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                  )
                      .animate()
                      .slideY(
                        begin: 0.4,
                        duration: 600.ms,
                        delay: 300.ms,
                        curve: Curves.easeOut,
                      )
                      .fadeIn(duration: 500.ms, delay: 300.ms),

                  const SizedBox(height: 8),

                  Text(
                    'Test your knowledge across\n10 exciting subjects',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  )
                      .animate()
                      .slideY(
                        begin: 0.4,
                        duration: 600.ms,
                        delay: 450.ms,
                        curve: Curves.easeOut,
                      )
                      .fadeIn(duration: 500.ms, delay: 450.ms),

                  const Spacer(),

                  // Buttons
                  if (AuthService.isLoggedIn)
                    _WelcomeButton(
                      label: 'Continue',
                      icon: Icons.arrow_forward_rounded,
                      color: cs.primary,
                      onPressed: _goToHome,
                    )
                        .animate()
                        .slideY(
                            begin: 0.5,
                            delay: 600.ms,
                            duration: 500.ms,
                            curve: Curves.easeOut)
                        .fadeIn(delay: 600.ms)
                  else if (_isLoading)
                    const CircularProgressIndicator(color: Colors.white)
                        .animate()
                        .fadeIn()
                  else
                    Column(
                      children: [
                        _WelcomeButton(
                          label: 'Continue with Google',
                          icon: Icons.g_mobiledata_rounded,
                          color: Colors.white,
                          textColor: Colors.black87,
                          onPressed: _signInWithGoogle,
                        )
                            .animate()
                            .slideY(
                              begin: 0.5,
                              delay: 600.ms,
                              duration: 500.ms,
                              curve: Curves.easeOut,
                            )
                            .fadeIn(delay: 600.ms),

                        const SizedBox(height: 14),

                        _WelcomeButton(
                          label: 'Sign in with Email',
                          icon: Icons.email_outlined,
                          color: cs.primary,
                          onPressed: _goToEmailAuth,
                        )
                            .animate()
                            .slideY(
                              begin: 0.5,
                              delay: 750.ms,
                              duration: 500.ms,
                              curve: Curves.easeOut,
                            )
                            .fadeIn(delay: 750.ms),
                      ],
                    ),

                  const SizedBox(height: 20),

                  if (!AuthService.isLoggedIn && !_isLoading)
                    TextButton(
                      onPressed: _continueAsGuest,
                      child: const Text(
                        'Continue as Guest',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white54,
                        ),
                      ),
                    ).animate().fadeIn(delay: 900.ms),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WelcomeButton extends StatelessWidget {
  const _WelcomeButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
    this.textColor,
  });

  final String label;
  final IconData icon;
  final Color color;
  final Color? textColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final fgColor = textColor ?? Colors.white;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: fgColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          elevation: 4,
          shadowColor: Colors.black38,
        ),
        icon: Icon(icon, size: 22),
        label: Text(label),
        onPressed: onPressed,
      ),
    );
  }
}
