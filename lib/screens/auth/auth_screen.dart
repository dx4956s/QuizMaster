import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:quiz_app/screens/home/home_screen.dart';
import 'package:quiz_app/services/auth_service.dart';
import 'package:quiz_app/widgets/app_background.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      if (_isLogin) {
        await AuthService.signInWithEmail(
          _emailController.text.trim(),
          _passwordController.text,
        );
      } else {
        await AuthService.signUpWithEmail(
          _emailController.text.trim(),
          _passwordController.text,
        );
      }
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Header
                  Text(
                    _isLogin ? 'Welcome Back!' : 'Create Account',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.3, delay: 150.ms),

                  const SizedBox(height: 32),

                  // Form card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: AnimatedSwitcher(
                          duration: 300.ms,
                          child: _FormContent(
                            key: ValueKey(_isLogin),
                            isLogin: _isLogin,
                            emailController: _emailController,
                            passwordController: _passwordController,
                            obscurePassword: _obscurePassword,
                            isLoading: _isLoading,
                            errorMessage: _errorMessage,
                            onToggleObscure: () => setState(
                                () => _obscurePassword = !_obscurePassword),
                            onSubmit: _submit,
                            onToggleMode: () => setState(() {
                              _isLogin = !_isLogin;
                              _errorMessage = null;
                            }),
                          ),
                        ),
                      ),
                    ),
                  ).animate().slideY(
                      begin: 0.4,
                      delay: 250.ms,
                      duration: 500.ms,
                      curve: Curves.easeOut).fadeIn(delay: 250.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FormContent extends StatelessWidget {
  const _FormContent({
    super.key,
    required this.isLogin,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.isLoading,
    required this.errorMessage,
    required this.onToggleObscure,
    required this.onSubmit,
    required this.onToggleMode,
  });

  final bool isLogin;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onToggleObscure;
  final VoidCallback onSubmit;
  final VoidCallback onToggleMode;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Mode toggle chips
        Row(
          children: [
            Expanded(
              child: _ModeChip(
                label: 'Login',
                selected: isLogin,
                onTap: isLogin ? null : onToggleMode,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ModeChip(
                label: 'Sign Up',
                selected: !isLogin,
                onTap: isLogin ? onToggleMode : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        TextFormField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email_outlined),
          ),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator: (v) =>
              v == null || !v.contains('@') ? 'Enter a valid email' : null,
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: passwordController,
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                  obscurePassword ? Icons.visibility_off : Icons.visibility),
              onPressed: onToggleObscure,
            ),
          ),
          obscureText: obscurePassword,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => onSubmit(),
          validator: (v) => v == null || v.length < 6
              ? 'At least 6 characters required'
              : null,
        ),

        if (errorMessage != null) ...[
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF3B1C1C),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.red.shade900),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red.shade300, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    errorMessage!,
                    style:
                        TextStyle(color: Colors.red.shade300, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 24),

        SizedBox(
          height: 52,
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(color: cs.primary),
                )
              : ElevatedButton(
                  onPressed: onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  child: Text(isLogin ? 'Login' : 'Create Account'),
                ),
        ),
      ],
    );
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip(
      {required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AnimatedContainer(
      duration: 250.ms,
      decoration: BoxDecoration(
        color: selected ? cs.primary : cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : cs.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
