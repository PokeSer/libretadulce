import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../services/food_photo_service.dart';

/// Thumbnail that shows the food's photo when it exists and falls back
/// to the icon avatar otherwise.
///
/// Resolution order: full local photo (the device that took it), then the
/// mirrored thumbnail (local cache, fetched from Firestore once). The image
/// carries no semantics: the tile/dialog already announces the food's name.
class FoodPhotoThumbnail extends StatelessWidget {
  final String foodId;
  final String uid;
  final double size;
  final IconData fallbackIcon;
  final Color? fallbackIconColor;

  const FoodPhotoThumbnail({
    super.key,
    required this.foodId,
    required this.uid,
    this.size = 52,
    this.fallbackIcon = Icons.restaurant,
    this.fallbackIconColor,
  });

  Future<Uint8List?> _resolve() async {
    if (foodId.isEmpty) return null;
    final full = await FoodPhotoService.getPhoto(foodId);
    if (full != null) {
      try {
        return await full.readAsBytes();
      } catch (_) {
        return null;
      }
    }
    return FoodPhotoService.resolveThumb(uid, foodId);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.23),
      child: SizedBox(
        width: size,
        height: size,
        child: FutureBuilder<Uint8List?>(
          future: _resolve(),
          builder: (context, snapshot) {
            final bytes = snapshot.data;
            if (bytes != null) {
              return ExcludeSemantics(
                child: Image.memory(
                  bytes,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                  errorBuilder: (_, _, _) => _fallback(context),
                ),
              );
            }
            return _fallback(context);
          },
        ),
      ),
    );
  }

  Widget _fallback(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      color: scheme.surfaceContainerHigh,
      alignment: Alignment.center,
      child: Icon(
        fallbackIcon,
        size: size * 0.44,
        color: fallbackIconColor ?? AppColors.textMuted(context),
      ),
    );
  }
}
