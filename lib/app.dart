import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import 'core/dao/aroma_tag_dao.dart';
import 'core/dao/app_settings_dao.dart';
import 'core/dao/brewing_variant_dao.dart';
import 'core/dao/infusion_dao.dart';
import 'core/dao/session_dao.dart';
import 'core/dao/tea_dao.dart';
import 'core/dao/tea_tag_dao.dart';
import 'core/dao/texture_tag_dao.dart';

import 'core/repositories/session_repository.dart';
import 'core/repositories/settings_repository.dart';
import 'core/repositories/tag_repository.dart';
import 'core/repositories/tea_repository.dart';

import 'core/providers/session_provider.dart';
import 'core/providers/settings_provider.dart';
import 'core/providers/tag_provider.dart';
import 'core/providers/tea_provider.dart';

import 'package:steapleaf/theme/steapleaf_theme.dart';

class SteapLeafApp extends StatelessWidget {
  const SteapLeafApp({super.key, required this.db});

  final Database db;

  @override
  Widget build(BuildContext context) {
    final teaDao = TeaDao(db);
    final variantDao = BrewingVariantDao(db);
    final teaTagDao = TeaTagDao(db);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TeaProvider(
            TeaRepository(teaDao, variantDao, teaTagDao),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => SessionProvider(
            SessionRepository(SessionDao(db), InfusionDao(db), variantDao),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => TagProvider(
            TagRepository(teaTagDao, AromaTagDao(db), TextureTagDao(db)),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(
            SettingsRepository(AppSettingsDao(db)),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'SteapLeaf',
        debugShowCheckedModeBanner: false,
        theme: SteapLeafTheme.light,
        darkTheme: SteapLeafTheme.dark,
        themeMode: ThemeMode.system,
        home: const Scaffold(),
      ),
    );
  }
}
