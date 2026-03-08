import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontend/features/wallet/repositories/wallet_repository.dart';

final Provider<WalletRepository> walletRepositoryProvider = Provider((ref) => WalletRepository());

final FutureProvider<int> walletBalanceProvider = FutureProvider.autoDispose<int>((ref) async {
  final repository = ref.watch(walletRepositoryProvider);
  return repository.getBalance();
});
