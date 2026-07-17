import 'package:equatable/equatable.dart';

/// Domain-level representation of the signed-in user. Presentation code
/// depends on this, never on [UserModel] or `firebase_auth`'s `User`
/// directly, so the auth backend can be swapped without touching the UI.
class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.isChildMode = false,
    this.currency = 'USD',
    required this.createdAt,
  });

  final String id;
  final String email;
  final String displayName;
  final String? photoUrl;

  /// True when the account was created via "Kid mode" (anonymous auth) —
  /// gates access to parent-only screens like data export/account deletion.
  final bool isChildMode;
  final String currency;
  final DateTime createdAt;

  UserEntity copyWith({
    String? displayName,
    String? photoUrl,
    String? currency,
  }) {
    return UserEntity(
      id: id,
      email: email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      isChildMode: isChildMode,
      currency: currency ?? this.currency,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [id, email, displayName, photoUrl, isChildMode, currency, createdAt];
}
