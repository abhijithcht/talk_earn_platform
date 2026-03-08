import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/core/theme/app_strings.dart';
import 'package:frontend/core/theme/design_constants.dart';
import 'package:frontend/core/widgets/animated_background.dart';
import 'package:frontend/core/widgets/glass_card.dart';
import 'package:frontend/core/widgets/responsive.dart';
import 'package:frontend/features/wallet/providers/wallet_provider.dart';
import 'package:go_router/go_router.dart';

class WalletDashboardScreen extends ConsumerWidget {
  const WalletDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balanceAsync = ref.watch(walletBalanceProvider);
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(AppStrings.myWallet),
        actions: [IconButton(icon: const Icon(Icons.history_rounded), onPressed: () {})],
      ),
      body: AnimatedBackground(
        child: RefreshIndicator(
          color: DesignConstants.secondary,
          onRefresh: () async => ref.invalidate(walletBalanceProvider),
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              isMobile ? DesignConstants.pM : DesignConstants.pXL,
              120,
              isMobile ? DesignConstants.pM : DesignConstants.pXL,
              DesignConstants.pXL,
            ),
            children: [
              _PremiumHeroCard(balanceAsync: balanceAsync),
              const SizedBox(height: DesignConstants.pXXL),
              const _SectionHeader(title: AppStrings.quickActions),
              const SizedBox(height: DesignConstants.pL),
              const _ResponsiveActions(),
              const SizedBox(height: DesignConstants.pXXL),
              const _EarningsTips(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: DesignConstants.textMuted,
        fontSize: 13,
        fontWeight: FontWeight.w900,
        letterSpacing: 2,
      ),
    );
  }
}

class _ResponsiveActions extends ConsumerWidget {
  const _ResponsiveActions();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = Responsive.isMobile(context);
    final actions = [
      _ActionCard(
        title: AppStrings.earnMoreTitle,
        subtitle: AppStrings.earnMoreDesc,
        icon: Icons.add_chart_rounded,
        color: DesignConstants.accent,
        onTap: () => context.go(AppRoutes.home),
      ),
      _ActionCard(
        title: AppStrings.requestWithdrawalTitle,
        subtitle: AppStrings.requestWithdrawalDesc,
        icon: Icons.payments_rounded,
        color: DesignConstants.secondary,
        onTap: () => _showWithdrawDialog(context, ref),
      ),
    ];

    if (isMobile) {
      return Column(
        children: actions
            .map(
              (a) => Padding(
                padding: const EdgeInsets.only(bottom: DesignConstants.pM),
                child: a,
              ),
            )
            .toList(),
      );
    }

    return Wrap(
      spacing: DesignConstants.pL,
      runSpacing: DesignConstants.pL,
      children: actions.map((a) => SizedBox(width: 380, child: a)).toList(),
    );
  }
}

class _PremiumHeroCard extends StatelessWidget {
  const _PremiumHeroCard({required this.balanceAsync});
  final AsyncValue<int> balanceAsync;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            DesignConstants.walletGradientStart,
            DesignConstants.walletGradientMiddle,
            DesignConstants.walletGradientEnd,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: DesignConstants.walletGradientStart.withValues(alpha: 0.4),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: GlassCard(
        padding: const EdgeInsets.all(DesignConstants.pXL),
        borderRadius: BorderRadius.circular(32),
        blur: 12,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignConstants.pM,
                vertical: DesignConstants.pS,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                AppStrings.availableBalance,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            const SizedBox(height: DesignConstants.pXL),
            balanceAsync.when(
              data: (balance) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    balance.toDouble().toStringAsFixed(2),
                    style: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -2,
                    ),
                  ),
                  const SizedBox(width: DesignConstants.pM),
                  const Text(
                    'TC',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              loading: () => const CircularProgressIndicator(color: Colors.white),
              error: (err, _) =>
                  const Text('--', style: TextStyle(fontSize: 48, color: Colors.white)),
            ),
            const SizedBox(height: DesignConstants.pXL),
            const _WeeklyTrend(),
          ],
        ),
      ),
    );
  }
}

class _WeeklyTrend extends StatelessWidget {
  const _WeeklyTrend();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: DesignConstants.pM, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_graph_rounded, color: Colors.white, size: 18),
          SizedBox(width: DesignConstants.pM),
          Text(
            AppStrings.weeklyTrend,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(20),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DesignConstants.pL,
          vertical: DesignConstants.pM,
        ),
        leading: Container(
          padding: const EdgeInsets.all(DesignConstants.pM),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: DesignConstants.textMuted, fontSize: 13),
        ),
        trailing: const Icon(Icons.chevron_right, color: DesignConstants.textMuted, size: 20),
      ),
    );
  }
}

class _EarningsTips extends StatelessWidget {
  const _EarningsTips();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(DesignConstants.pL),
      child: Row(
        children: [
          const Icon(Icons.lightbulb_outline, color: Colors.amber, size: 24),
          const SizedBox(width: DesignConstants.pM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  AppStrings.earningsTipsTitle,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
                Text(
                  AppStrings.earningsTipsDesc,
                  style: TextStyle(
                    color: DesignConstants.textMuted.withValues(alpha: 0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void _showWithdrawDialog(BuildContext context, WidgetRef ref) {
  showDialog<void>(context: context, builder: (ctx) => const _WithdrawDialog());
}

class _WithdrawDialog extends StatelessWidget {
  const _WithdrawDialog();

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: const ColorFilter.mode(Colors.black26, BlendMode.darken),
      child: AlertDialog(
        backgroundColor: DesignConstants.dialogBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: DesignConstants.glassBorder),
        ),
        title: const Text(
          AppStrings.withdrawDialogTitle,
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              AppStrings.withdrawDialogDesc,
              style: TextStyle(color: DesignConstants.textMuted, fontSize: 14),
            ),
            const SizedBox(height: DesignConstants.pL),
            TextField(
              decoration: InputDecoration(
                labelText: AppStrings.amountLabel,
                hintText: AppStrings.minAmountHint,
                fillColor: Colors.black.withValues(alpha: 0.3),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              AppStrings.cancel,
              style: TextStyle(color: DesignConstants.textMuted),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(120, 44),
              backgroundColor: DesignConstants.secondary,
            ),
            child: const Text(AppStrings.confirm),
          ),
        ],
      ),
    );
  }
}
