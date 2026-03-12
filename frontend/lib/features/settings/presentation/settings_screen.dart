import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/api/token_storage.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/core/theme/app_strings.dart';
import 'package:frontend/core/theme/design_constants.dart';
import 'package:frontend/core/widgets/animated_background.dart';
import 'package:frontend/core/widgets/glass_card.dart';
import 'package:frontend/features/profile/providers/profile_provider.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(DesignConstants.pL),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SettingsHeader(),
                    const SizedBox(height: DesignConstants.pXXL),
                    profileAsync.when(
                      data: (user) => _SettingsBody(
                        fullName: user.fullName,
                        email: user.email,
                        gender: user.gender,
                      ),
                      loading: () => const Center(
                        child: Padding(
                          padding: EdgeInsets.all(DesignConstants.pXXL),
                          child: CircularProgressIndicator(color: DesignConstants.secondary),
                        ),
                      ),
                      error: (_, _) => const _SettingsBody(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsHeader extends StatelessWidget {
  const _SettingsHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => context.canPop() ? context.pop() : context.go(AppRoutes.home),
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white.withValues(alpha: 0.05),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(width: DesignConstants.pM),
        ShaderMask(
          shaderCallback: (bounds) => DesignConstants.textGradient.createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          ),
          child: const Text(
            AppStrings.settingsTitle,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -1,
            ),
          ),
        ),
      ],
    );
  }
}

class _SettingsBody extends StatelessWidget {
  const _SettingsBody({this.fullName, this.email, this.gender});

  final String? fullName;
  final String? email;
  final String? gender;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _EditProfileSection(fullName: fullName, gender: gender),
        const SizedBox(height: DesignConstants.pXL),
        _AccountInfoSection(email: email),
        const SizedBox(height: DesignConstants.pXL),
        const _ChangePasswordSection(),
        const SizedBox(height: DesignConstants.pXL),
        const _DangerZoneSection(),
      ],
    );
  }
}

// ─── Edit Profile ────────────────────────────────────────────────────────────

class _EditProfileSection extends ConsumerStatefulWidget {
  const _EditProfileSection({this.fullName, this.gender});
  final String? fullName;
  final String? gender;

  @override
  ConsumerState<_EditProfileSection> createState() => _EditProfileSectionState();
}

class _EditProfileSectionState extends ConsumerState<_EditProfileSection> {
  late final TextEditingController _nameController;
  late final TextEditingController _interestsController;
  String _selectedGender = 'male';
  String? _message;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.fullName ?? '');
    _interestsController = TextEditingController();
    _selectedGender = widget.gender ?? 'male';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _interestsController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    await ref.read(profileActionsProvider.notifier).updateProfile({
      'fullName': _nameController.text,
      'gender': _selectedGender,
      'interests': _interestsController.text,
    });
    if (mounted) {
      setState(() => _message = AppStrings.profileSaved);
    }
  }

  @override
  Widget build(BuildContext context) {
    final actions = ref.watch(profileActionsProvider);

    return GlassCard(
      padding: const EdgeInsets.all(DesignConstants.pL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.person_outline_rounded,
            title: AppStrings.editProfileSection,
          ),
          const SizedBox(height: DesignConstants.pL),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: AppStrings.fullNameLabel,
              hintText: AppStrings.fullNameHint,
            ),
          ),
          const SizedBox(height: DesignConstants.pM),
          DropdownButtonFormField<String>(
            initialValue: _selectedGender,
            items: const [
              DropdownMenuItem(value: 'male', child: Text('Male')),
              DropdownMenuItem(value: 'female', child: Text('Female')),
              DropdownMenuItem(value: 'other', child: Text('Other')),
            ],
            onChanged: (v) {
              if (v != null) setState(() => _selectedGender = v);
            },
            decoration: const InputDecoration(labelText: AppStrings.genderLabel),
          ),
          const SizedBox(height: DesignConstants.pM),
          TextField(
            controller: _interestsController,
            decoration: const InputDecoration(
              labelText: AppStrings.interestsLabel,
              hintText: AppStrings.interestsHint,
            ),
          ),
          const SizedBox(height: DesignConstants.pL),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: actions.isLoading ? null : _save,
              child: actions.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text(AppStrings.saveProfile),
            ),
          ),
          if (_message != null) ...[
            const SizedBox(height: DesignConstants.pS),
            Text(
              _message!,
              style: const TextStyle(
                color: DesignConstants.accent,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Account Info ────────────────────────────────────────────────────────────

class _AccountInfoSection extends StatelessWidget {
  const _AccountInfoSection({this.email});
  final String? email;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(DesignConstants.pL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(icon: Icons.info_outline_rounded, title: AppStrings.accountInfo),
          const SizedBox(height: DesignConstants.pL),
          _InfoRow(label: AppStrings.emailLabel, value: email ?? '—'),
          const SizedBox(height: DesignConstants.pM),
          const _InfoRow(label: AppStrings.ageLabel, value: AppStrings.ageNotVerified),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: DesignConstants.textMuted,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

// ─── Change Password ─────────────────────────────────────────────────────────

class _ChangePasswordSection extends ConsumerStatefulWidget {
  const _ChangePasswordSection();

  @override
  ConsumerState<_ChangePasswordSection> createState() => _ChangePasswordSectionState();
}

class _ChangePasswordSectionState extends ConsumerState<_ChangePasswordSection> {
  final _currentPwController = TextEditingController();
  final _newPwController = TextEditingController();
  String? _message;

  @override
  void dispose() {
    _currentPwController.dispose();
    _newPwController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    await ref
        .read(profileActionsProvider.notifier)
        .changePassword(
          currentPassword: _currentPwController.text,
          newPassword: _newPwController.text,
        );
    if (mounted) {
      _currentPwController.clear();
      _newPwController.clear();
      setState(() => _message = AppStrings.passwordUpdated);
    }
  }

  @override
  Widget build(BuildContext context) {
    final actions = ref.watch(profileActionsProvider);

    return GlassCard(
      padding: const EdgeInsets.all(DesignConstants.pL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(icon: Icons.lock_outline_rounded, title: AppStrings.changePassword),
          const SizedBox(height: DesignConstants.pL),
          TextField(
            controller: _currentPwController,
            obscureText: true,
            decoration: const InputDecoration(hintText: AppStrings.currentPasswordLabel),
          ),
          const SizedBox(height: DesignConstants.pM),
          TextField(
            controller: _newPwController,
            obscureText: true,
            decoration: const InputDecoration(hintText: AppStrings.newPasswordLabel),
          ),
          const SizedBox(height: DesignConstants.pL),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: actions.isLoading ? null : _submit,
              child: const Text(AppStrings.updatePassword),
            ),
          ),
          if (_message != null) ...[
            const SizedBox(height: DesignConstants.pS),
            Text(
              _message!,
              style: const TextStyle(
                color: DesignConstants.accent,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Danger Zone ─────────────────────────────────────────────────────────────

class _DangerZoneSection extends ConsumerStatefulWidget {
  const _DangerZoneSection();

  @override
  ConsumerState<_DangerZoneSection> createState() => _DangerZoneSectionState();
}

class _DangerZoneSectionState extends ConsumerState<_DangerZoneSection> {
  final _deletePasswordController = TextEditingController();

  @override
  void dispose() {
    _deletePasswordController.dispose();
    super.dispose();
  }

  Future<void> _deleteAccount() async {
    await ref.read(profileActionsProvider.notifier).deleteAccount(_deletePasswordController.text);

    if (mounted) {
      await TokenStorage.deleteToken();
      if (mounted) context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final actions = ref.watch(profileActionsProvider);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: DesignConstants.danger.withValues(alpha: 0.3)),
      ),
      child: GlassCard(
        padding: const EdgeInsets.all(DesignConstants.pL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionTitle(
              icon: Icons.warning_amber_rounded,
              title: AppStrings.dangerZone,
              color: DesignConstants.danger,
            ),
            const SizedBox(height: DesignConstants.pM),
            const Text(
              AppStrings.deleteAccountDesc,
              style: TextStyle(color: DesignConstants.textMuted, fontSize: 13),
            ),
            const SizedBox(height: DesignConstants.pL),
            TextField(
              controller: _deletePasswordController,
              obscureText: true,
              decoration: const InputDecoration(hintText: AppStrings.confirmPasswordHint),
            ),
            const SizedBox(height: DesignConstants.pL),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: actions.isLoading ? null : _deleteAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: DesignConstants.danger,
                  foregroundColor: Colors.white,
                ),
                child: const Text(AppStrings.deleteAccount),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Shared Components ───────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.icon,
    required this.title,
    this.color = DesignConstants.secondary,
  });

  final IconData icon;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: DesignConstants.pM),
        Text(
          title,
          style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}
