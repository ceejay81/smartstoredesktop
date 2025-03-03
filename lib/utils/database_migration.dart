import '../helpers/mysql_database_helper.dart';
import '../helpers/sqlite_database_helper.dart';

class DatabaseMigration {
  final MySqlDatabaseHelper mysqlHelper;
  final SqliteDatabaseHelper sqliteHelper;

  DatabaseMigration(this.mysqlHelper, this.sqliteHelper);

  Future<void> migrateData() async {
    // Migrate Users
    final users = await sqliteHelper.getAllUsers();
    final conn = await mysqlHelper.connection;
    
    for (var user in users) {
      await conn.query(
        'INSERT INTO Users (username, password_hash, role) VALUES (?, ?, ?)',
        [user['username'], user['password_hash'], user['role']]
      );
    }
    
    // Add similar migrations for other tables...
  }
}