import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/auth/models/user.dart';
import 'package:frontend/features/profile/repositories/profile_repository.dart';

final Provider<ProfileRepository> profileRepositoryProvider = Provider(
  (ref) => ProfileRepository(),
);

final FutureProvider<User> profileProvider = FutureProvider.autoDispose((ref) async {
  final repository = ref.watch(profileRepositoryProvider);
  return repository.getProfile();
});

/// Notifier for profile mutation actions (update, password, delete).
class ProfileActionsNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData<void>(null);

  Future<void> updateProfile(Map<String, dynamic> updates) async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(() async {
      await ref.read(profileRepositoryProvider).updateProfile(updates);
      ref.invalidate(profileProvider);
    });
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(() async {
      await ref
          .read(profileRepositoryProvider)
          .changePassword(currentPassword: currentPassword, newPassword: newPassword);
    });
  }

  Future<void> deleteAccount(String currentPassword) async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(() async {
      await ref.read(profileRepositoryProvider).deleteAccount(currentPassword);
    });
  }
}

final NotifierProvider<ProfileActionsNotifier, AsyncValue<void>> profileActionsProvider =
    NotifierProvider<ProfileActionsNotifier, AsyncValue<void>>(ProfileActionsNotifier.new);
