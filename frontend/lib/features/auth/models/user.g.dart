// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: (json['id'] as num).toInt(),
  email: json['email'] as String,
  fullName: json['fullName'] as String?,
  username: json['username'] as String? ?? '',
  gender: json['gender'] as String?,
  genderPreference: json['genderPreference'] as String? ?? 'any',
  isVerified: json['isVerified'] as bool? ?? false,
  verificationStatus: json['verificationStatus'] as String? ?? 'unverified',
  isActive: json['isActive'] as bool? ?? true,
  warnings: (json['warnings'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'fullName': instance.fullName,
  'username': instance.username,
  'gender': instance.gender,
  'genderPreference': instance.genderPreference,
  'isVerified': instance.isVerified,
  'verificationStatus': instance.verificationStatus,
  'isActive': instance.isActive,
  'warnings': instance.warnings,
};
