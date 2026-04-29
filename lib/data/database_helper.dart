import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'models/settings.dart';

/// Verwaltet Lifecycle und Schema der SQLite-Datenbank.
///
/// CRUD-Operationen leben in den DAOs, Geschäftslogik in den Repositories.
/// Diese Klasse stellt nur die `Database`-Instanz bereit.
class DatabaseHelper {
  static const String _dbName = 'tea_tracker.db';
  static const int _dbVersion = 1;

  // Tabellennamen — von DAOs konsumiert
  static const String tblTag = 'Tag';
  static const String tblFlavorProfile = 'FlavorProfile';
  static const String tblFlavorAromaTag = 'FlavorProfileAromaTag';
  static const String tblTea = 'Tea';
  static const String tblTeaTag = 'TeaTag';
  static const String tblBrewingParams = 'BrewingParameters';
  static const String tblBrewingStep = 'BrewingStep';
  static const String tblBrewingAdditive = 'BrewingAdditive';
  static const String tblBrewingVariant = 'BrewingVariant';
  static const String tblSession = 'Session';
  static const String tblInfusion = 'Infusion';
  static const String tblSettings = 'Settings';

  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  Database? _db;

  Future<Database> get database async {
    return _db ??= await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onConfigure: _onConfigure,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    final batch = db.batch();
    for (final stmt in _ddlStatements) {
      batch.execute(stmt);
    }
    await batch.commit(noResult: true);

    await db.insert(
      tblSettings,
      const Settings().toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Migrationen für künftige Versionen hier ergänzen.
  }

  Future<void> close() async {
    final db = _db;
    if (db != null) {
      await db.close();
      _db = null;
    }
  }

  Future<void> deleteDatabaseFile() async {
    await close();
    final dbPath = await getDatabasesPath();
    await deleteDatabase(join(dbPath, _dbName));
  }

  static const List<String> _ddlStatements = [
    '''
    CREATE TABLE Tag (
      id   INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL UNIQUE COLLATE NOCASE
    )
    ''',
    '''
    CREATE TABLE FlavorProfile (
      id           INTEGER PRIMARY KEY AUTOINCREMENT,
      floral       REAL CHECK (floral       BETWEEN 0 AND 10),
      fruity       REAL CHECK (fruity       BETWEEN 0 AND 10),
      vegetal      REAL CHECK (vegetal      BETWEEN 0 AND 10),
      spicy        REAL CHECK (spicy        BETWEEN 0 AND 10),
      earthy       REAL CHECK (earthy       BETWEEN 0 AND 10),
      roasted      REAL CHECK (roasted      BETWEEN 0 AND 10),
      herbal       REAL CHECK (herbal       BETWEEN 0 AND 10),
      sweet        REAL CHECK (sweet        BETWEEN 0 AND 10),
      sour         REAL CHECK (sour         BETWEEN 0 AND 10),
      bitter       REAL CHECK (bitter       BETWEEN 0 AND 10),
      umami        REAL CHECK (umami        BETWEEN 0 AND 10),
      salty        REAL CHECK (salty        BETWEEN 0 AND 10),
      body         REAL CHECK (body         BETWEEN 0 AND 10),
      texture      TEXT CHECK (texture IN (
                     'SMOOTH','SILKY','CREAMY','OILY','BUTTERY',
                     'THIN','WATERY','GRAINY','VELVETY','ASTRINGENT'
                   )),
      astringency  REAL CHECK (astringency  BETWEEN 0 AND 10),
      finishLength REAL CHECK (finishLength BETWEEN 0 AND 10)
    )
    ''',
    '''
    CREATE TABLE FlavorProfileAromaTag (
      id              INTEGER PRIMARY KEY AUTOINCREMENT,
      flavorProfileId INTEGER NOT NULL,
      aroma           TEXT    NOT NULL CHECK (aroma IN (
                          'FLORAL','FRUITY','VEGETAL','SPICY',
                          'EARTHY','ROASTED','HERBAL'
                      )),
      tag             TEXT    NOT NULL,
      FOREIGN KEY (flavorProfileId) REFERENCES FlavorProfile(id) ON DELETE CASCADE,
      UNIQUE (flavorProfileId, aroma, tag)
    )
    ''',
    'CREATE INDEX idx_flavor_aromatag_profile ON FlavorProfileAromaTag(flavorProfileId)',
    '''
    CREATE TABLE Tea (
      id              INTEGER PRIMARY KEY AUTOINCREMENT,
      name            TEXT    NOT NULL,
      type            TEXT,
      origin          TEXT,
      harvest         TEXT,
      vendor          TEXT,
      isOwned         INTEGER NOT NULL DEFAULT 0 CHECK (isOwned    IN (0,1)),
      isFavorite      INTEGER NOT NULL DEFAULT 0 CHECK (isFavorite IN (0,1)),
      teaPhotoPath    TEXT,
      labelPhotoPath  TEXT,
      notes           TEXT,
      rating          REAL    CHECK (rating BETWEEN 0 AND 5),
      flavorProfileId INTEGER UNIQUE,
      createdAt       TEXT    NOT NULL DEFAULT (datetime('now')),
      updatedAt       TEXT    NOT NULL DEFAULT (datetime('now')),
      FOREIGN KEY (flavorProfileId) REFERENCES FlavorProfile(id) ON DELETE SET NULL
    )
    ''',
    'CREATE INDEX idx_tea_isFavorite ON Tea(isFavorite)',
    'CREATE INDEX idx_tea_isOwned    ON Tea(isOwned)',
    'CREATE INDEX idx_tea_type       ON Tea(type)',
    '''
    CREATE TABLE TeaTag (
      teaId INTEGER NOT NULL,
      tagId INTEGER NOT NULL,
      PRIMARY KEY (teaId, tagId),
      FOREIGN KEY (teaId) REFERENCES Tea(id) ON DELETE CASCADE,
      FOREIGN KEY (tagId) REFERENCES Tag(id) ON DELETE CASCADE
    )
    ''',
    'CREATE INDEX idx_teatag_tag ON TeaTag(tagId)',
    '''
    CREATE TABLE BrewingParameters (
      id                  INTEGER PRIMARY KEY AUTOINCREMENT,
      teaGrams            REAL    CHECK (teaGrams >= 0),
      waterMl             REAL    CHECK (waterMl  >= 0),
      coldBrewLocation    TEXT    CHECK (coldBrewLocation IN (
                              'FRIDGE','ROOM_TEMPERATURE','OUTDOOR'
                          )),
      minColdSteepSeconds INTEGER CHECK (minColdSteepSeconds >= 0),
      maxColdSteepSeconds INTEGER CHECK (maxColdSteepSeconds >= 0),
      whiskSeconds        INTEGER CHECK (whiskSeconds >= 0),
      CHECK (
          minColdSteepSeconds IS NULL
          OR maxColdSteepSeconds IS NULL
          OR minColdSteepSeconds <= maxColdSteepSeconds
      )
    )
    ''',
    '''
    CREATE TABLE BrewingStep (
      id                  INTEGER PRIMARY KEY AUTOINCREMENT,
      brewingParametersId INTEGER NOT NULL,
      stepIndex           INTEGER NOT NULL,
      isRinse             INTEGER NOT NULL DEFAULT 0 CHECK (isRinse IN (0,1)),
      steepSeconds        INTEGER CHECK (steepSeconds       >= 0),
      temperatureCelsius  REAL    CHECK (temperatureCelsius BETWEEN 0 AND 100),
      FOREIGN KEY (brewingParametersId) REFERENCES BrewingParameters(id) ON DELETE CASCADE,
      UNIQUE (brewingParametersId, stepIndex)
    )
    ''',
    'CREATE INDEX idx_brewingstep_params ON BrewingStep(brewingParametersId)',
    '''
    CREATE TABLE BrewingAdditive (
      id                  INTEGER PRIMARY KEY AUTOINCREMENT,
      brewingParametersId INTEGER NOT NULL,
      name                TEXT NOT NULL,
      amount              TEXT,
      FOREIGN KEY (brewingParametersId) REFERENCES BrewingParameters(id) ON DELETE CASCADE
    )
    ''',
    'CREATE INDEX idx_brewingadditive_params ON BrewingAdditive(brewingParametersId)',
    '''
    CREATE TABLE BrewingVariant (
      id                  INTEGER PRIMARY KEY AUTOINCREMENT,
      teaId               INTEGER NOT NULL,
      name                TEXT    NOT NULL,
      brewingType         TEXT    NOT NULL CHECK (brewingType IN (
                              'WESTERN','GONGFU','GRANDPA',
                              'COLD_BREW','MATCHA','BOILED'
                          )),
      brewingParametersId INTEGER UNIQUE,
      isDefault           INTEGER NOT NULL DEFAULT 0 CHECK (isDefault IN (0,1)),
      notes               TEXT,
      FOREIGN KEY (teaId)               REFERENCES Tea(id)               ON DELETE CASCADE,
      FOREIGN KEY (brewingParametersId) REFERENCES BrewingParameters(id) ON DELETE SET NULL
    )
    ''',
    'CREATE INDEX idx_brewingvariant_tea ON BrewingVariant(teaId)',
    'CREATE UNIQUE INDEX idx_brewingvariant_one_default ON BrewingVariant(teaId) WHERE isDefault = 1',
    '''
    CREATE TABLE Session (
      id                  INTEGER PRIMARY KEY AUTOINCREMENT,
      timestamp           TEXT    NOT NULL DEFAULT (datetime('now')),
      sessionType         TEXT    NOT NULL CHECK (sessionType IN ('SIMPLE','TASTING')),
      sessionStatus       TEXT    NOT NULL DEFAULT 'PLANNED' CHECK (sessionStatus IN (
                              'PLANNED','IN_PROGRESS','COMPLETED','ABANDONED'
                          )),
      teaId               INTEGER,
      externalTeaName     TEXT,
      externalTeaType     TEXT,
      brewingVariantId    INTEGER,
      brewingParametersId INTEGER UNIQUE,
      rating              REAL    CHECK (rating BETWEEN 0 AND 5),
      notes               TEXT,
      flavorProfileId     INTEGER UNIQUE,
      isManual            INTEGER NOT NULL DEFAULT 0 CHECK (isManual IN (0,1)),
      start               TEXT,
      end                 TEXT,
      FOREIGN KEY (teaId)               REFERENCES Tea(id)               ON DELETE SET NULL,
      FOREIGN KEY (brewingVariantId)    REFERENCES BrewingVariant(id)    ON DELETE SET NULL,
      FOREIGN KEY (brewingParametersId) REFERENCES BrewingParameters(id) ON DELETE SET NULL,
      FOREIGN KEY (flavorProfileId)     REFERENCES FlavorProfile(id)     ON DELETE SET NULL,
      CHECK (teaId IS NOT NULL OR externalTeaName IS NOT NULL),
      CHECK (start IS NULL OR end IS NULL OR start <= end)
    )
    ''',
    'CREATE INDEX idx_session_tea       ON Session(teaId)',
    'CREATE INDEX idx_session_timestamp ON Session(timestamp)',
    'CREATE INDEX idx_session_status    ON Session(sessionStatus)',
    'CREATE INDEX idx_session_type      ON Session(sessionType)',
    '''
    CREATE TABLE Infusion (
      id              INTEGER PRIMARY KEY AUTOINCREMENT,
      sessionId       INTEGER NOT NULL,
      infusionIndex   INTEGER NOT NULL,
      isRinse         INTEGER NOT NULL DEFAULT 0 CHECK (isRinse IN (0,1)),
      steepSeconds    INTEGER CHECK (steepSeconds >= 0),
      start           TEXT,
      end             TEXT,
      rating          REAL    CHECK (rating BETWEEN 0 AND 5),
      notes           TEXT,
      flavorProfileId INTEGER UNIQUE,
      FOREIGN KEY (sessionId)       REFERENCES Session(id)       ON DELETE CASCADE,
      FOREIGN KEY (flavorProfileId) REFERENCES FlavorProfile(id) ON DELETE SET NULL,
      UNIQUE (sessionId, infusionIndex),
      CHECK (start IS NULL OR end IS NULL OR start <= end)
    )
    ''',
    'CREATE INDEX idx_infusion_session ON Infusion(sessionId)',
    '''
    CREATE TABLE Settings (
      id                    INTEGER PRIMARY KEY CHECK (id = 1),
      sessionTimeoutSeconds INTEGER NOT NULL DEFAULT 300,
      onboardingCompleted   INTEGER NOT NULL DEFAULT 0 CHECK (onboardingCompleted IN (0,1)),
      language              TEXT    NOT NULL DEFAULT 'en',
      themePreference       TEXT    NOT NULL DEFAULT 'SYSTEM' CHECK (themePreference IN (
                                'LIGHT','DARK','SYSTEM'
                            ))
    )
    ''',
    '''
    CREATE TRIGGER trg_tea_updated_at
    AFTER UPDATE OF name, type, origin, harvest, vendor, isOwned, isFavorite,
                    teaPhotoPath, labelPhotoPath, notes, rating, flavorProfileId
    ON Tea
    FOR EACH ROW
    BEGIN
        UPDATE Tea SET updatedAt = datetime('now') WHERE id = OLD.id;
    END
    ''',
  ];
}
