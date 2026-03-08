import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/auth/models/user.dart';

import 'package:frontend/features/profile/repositories/profile_repository.dart';

final Provider<ProfileRepository> profileRepositoryProvider = Provider(
  (ref) => ProfileRepository(),
);

final FutureProvider<User> profileProvider = FutureProvider.autoDispose((ref) async {
  // If we already have the user in authProvider, we could just return it.
  // But fetching from the profile endpoint ensures it's up to date.
  final repository = ref.watch(profileRepositoryProvider);
  return repository.getProfile();
});
