import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Avatar used in the app bar, Profile, and chat bubbles. Falls back to a
/// friendly initial on a brand-colored circle when there's no photo (kid
/// accounts rarely have one).
class AppAvatar extends StatelessWidget {
  const AppAvatar({super.key, this.photoUrl, required this.name, this.radius = 20});

  final String? photoUrl;
  final String name;
  final double radius;

  @override
  Widget build(BuildContext context) {
    if (photoUrl != null && photoUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.primaryContainer,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: photoUrl!,
            width: radius * 2,
            height: radius * 2,
            fit: BoxFit.cover,
            errorWidget: (_, _, _) => _initial(),
          ),
        ),
      );
    }
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primary,
      child: _initial(),
    );
  }

  Widget _initial() {
    final letter = name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();
    return Text(
      letter,
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: radius * 0.8),
    );
  }
}
