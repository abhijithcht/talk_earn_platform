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

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({required this.email, super.key});
  final String email;

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    try {
      await ref.read(authProvider.notifier).verifyEmail(widget.email, _otpController.text);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Verification successful! Please log in.')));
        context.go('/login');
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
                      AppStrings.verifyEmailTitle,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${AppStrings.verifyEmailDescPrefix}${widget.email}',
                    style: const TextStyle(color: DesignConstants.textMuted, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: _otpController,
                    decoration: InputDecoration(
                      hintText: '000000',
                      hintStyle: TextStyle(color: DesignConstants.textMuted.withValues(alpha: 0.3)),
                      counterText: '',
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 32,
                      letterSpacing: 12,
                      fontWeight: FontWeight.w700,
                      color: DesignConstants.secondary,
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: authState.isLoading ? null : _verify,
                    style: ElevatedButton.styleFrom(backgroundColor: DesignConstants.accent),
                    child: authState.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text(AppStrings.verifyAccountBtn),
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () => context.go(AppRoutes.login),
                    child: const Text(
                      AppStrings.backToLogin,
                      style: TextStyle(color: DesignConstants.textMuted),
                    ),
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
