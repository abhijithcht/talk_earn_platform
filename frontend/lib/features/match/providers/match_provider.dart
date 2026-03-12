import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/match/repositories/match_repository.dart';

/// Possible match states.
enum MatchStatus { idle, searching, matched, error }

/// State for the match feature.
class MatchState {
  const MatchState({
    this.status = MatchStatus.idle,
    this.medium,
    this.matchData,
    this.errorMessage,
  });

  final MatchStatus status;
  final String? medium;
  final Map<String, dynamic>? matchData;
  final String? errorMessage;

  MatchState copyWith({
    MatchStatus? status,
    String? medium,
    Map<String, dynamic>? matchData,
    String? errorMessage,
  }) {
    return MatchState(
      status: status ?? this.status,
      medium: medium ?? this.medium,
      matchData: matchData ?? this.matchData,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class MatchNotifier extends Notifier<MatchState> {
  @override
  MatchState build() => const MatchState();

  Future<void> findMatch(String medium) async {
    state = MatchState(status: MatchStatus.searching, medium: medium);
    try {
      final data = await ref.read(matchRepositoryProvider).findMatch(medium);
      state = MatchState(
        status: MatchStatus.matched,
        medium: medium,
        matchData: data,
      );
    } catch (e) {
      state = MatchState(
        status: MatchStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> cancelMatch() async {
    try {
      await ref.read(matchRepositoryProvider).cancelMatch();
    } catch (_) {
      // Silently handle — user already navigated away.
    }
    state = const MatchState();
  }

  void reset() => state = const MatchState();
}

final Provider<MatchRepository> matchRepositoryProvider = Provider(
  (ref) => MatchRepository(),
);

final NotifierProvider<MatchNotifier, MatchState> matchProvider =
    NotifierProvider<MatchNotifier, MatchState>(MatchNotifier.new);
