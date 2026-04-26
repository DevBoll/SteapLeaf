import 'dart:io';
import 'package:flutter/material.dart';
import '../models/tea.dart';
import 'package:steapleaf/theme/steapleaf_theme.dart';

/// Rundes Tee-Thumbnail — einziges rundes Element der App.
///
/// Zeigt das Tee-Foto oder einen farbigen Kreisplatzhalter mit
/// Kanji-Zeichen der Teesorte. Sobald Asset-Grafiken verfügbar sind,
/// kann der Placeholder-Child durch ein [Image.asset] ersetzt werden.
class TeaThumb extends StatelessWidget {
  final Tea tea;
  final double size;

  const TeaThumb({
    super.key,
    required this.tea,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final hasPhoto = tea.teaPhotoPath != null;

    return CircleAvatar(
      radius: size / 2,
      backgroundColor: tea.type.colors.container,
      backgroundImage: hasPhoto ? FileImage(File(tea.teaPhotoPath!)) : null,
      onBackgroundImageError: hasPhoto ? (_, _) {} : null,
      child: hasPhoto
          ? null
          : Text(
              tea.type.kanji,
              style: textTheme.titleLarge?.copyWith(
                fontSize: size * 0.40,
                color: tea.type.colors.onContainer,
                fontWeight: FontWeight.w400,
                height: 1.0,
              ),
            ),
    );
  }
}
