import 'package:sqflite/sqflite.dart';

import '../database_helper.dart';
import '../models/flavor_profile.dart';

class FlavorProfileDao {
  static const _table = DatabaseHelper.tblFlavorProfile;
  static const _aromaTagTable = DatabaseHelper.tblFlavorAromaTag;

  Future<int> insert(DatabaseExecutor db, FlavorProfile p) =>
      db.insert(_table, p.toMap());

  Future<int> update(DatabaseExecutor db, FlavorProfile p) {
    if (p.id == null) {
      throw ArgumentError('FlavorProfile.id must not be null for update');
    }
    return db
        .update(_table, p.toMap(), where: 'id = ?', whereArgs: [p.id]);
  }

  Future<int> delete(DatabaseExecutor db, int id) =>
      db.delete(_table, where: 'id = ?', whereArgs: [id]);

  Future<FlavorProfile?> getById(DatabaseExecutor db, int id) async {
    final rows = await db
        .query(_table, where: 'id = ?', whereArgs: [id], limit: 1);
    return rows.isEmpty ? null : FlavorProfile.fromMap(rows.first);
  }

  // --- AromaTags ---------------------------------------------------------

  Future<List<FlavorProfileAromaTag>> getAromaTagsForProfile(
      DatabaseExecutor db, int flavorProfileId) async {
    final rows = await db.query(
      _aromaTagTable,
      where: 'flavorProfileId = ?',
      whereArgs: [flavorProfileId],
      orderBy: 'aroma, tag COLLATE NOCASE ASC',
    );
    return rows.map(FlavorProfileAromaTag.fromMap).toList();
  }

  Future<int> insertAromaTag(
          DatabaseExecutor db, FlavorProfileAromaTag tag) =>
      db.insert(_aromaTagTable, tag.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore);

  Future<int> deleteAromaTag(DatabaseExecutor db, int id) =>
      db.delete(_aromaTagTable, where: 'id = ?', whereArgs: [id]);

  Future<int> clearAromaTagsForProfile(
          DatabaseExecutor db, int flavorProfileId) =>
      db.delete(_aromaTagTable,
          where: 'flavorProfileId = ?', whereArgs: [flavorProfileId]);
}
