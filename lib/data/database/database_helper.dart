import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../core/constants/app_constants.dart';

/// Database helper for SQLite operations
/// Handles database creation, versioning, and table management
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  /// Get database instance (singleton)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  /// Initialize database
  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConstants.databaseName);

    return await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  /// Create database tables
  Future<void> _createDB(Database db, int version) async {
    // Notes table
    await db.execute('''
      CREATE TABLE ${AppConstants.notesTable} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    // Tasks table
    await db.execute('''
      CREATE TABLE ${AppConstants.tasksTable} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        category TEXT NOT NULL,
        isCompleted INTEGER NOT NULL DEFAULT 0,
        createdAt TEXT NOT NULL,
        categoryColor TEXT NOT NULL
      )
    ''');
  }

  /// Handle database migrations
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Check if categoryColor column exists
      final tableInfo = await db.rawQuery(
        'PRAGMA table_info(${AppConstants.tasksTable})',
      );
      final hasCategoryColor = tableInfo.any(
        (column) => column['name'] == 'categoryColor',
      );

      if (!hasCategoryColor) {
        // Add categoryColor column to tasks table
        await db.execute('''
          ALTER TABLE ${AppConstants.tasksTable}
          ADD COLUMN categoryColor TEXT NOT NULL DEFAULT '#4A90E2'
        ''');
      }

      // Update existing tasks with default colors based on their category
      // This ensures all tasks have the correct color even if column already existed
      final tasks = await db.query(AppConstants.tasksTable);
      for (final task in tasks) {
        final category = task['category'] as String;
        String color;
        switch (category) {
          case 'personal':
            color = '#4A90E2';
            break;
          case 'work':
            color = '#F8B739';
            break;
          case 'school':
            color = '#8338EC';
            break;
          case 'other':
          default:
            color = '#87CEEB';
            break;
        }
        await db.update(
          AppConstants.tasksTable,
          {'categoryColor': color},
          where: 'id = ?',
          whereArgs: [task['id']],
        );
      }
    }

    if (oldVersion < 3) {
      // Remove category column from notes table if it exists (from old versions)
      try {
        final notesTableInfo = await db.rawQuery(
          'PRAGMA table_info(${AppConstants.notesTable})',
        );
        final hasCategory = notesTableInfo.any(
          (column) => column['name'] == 'category',
        );

        if (hasCategory) {
          // SQLite doesn't support DROP COLUMN directly, so we need to recreate the table
          // Create new table without category column
          await db.execute('''
            CREATE TABLE ${AppConstants.notesTable}_new (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT NOT NULL,
              content TEXT NOT NULL,
              createdAt TEXT NOT NULL
            )
          ''');

          // Copy data from old table to new table (excluding category)
          await db.execute('''
            INSERT INTO ${AppConstants.notesTable}_new (id, title, content, createdAt)
            SELECT id, title, content, createdAt
            FROM ${AppConstants.notesTable}
          ''');

          // Drop old table
          await db.execute('DROP TABLE ${AppConstants.notesTable}');

          // Rename new table to original name
          await db.execute('''
            ALTER TABLE ${AppConstants.notesTable}_new
            RENAME TO ${AppConstants.notesTable}
          ''');
        }
      } catch (e) {
        // If migration fails, try to continue - might be a fresh install
        print('Migration note: $e');
      }
    }
  }

  /// Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
