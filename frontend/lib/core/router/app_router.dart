import 'package:flutter/material.dart';
import 'package:frontend/core/api/token_storage.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/features/auth/presentation/login_screen.dart';
import 'package:frontend/features/auth/presentation/register_screen.dart';
import 'package:frontend/features/auth/presentation/verify_email_screen.dart';
import 'package:frontend/features/home/presentation/home_screen.dart';
import 'package:frontend/features/home/presentation/main_shell_screen.dart';
import 'package:frontend/features/profile/presentation/profile_screen.dart';
import 'package:frontend/features/settings/presentation/settings_screen.dart';
import 'package:frontend/features/wallet/presentation/wallet_dashboard_screen.dart';
import 'package:go_router/go_router.dart';

// Placeholder empty screens for upcoming features
class ChatPlaceholder extends StatelessWidget {
  const ChatPlaceholder({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Chat Feature Coming Soon')));
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.home,
  redirect: (context, state) async {
    final token = await TokenStorage.getToken();
    final isGoingToAuth =
        state.matchedLocation == AppRoutes.login ||
        state.matchedLocation == AppRoutes.register ||
        state.matchedLocation == AppRoutes.verifyEmail;

    // Must be logged in to access anything else
    if (token == null && !isGoingToAuth) {
      return AppRoutes.login;
    }

    // Automatically redirect to home if already logged in trying to reach auth pages
    if (token != null && isGoingToAuth) {
      return AppRoutes.home;
    }

    return null; // Let the navigation continue
  },
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => MainShellScreen(child: child),
      routes: [
        GoRoute(path: AppRoutes.home, builder: (context, state) => const HomeScreen()),
        GoRoute(path: AppRoutes.chat, builder: (context, state) => const ChatPlaceholder()),
        GoRoute(path: AppRoutes.wallet, builder: (context, state) => const WalletDashboardScreen()),
        GoRoute(path: AppRoutes.profile, builder: (context, state) => const ProfileScreen()),
      ],
    ),
    GoRoute(
      path: AppRoutes.settings,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.register,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: AppRoutes.verifyEmail,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final email = state.extra as String? ?? '';
        return VerifyEmailScreen(email: email);
      },
    ),
  ],
);
