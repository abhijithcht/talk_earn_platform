class ApiEndpoints {
  ApiEndpoints._();

  // ──── Auth ────
  static const String login = '/auth/token';
  static const String register = '/auth/register';
  static const String verifyEmail = '/auth/verify-email';

  // ──── Profile ────
  static const String profileMe = '/profile/me';
  static const String profileUpdate = '/profile/update';

  // ──── Wallet ────
  static const String walletBalance = '/wallet/balance';
  static const String walletWithdraw = '/wallet/withdraw';
}
