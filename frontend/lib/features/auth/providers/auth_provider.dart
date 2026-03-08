import 'package:frontend/core/api/token_storage.dart';
import 'package:frontend/features/auth/models/user.dart';
import 'package:frontend/features/auth/repositories/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  final _repository = AuthRepository();

  @override
  FutureOr<User?> build() async {
    // Check if we have a token on startup
    final token = await TokenStorage.getToken();
    if (token == null) return null;

    // Load user profile if we have a token
    try {
      return await _repository.getCurrentUser();
    } catch (e) {
      // Token might be invalid/expired, clear it
      await TokenStorage.deleteToken();
      return null;
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await _repository.login(email, password);
      final user = await _repository.getCurrentUser();
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    required String gender,
    required String genderPreference,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repository.register(
        email: email,
        password: password,
        fullName: fullName,
        gender: gender,
        genderPreference: genderPreference,
      );
      // After registration, user needs to verify OTP. We don't log them in yet.
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> verifyEmail(String email, String otp) async {
    state = const AsyncValue.loading();
    try {
      await _repository.verifyEmail(email, otp);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AsyncValue.data(null);
  }
}
