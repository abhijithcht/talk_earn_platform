import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/api/api_error_handler.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/core/theme/app_strings.dart';
import 'package:frontend/core/theme/design_constants.dart';
import 'package:frontend/core/widgets/animated_background.dart';
import 'package:frontend/core/widgets/glass_card.dart';
import 'package:frontend/features/auth/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  String _gender = 'male';
  String _genderPreference = 'any';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    try {
      await ref
          .read(authProvider.notifier)
          .register(
            email: _emailController.text,
            password: _passwordController.text,
            fullName: _nameController.text,
            gender: _gender,
            genderPreference: _genderPreference,
          );
      if (mounted) {
        await context.push<void>(AppRoutes.verifyEmail, extra: _emailController.text);
      }
    } catch (e) {
      if (mounted) {
        final errorMessage = ApiErrorHandler.getMessage(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: DesignConstants.danger.withValues(alpha: 0.9),
            content: Text(errorMessage),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: AnimatedBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: GlassCard(
              width: 440,
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => DesignConstants.textGradient.createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                    ),
                    child: const Text(
                      AppStrings.registerTitle,
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.registerDesc,
                    style: TextStyle(
                      color: DesignConstants.textMuted.withValues(alpha: 0.5),
                      fontSize: 16, // Changed from 14 to 16 as per instruction
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person_outline, size: 20),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      prefixIcon: Icon(Icons.email_outlined, size: 20),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline, size: 20),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _gender,
                    decoration: const InputDecoration(
                      labelText: 'Your Gender',
                      prefixIcon: Icon(Icons.wc, size: 20),
                    ),
                    items: [
                      'male',
                      'female',
                      'other',
                    ].map((g) => DropdownMenuItem(value: g, child: Text(g.toUpperCase()))).toList(),
                    onChanged: (val) => setState(() => _gender = val!),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _genderPreference,
                    decoration: const InputDecoration(
                      labelText: 'Match Preference',
                      prefixIcon: Icon(Icons.favorite_border, size: 20),
                    ),
                    items: [
                      'any',
                      'male',
                      'female',
                    ].map((g) => DropdownMenuItem(value: g, child: Text(g.toUpperCase()))).toList(),
                    onChanged: (val) => setState(() => _genderPreference = val!),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: authState.isLoading ? null : _register,
                    child: authState.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text(AppStrings.registerBtn),
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(
                          color: DesignConstants.textMuted.withValues(alpha: 0.3),
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.pop(),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            color: DesignConstants.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
