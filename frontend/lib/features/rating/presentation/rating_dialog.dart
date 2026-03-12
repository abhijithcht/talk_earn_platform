import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_strings.dart';
import 'package:frontend/core/theme/design_constants.dart';
import 'package:frontend/core/widgets/glass_card.dart';
import 'package:frontend/features/rating/providers/rating_provider.dart';

/// Shows the post-session rating dialog.
Future<void> showRatingDialog(BuildContext context, {required int ratedUserId}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _RatingDialog(ratedUserId: ratedUserId),
  );
}

class _RatingDialog extends ConsumerStatefulWidget {
  const _RatingDialog({required this.ratedUserId});
  final int ratedUserId;

  @override
  ConsumerState<_RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends ConsumerState<_RatingDialog> {
  int _selectedRating = 0;

  Future<void> _submit() async {
    if (_selectedRating == 0) return;

    await ref
        .read(ratingProvider.notifier)
        .submitRating(ratedUserId: widget.ratedUserId, score: _selectedRating);

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final ratingState = ref.watch(ratingProvider);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: GlassCard(
        padding: const EdgeInsets.all(DesignConstants.pXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => DesignConstants.textGradient.createShader(
                Rect.fromLTWH(0, 0, bounds.width, bounds.height),
              ),
              child: const Text(
                AppStrings.rateSession,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white),
              ),
            ),
            const SizedBox(height: DesignConstants.pM),
            const Text(
              AppStrings.rateSessionDesc,
              textAlign: TextAlign.center,
              style: TextStyle(color: DesignConstants.textMuted, fontSize: 14),
            ),
            const SizedBox(height: DesignConstants.pXL),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final starValue = index + 1;
                return GestureDetector(
                  onTap: () => setState(() => _selectedRating = starValue),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(
                      starValue <= _selectedRating
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      size: 44,
                      color: starValue <= _selectedRating
                          ? Colors.amber
                          : DesignConstants.textMuted,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: DesignConstants.pXL),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedRating > 0 && !ratingState.isLoading ? _submit : null,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: ratingState.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text(AppStrings.submitFeedback),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
