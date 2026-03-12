class ApiEndpoints {
  ApiEndpoints._();

  // ──── Auth ────
  static const String login = '/auth/token';
  static const String register = '/auth/register';
  static const String verifyEmail = '/auth/verify-email';

  // ──── Profile ────
  static const String profileMe = '/profile/me';
  static const String profileUpdate = '/profile/update';
  static const String profilePicture = '/profile/picture';
  static const String profileChangePassword = '/profile/change-password';
  static const String profileDeleteAccount = '/profile/delete-account';
  static const String profileAvatars = '/profile/avatars';

  // ──── Wallet ────
  static const String walletBalance = '/wallet/balance';
  static const String walletWithdraw = '/wallet/withdraw';
  static const String walletEarn = '/wallet/earn';

  // ──── Match ────
  static const String matchFind = '/match/find';
  static const String matchCancel = '/match/cancel';

  // ──── Rating ────
  static const String ratingSubmit = '/rating/submit';
}
