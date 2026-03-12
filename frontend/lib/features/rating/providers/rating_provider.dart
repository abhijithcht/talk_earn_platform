import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/rating/repositories/rating_repository.dart';

final Provider<RatingRepository> ratingRepositoryProvider = Provider(
  (ref) => RatingRepository(),
);

class RatingNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData<void>(null);

  Future<void> submitRating({
    required int ratedUserId,
    required int score,
  }) async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(() async {
      await ref.read(ratingRepositoryProvider).submitRating(
            ratedUserId: ratedUserId,
            score: score,
          );
    });
  }
}

final NotifierProvider<RatingNotifier, AsyncValue<void>> ratingProvider =
    NotifierProvider<RatingNotifier, AsyncValue<void>>(RatingNotifier.new);
