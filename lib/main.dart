import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'app.dart';
import 'core/database/database_helper.dart';

/// Startet die SteapLeaf-App.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('de', null);

  if (!kIsWeb &&
      defaultTargetPlatform != TargetPlatform.android &&
      defaultTargetPlatform != TargetPlatform.iOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  final db = await DatabaseHelper.instance.database;
  runApp(SteapLeafApp(db: db));
}
