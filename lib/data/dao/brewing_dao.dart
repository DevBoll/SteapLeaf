import 'package:sqflite/sqflite.dart';

import '../database_helper.dart';
import '../models/brewing.dart';

class BrewingDao {
  static const _tblVariant = DatabaseHelper.tblBrewingVariant;
  static const _tblParams = DatabaseHelper.tblBrewingParams;
  static const _tblStep = DatabaseHelper.tblBrewingStep;
  static const _tblAdd = DatabaseHelper.tblBrewingAdditive;

  // ===================================================================
  // Parameters
  // ===================================================================

  Future<int> insertParameters(DatabaseExecutor db, BrewingParameters p) =>
      db.insert(_tblParams, p.toMap());

  Future<int> updateParameters(DatabaseExecutor db, BrewingParameters p) {
    if (p.id == null) {
      throw ArgumentError('BrewingParameters.id must not be null for update');
    }
    return db.update(_tblParams, p.toMap(),
        where: 'id = ?', whereArgs: [p.id]);
  }

  Future<int> deleteParameters(DatabaseExecutor db, int id) =>
      db.delete(_tblParams, where: 'id = ?', whereArgs: [id]);

  Future<BrewingParameters?> getParameters(DatabaseExecutor db, int id) async {
    final rows = await db.query(_tblParams,
        where: 'id = ?', whereArgs: [id], limit: 1);
    return rows.isEmpty ? null : BrewingParameters.fromMap(rows.first);
  }

  // ===================================================================
  // Steps
  // ===================================================================

  Future<int> insertStep(DatabaseExecutor db, BrewingStep step) =>
      db.insert(_tblStep, step.toMap());

  Future<int> deleteStep(DatabaseExecutor db, int id) =>
      db.delete(_tblStep, where: 'id = ?', whereArgs: [id]);

  Future<int> clearStepsForParameters(
          DatabaseExecutor db, int parametersId) =>
      db.delete(_tblStep,
          where: 'brewingParametersId = ?', whereArgs: [parametersId]);

  Future<List<BrewingStep>> getStepsForParameters(
      DatabaseExecutor db, int parametersId) async {
    final rows = await db.query(
      _tblStep,
      where: 'brewingParametersId = ?',
      whereArgs: [parametersId],
      orderBy: 'stepIndex ASC',
    );
    return rows.map(BrewingStep.fromMap).toList();
  }

  // ===================================================================
  // Additives
  // ===================================================================

  Future<int> insertAdditive(DatabaseExecutor db, BrewingAdditive additive) =>
      db.insert(_tblAdd, additive.toMap());

  Future<int> deleteAdditive(DatabaseExecutor db, int id) =>
      db.delete(_tblAdd, where: 'id = ?', whereArgs: [id]);

  Future<int> clearAdditivesForParameters(
          DatabaseExecutor db, int parametersId) =>
      db.delete(_tblAdd,
          where: 'brewingParametersId = ?', whereArgs: [parametersId]);

  Future<List<BrewingAdditive>> getAdditivesForParameters(
      DatabaseExecutor db, int parametersId) async {
    final rows = await db.query(
      _tblAdd,
      where: 'brewingParametersId = ?',
      whereArgs: [parametersId],
      orderBy: 'id ASC',
    );
    return rows.map(BrewingAdditive.fromMap).toList();
  }

  // ===================================================================
  // Variants
  // ===================================================================

  Future<int> insertVariant(DatabaseExecutor db, BrewingVariant variant) =>
      db.insert(_tblVariant, variant.toMap());

  Future<int> updateVariant(DatabaseExecutor db, BrewingVariant variant) {
    if (variant.id == null) {
      throw ArgumentError('BrewingVariant.id must not be null for update');
    }
    return db.update(_tblVariant, variant.toMap(),
        where: 'id = ?', whereArgs: [variant.id]);
  }

  Future<int> deleteVariant(DatabaseExecutor db, int id) =>
      db.delete(_tblVariant, where: 'id = ?', whereArgs: [id]);

  Future<BrewingVariant?> getVariant(DatabaseExecutor db, int id) async {
    final rows = await db.query(_tblVariant,
        where: 'id = ?', whereArgs: [id], limit: 1);
    return rows.isEmpty ? null : BrewingVariant.fromMap(rows.first);
  }

  Future<List<BrewingVariant>> getVariantsForTea(
      DatabaseExecutor db, int teaId) async {
    final rows = await db.query(
      _tblVariant,
      where: 'teaId = ?',
      whereArgs: [teaId],
      orderBy: 'isDefault DESC, name COLLATE NOCASE ASC',
    );
    return rows.map(BrewingVariant.fromMap).toList();
  }

  /// Setzt für einen Tee alle Default-Flags auf 0.
  /// (Wird vom Repository VOR dem Setzen einer neuen Default-Variante genutzt.)
  Future<int> clearDefaultsForTea(DatabaseExecutor db, int teaId) => db.update(
        _tblVariant,
        {'isDefault': 0},
        where: 'teaId = ? AND isDefault = 1',
        whereArgs: [teaId],
      );
}
