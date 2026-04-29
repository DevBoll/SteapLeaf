import 'package:sqflite/sqflite.dart';

import '../database_helper.dart';
import '../models/enums.dart';
import '../models/tea.dart';

class TeaDao {
  static const _table = DatabaseHelper.tblTea;

  Future<int> insert(DatabaseExecutor db, Tea tea) =>
      db.insert(_table, tea.toMap());

  Future<int> update(DatabaseExecutor db, Tea tea) {
    if (tea.id == null) {
      throw ArgumentError('Tea.id must not be null for update');
    }
    return db.update(_table, tea.toMap(),
        where: 'id = ?', whereArgs: [tea.id]);
  }

  Future<int> delete(DatabaseExecutor db, int id) =>
      db.delete(_table, where: 'id = ?', whereArgs: [id]);

  Future<Tea?> getById(DatabaseExecutor db, int id) async {
    final rows =
        await db.query(_table, where: 'id = ?', whereArgs: [id], limit: 1);
    return rows.isEmpty ? null : Tea.fromMap(rows.first);
  }

  Future<List<Tea>> getAll(
    DatabaseExecutor db, {
    bool? ownedOnly,
    bool? favoritesOnly,
    TeaType? type,
    String? search,
    String orderBy = 'name COLLATE NOCASE ASC',
  }) async {
    final whereParts = <String>[];
    final whereArgs = <Object?>[];

    if (ownedOnly == true) whereParts.add('isOwned = 1');
    if (favoritesOnly == true) whereParts.add('isFavorite = 1');
    if (type != null) {
      whereParts.add('type = ?');
      whereArgs.add(type.dbValue);
    }
    if (search != null && search.isNotEmpty) {
      whereParts.add('(name LIKE ? OR vendor LIKE ?)');
      final like = '%$search%';
      whereArgs..add(like)..add(like);
    }

    final rows = await db.query(
      _table,
      where: whereParts.isEmpty ? null : whereParts.join(' AND '),
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
      orderBy: orderBy,
    );
    return rows.map(Tea.fromMap).toList();
  }
}
