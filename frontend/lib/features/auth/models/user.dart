import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required int id,
    required String email,
    String? fullName,
    @Default('') String username,
    String? gender,
    @Default('any') String genderPreference,
    @Default(false) bool isVerified,
    @Default('unverified') String verificationStatus,
    @Default(true) bool isActive,
    @Default(0) int warnings,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
