import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_strings.dart';
import 'package:frontend/core/theme/design_constants.dart';
import 'package:frontend/core/widgets/animated_background.dart';
import 'package:frontend/core/widgets/glass_card.dart';
import 'package:frontend/core/widgets/responsive.dart';
import 'package:frontend/features/auth/models/user.dart';
import 'package:frontend/features/auth/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.value;
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(AppStrings.profile),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: AnimatedBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _ModernHeader(user: user),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? DesignConstants.pM : DesignConstants.pXL,
                  vertical: DesignConstants.pXL,
                ),
                child: const Column(
                  children: [
                    _StatsGrid(),
                    SizedBox(height: DesignConstants.pXXL),
                    _ActionSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModernHeader extends StatelessWidget {
  const _ModernHeader({required this.user});
  final User? user;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 280,
          width: double.infinity,
          decoration: const BoxDecoration(gradient: DesignConstants.primaryGradient),
          child: Opacity(
            opacity: 0.1,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) =>
                  const Icon(Icons.bubble_chart_rounded, size: 100, color: Colors.white),
            ),
          ),
        ),
        Container(
          height: 280,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                DesignConstants.surfaceSolid.withValues(alpha: 0.8),
                DesignConstants.surfaceSolid,
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: DesignConstants.pL),
          child: Column(
            children: [
              _Avatar(fullName: user?.fullName),
              const SizedBox(height: DesignConstants.pL),
              Text(
                user?.fullName ?? AppStrings.anonymousUser,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
              Text(
                user?.email ?? AppStrings.noEmailLinked,
                style: TextStyle(
                  color: DesignConstants.textMuted.withValues(alpha: 0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.fullName});
  final String? fullName;

  @override
  Widget build(BuildContext context) {
    final initial = (fullName?.isNotEmpty ?? false) ? fullName![0].toUpperCase() : '?';

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: DesignConstants.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: DesignConstants.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Colors.white),
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _StatCard(
            label: AppStrings.userRating,
            value: '4.9',
            icon: Icons.star_rounded,
            color: DesignConstants.accent,
            progress: 0.98,
          ),
        ),
        SizedBox(width: DesignConstants.pM),
        Expanded(
          child: _StatCard(
            label: AppStrings.totalPoints,
            value: '1,240',
            icon: Icons.toll_rounded,
            color: DesignConstants.secondary,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.progress,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(DesignConstants.pL),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 20),
              if (progress != null)
                Text(
                  AppStrings.topPercentile,
                  style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w900),
                ),
            ],
          ),
          const SizedBox(height: DesignConstants.pM),
          Text(
            value,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: -0.5),
          ),
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: DesignConstants.textMuted,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
          if (progress != null) ...[
            const SizedBox(height: DesignConstants.pM),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: color.withValues(alpha: 0.1),
                color: color,
                minHeight: 3,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ActionSection extends ConsumerWidget {
  const _ActionSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.accountSettingsTitle,
          style: TextStyle(
            color: DesignConstants.textMuted,
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
        SizedBox(height: DesignConstants.pL),
        _ActionList(),
      ],
    );
  }
}

class _ActionList extends ConsumerWidget {
  const _ActionList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _ActionButton(
          label: AppStrings.editProfile,
          icon: Icons.person_outline_rounded,
          onTap: () {},
        ),
        const SizedBox(height: DesignConstants.pM),
        _ActionButton(
          label: 'Wallet Settings',
          icon: Icons.account_balance_wallet_outlined,
          onTap: () {},
        ),
        const SizedBox(height: DesignConstants.pM),
        _ActionButton(
          label: AppStrings.identityVerification,
          icon: Icons.verified_user_outlined,
          onTap: () {},
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: DesignConstants.danger.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              AppStrings.statusRejected,
              style: TextStyle(
                color: DesignConstants.danger,
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        const SizedBox(height: DesignConstants.pXXL),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => ref.read(authProvider.notifier).logout(),
            style: ElevatedButton.styleFrom(
              backgroundColor: DesignConstants.danger.withValues(alpha: 0.1),
              foregroundColor: DesignConstants.danger,
              side: const BorderSide(color: DesignConstants.danger, width: 1.5),
              minimumSize: const Size(0, 56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout_rounded, size: 20),
                SizedBox(width: DesignConstants.pM),
                Text(AppStrings.logout),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.trailing,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(16),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: DesignConstants.pL, vertical: 4),
        leading: Icon(icon, color: DesignConstants.secondary, size: 22),
        title: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        trailing:
            trailing ?? const Icon(Icons.chevron_right, color: DesignConstants.textMuted, size: 20),
      ),
    );
  }
}
