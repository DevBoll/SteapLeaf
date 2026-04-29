import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'data/database_helper.dart';


import 'provider/session_provider.dart';
import 'provider/settings_provider.dart';
import 'provider/tea_provider.dart';
import 'theme/steapleaf_theme.dart';
import 'data/dao/brewing_dao.dart';
import 'data/dao/flavor_profile_dao.dart';
import 'data/dao/session_dao.dart';
import 'data/dao/settings_dao.dart';
import 'data/dao/tag_dao.dart';
import 'data/dao/tea_dao.dart';
import 'data/repositories/session_repository.dart';
import 'data/repositories/settings_repository.dart';
import 'data/repositories/tea_repository.dart';
import 'main_shell.dart';

class SteapLeafApp extends StatelessWidget {
  SteapLeafApp({super.key, required this.dbHelper});

  final DatabaseHelper dbHelper;

   // DAOs (stateless — eine Instanz pro DAO genügt)
  final tagDao = TagDao();
  final teaDao = TeaDao();
  final flavorProfileDao = FlavorProfileDao();
  final brewingDao = BrewingDao();
  final sessionDao = SessionDao();
  final settingsDao = SettingsDao();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TeaProvider(
            TeaRepository( helper: dbHelper, teaDao: teaDao, tagDao: tagDao, profileDao: flavorProfileDao, brewingDao: brewingDao),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => SessionProvider(
            SessionRepository(helper: dbHelper, sessionDao: sessionDao, brewingDao: brewingDao, profileDao: flavorProfileDao),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(
            SettingsRepository(helper: dbHelper, dao: settingsDao),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'SteapLeaf',
        debugShowCheckedModeBanner: false,
        theme: SteapLeafTheme.light,
        darkTheme: SteapLeafTheme.dark,
        themeMode: ThemeMode.system,
        home: const MainShell(),
      ),
    );
  }
}
