part of epub_shelf.api;

class Shelf {
  static String _dbPath;
  static Database _db;

  Shelf._();

  String get dbPath => _dbPath;
  Database get db => _db;

  static Future<void> initialize() async {
    final basePath = await getDatabasesPath();
    _dbPath = "$basePath/shelf.db";
    _db = await openDatabase(
      _dbPath,
      version: _DB_VERSION,
      onCreate: _createTables,
      onUpgrade: _migrate,
    );
    logd("db: $_dbPath");
  }

  static const TABLES = {
    1: {
      'books': {
        'id': 'TEXT PRIMARY KEY',
        'cover': 'BLOB',
        'meta': 'TEXT',
        'user_data': 'TEXT',
        'updated_at': 'INTEGER',
      },
    },
  };

  static void _createTables(Database db, int version) async {
    final tables = TABLES[version];
    for (var tableName in tables.keys) {
      final columns =
          tables[tableName].entries.map((p) => '${p.key} ${p.value}');
      await db.execute('CREATE TABLE $tableName (${columns.join(', ')})');
    }
  }

  static void _migrate(Database db, int oldVersion, int newVersion) {}
  static const _DB_VERSION = 1;
}
