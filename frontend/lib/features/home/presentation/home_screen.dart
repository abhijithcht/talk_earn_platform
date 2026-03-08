import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_strings.dart';
import 'package:frontend/core/theme/design_constants.dart';
import 'package:frontend/core/widgets/animated_background.dart';
import 'package:frontend/core/widgets/dash_layout.dart';
import 'package:frontend/core/widgets/glass_card.dart';
import 'package:frontend/core/widgets/responsive.dart';
import 'package:frontend/features/auth/providers/auth_provider.dart';
import 'package:frontend/features/home/presentation/radar_animation.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.value;

    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: Column(
            children: [
              _Header(fullName: user?.fullName),
              const Expanded(
                child: DashLayout(sidebar: _Sidebar(), main: _MainHub()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({this.fullName});
  final String? fullName;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? DesignConstants.pM : DesignConstants.pXL,
        vertical: DesignConstants.pL,
      ),
      child: const Row(children: [_Logo(), Spacer(), _HeaderActions()]),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => DesignConstants.textGradient.createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          ),
          child: const Text(
            AppStrings.appName,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -1.5,
              height: 1.1,
            ),
          ),
        ),
        Text(
          AppStrings.appSlogan,
          style: TextStyle(
            color: DesignConstants.textMuted.withValues(alpha: 0.7),
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}

class _HeaderActions extends ConsumerWidget {
  const _HeaderActions();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(16),
      child: Row(
        children: [
          _ActionButton(icon: Icons.notifications_none_rounded, onPressed: () {}),
          const SizedBox(width: DesignConstants.pS),
          _ActionButton(icon: Icons.settings_outlined, onPressed: () {}),
          const SizedBox(width: DesignConstants.pM),
          Container(width: 1, height: 20, color: DesignConstants.glassBorder),
          const SizedBox(width: 12),
          IconButton(
            onPressed: () => ref.read(authProvider.notifier).logout(),
            icon: const Icon(Icons.logout_rounded, color: DesignConstants.danger, size: 22),
            tooltip: 'Logout',
          ),
        ],
      ),
    );
  }
}

class _Sidebar extends ConsumerWidget {
  const _Sidebar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Column(
      children: [
        _PremiumWallet(),
        SizedBox(height: DesignConstants.pL),
        _MatchPreferences(),
      ],
    );
  }
}

class _PremiumWallet extends ConsumerWidget {
  const _PremiumWallet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            DesignConstants.primary.withValues(alpha: 0.8),
            DesignConstants.secondary.withValues(alpha: 0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: DesignConstants.primary.withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: GlassCard(
        padding: const EdgeInsets.all(DesignConstants.pL),
        borderRadius: BorderRadius.circular(24),
        blur: 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(DesignConstants.pS),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  AppStrings.earningsWallet,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: DesignConstants.pL),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '0.00',
                  style: TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -1,
                  ),
                ),
                SizedBox(width: DesignConstants.pS),
                Text(
                  'TC',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: DesignConstants.pL),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: DesignConstants.primary,
                      minimumSize: const Size(0, 48),
                    ),
                    child: const Text('Withdraw'),
                  ),
                ),
                const SizedBox(width: DesignConstants.pM),
                _ActionButton(
                  icon: Icons.refresh_rounded,
                  onPressed: () => ref.invalidate(authProvider),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MatchPreferences extends StatelessWidget {
  const _MatchPreferences();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(DesignConstants.pL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.tune_rounded, color: DesignConstants.secondary, size: 20),
              SizedBox(width: DesignConstants.pM),
              Text(
                'Match Preferences',
                style: TextStyle(
                  color: DesignConstants.textMuted,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignConstants.pL),
          DropdownButtonFormField<String>(
            initialValue: 'any',
            items: const [
              DropdownMenuItem(value: 'any', child: Text('Global (Fastest)')),
              DropdownMenuItem(value: 'male', child: Text('Males Only')),
              DropdownMenuItem(value: 'female', child: Text('Females Only')),
            ],
            onChanged: (v) {},
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.05),
              contentPadding: const EdgeInsets.symmetric(horizontal: DesignConstants.pM, vertical: DesignConstants.pM),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MainHub extends ConsumerWidget {
  const _MainHub();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // In a real scenario, this would watch a matchingProvider.
    final searchActive = ref.watch(authProvider).isLoading;

    return GlassCard(
      padding: const EdgeInsets.all(DesignConstants.pXXL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (searchActive) const _MatchingState() else const _IdleState(),
          const SizedBox(height: DesignConstants.pXXL),
          const _ConnectionStatus(),
        ],
      ),
    );
  }
}

class _IdleState extends StatelessWidget {
  const _IdleState();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          AppStrings.readyToConnect,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
            height: 1.1,
          ),
        ),
        const SizedBox(height: DesignConstants.pM),
        const Text(
          AppStrings.chooseMode,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: DesignConstants.textMuted,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: DesignConstants.pXXL),
        Wrap(
          spacing: DesignConstants.pL,
          runSpacing: DesignConstants.pL,
          alignment: WrapAlignment.center,
          children: [
            _MatchButton(
              icon: Icons.chat_bubble_rounded,
              label: 'Text Chat',
              color: DesignConstants.primary,
              onPressed: () {},
            ),
            _MatchButton(
              icon: Icons.mic_rounded,
              label: 'Voice Call',
              color: DesignConstants.secondary,
              onPressed: () {},
            ),
            _MatchButton(
              icon: Icons.videocam_rounded,
              label: 'Video Call',
              color: DesignConstants.accent,
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}

class _MatchingState extends StatelessWidget {
  const _MatchingState();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        RadarAnimation(isMatching: true),
        SizedBox(height: DesignConstants.pXL),
        Text(
          'Looking for someone...',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: DesignConstants.secondary,
          ),
        ),
      ],
    );
  }
}

class _ConnectionStatus extends StatelessWidget {
  const _ConnectionStatus();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: DesignConstants.pL, vertical: 10),
      decoration: BoxDecoration(
        color: DesignConstants.accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: DesignConstants.accent.withValues(alpha: 0.2)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PulseIndicator(),
          SizedBox(width: DesignConstants.pM),
          Text(
            AppStrings.networkStable,
            style: TextStyle(
              color: DesignConstants.accent,
              fontSize: 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _MatchButton extends StatelessWidget {
  const _MatchButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: GlassCard(
        padding: EdgeInsets.zero,
        borderRadius: BorderRadius.circular(28),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 36),
              ),
              const SizedBox(height: DesignConstants.pM),
              Text(
                label.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PulseIndicator extends StatefulWidget {
  const _PulseIndicator();

  @override
  State<_PulseIndicator> createState() => _PulseIndicatorState();
}

class _PulseIndicatorState extends State<_PulseIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: DesignConstants.accent,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: DesignConstants.accent.withValues(alpha: 0.5 * (1.0 - _controller.value)),
                blurRadius: 10 * _controller.value,
                spreadRadius: 8 * _controller.value,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.icon, required this.onPressed});
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: DesignConstants.textMuted, size: 20),
      style: IconButton.styleFrom(
        backgroundColor: Colors.white.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
