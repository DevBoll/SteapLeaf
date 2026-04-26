import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Zentrale SQLite-Anbindung. Singleton.
///
/// Aufruf vor dem ersten Zugriff (üblicherweise in `main`):
/// ```dart
/// final db = await DatabaseHelper.instance.database;
/// ```
class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static const _dbName = 'tea_app.db';
  static const _dbVersion = 1;

  Database? _db;

  Future<Database> get database async {
    return _db ??= await _open();
  }

  Future<Database> _open() async {
    final path = p.join(await getDatabasesPath(), _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onConfigure: _onConfigure,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onConfigure(Database db) async {
    // Foreign-Keys müssen pro Connection eingeschaltet werden.
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    final batch = db.batch();
    for (final stmt in _schema) {
      batch.execute(stmt);
    }
    await batch.commit(noResult: true);
  }

  Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    // Hier künftige Migrationen ergänzen, z. B.:
    // if (oldVersion < 2) {
    //   await db.execute('ALTER TABLE teas ADD COLUMN ...');
    // }
  }

  /// Nur für Tests / Reset.
  Future<void> close() async {
    await _db?.close();
    _db = null;
  }

  /// Komplettes Schema (DDL). Reihenfolge ist wichtig wegen FK-Referenzen.
  static const List<String> _schema = [
    // ---------- Master-Tag-Tabellen ----------
    '''
    CREATE TABLE tea_tags (
      id   TEXT PRIMARY KEY,
      name TEXT NOT NULL UNIQUE
    )
    ''',
    '''
    CREATE TABLE aroma_tags (
      id       TEXT PRIMARY KEY,
      name     TEXT NOT NULL,
      category TEXT NOT NULL,
      UNIQUE (name, category)
    )
    ''',
    '''
    CREATE TABLE texture_tags (
      id   TEXT PRIMARY KEY,
      name TEXT NOT NULL UNIQUE
    )
    ''',

    // ---------- Tea ----------
    '''
    CREATE TABLE teas (
      id                TEXT PRIMARY KEY,
      name              TEXT NOT NULL,
      type              TEXT NOT NULL,
      origin            TEXT,
      harvest           TEXT,
      vendor            TEXT,
      is_owned          INTEGER NOT NULL DEFAULT 0,
      is_favorite       INTEGER NOT NULL DEFAULT 0,
      tea_photo_path    TEXT,
      label_photo_path  TEXT,
      notes             TEXT,
      rating            INTEGER NOT NULL DEFAULT 0
                        CHECK (rating BETWEEN 0 AND 5),
      flavor_profile    TEXT NOT NULL DEFAULT '{}',
      created_at        TEXT NOT NULL,
      updated_at        TEXT NOT NULL
    )
    ''',
    '''
    CREATE TABLE tea_tea_tags (
      tea_id TEXT NOT NULL,
      tag_id TEXT NOT NULL,
      PRIMARY KEY (tea_id, tag_id),
      FOREIGN KEY (tea_id) REFERENCES teas(id)     ON DELETE CASCADE,
      FOREIGN KEY (tag_id) REFERENCES tea_tags(id) ON DELETE CASCADE
    )
    ''',

    // ---------- BrewingVariant ----------
    '''
    CREATE TABLE brewing_variants (
      id            TEXT PRIMARY KEY,
      tea_id        TEXT NOT NULL,
      name          TEXT NOT NULL,
      brewing_type  TEXT NOT NULL,
      parameters    TEXT NOT NULL,
      is_default    INTEGER NOT NULL DEFAULT 0,
      notes         TEXT,
      FOREIGN KEY (tea_id) REFERENCES teas(id) ON DELETE CASCADE
    )
    ''',

    // ---------- Session ----------
    '''
    CREATE TABLE sessions (
      id                  TEXT PRIMARY KEY,
      date_time           TEXT NOT NULL,
      session_type        TEXT NOT NULL,
      tea_id              TEXT,
      brewing_variant_id  TEXT,
      external_tea_name   TEXT,
      external_tea_type   TEXT,
      status              TEXT NOT NULL,
      brewing_type        TEXT NOT NULL,
      brewing_parameters  TEXT NOT NULL,
      rating              INTEGER NOT NULL DEFAULT 0
                          CHECK (rating BETWEEN 0 AND 5),
      notes               TEXT,
      flavor_profile      TEXT NOT NULL DEFAULT '{}',
      is_manual           INTEGER NOT NULL DEFAULT 0,
      start_time          TEXT NOT NULL,
      end_time            TEXT,
      FOREIGN KEY (tea_id)
        REFERENCES teas(id) ON DELETE SET NULL,
      FOREIGN KEY (brewing_variant_id)
        REFERENCES brewing_variants(id) ON DELETE SET NULL
    )
    ''',

    // ---------- Infusion ----------
    '''
    CREATE TABLE infusions (
      id              TEXT PRIMARY KEY,
      session_id      TEXT NOT NULL,
      idx             INTEGER NOT NULL,
      type            TEXT NOT NULL,
      steep_seconds   INTEGER NOT NULL,
      start_time      TEXT NOT NULL,
      end_time        TEXT,
      rating          INTEGER NOT NULL DEFAULT 0
                      CHECK (rating BETWEEN 0 AND 5),
      notes           TEXT,
      flavor_profile  TEXT NOT NULL DEFAULT '{}',
      UNIQUE (session_id, idx),
      FOREIGN KEY (session_id) REFERENCES sessions(id) ON DELETE CASCADE
    )
    ''',

    // ---------- AppSettings ----------
    '''
    CREATE TABLE app_settings (
      id                       INTEGER PRIMARY KEY CHECK (id = 1),
      session_timeout_minutes  INTEGER NOT NULL DEFAULT 5,
      onboarding_completed     INTEGER NOT NULL DEFAULT 0
    )
    ''',
    "INSERT INTO app_settings (id) VALUES (1)",

    // ---------- Indizes ----------
    'CREATE INDEX idx_brewing_variants_tea_id ON brewing_variants (tea_id)',
    'CREATE INDEX idx_sessions_tea_id         ON sessions (tea_id)',
    'CREATE INDEX idx_sessions_status         ON sessions (status)',
    'CREATE INDEX idx_sessions_date_time      ON sessions (date_time DESC)',
    'CREATE INDEX idx_infusions_session_id    ON infusions (session_id)',
    'CREATE INDEX idx_tea_tea_tags_tag_id     ON tea_tea_tags (tag_id)',
  ];
}
