import '../helpers/mysql_database_helper.dart';
import '../config/database_config.dart';
import '../utils/database_exception.dart';  // Add this import

Future<void> testDatabaseConnection() async {
  final dbHelper = MySqlDatabaseHelper();
  try {
    print('1. Testing connection to ${DatabaseConfig.host}:${DatabaseConfig.port}...');
    final conn = await dbHelper.connection;
    print('✓ Connection established\n');

    print('2. Verifying database existence...');
    print('✓ Database "${DatabaseConfig.database}" accessible\n');

    print('3. Checking required tables...');
    final tables = await dbHelper.getExistingTables();
    if (tables.isEmpty) {
      throw DatabaseException('No tables found in database');
    }
    print('Found tables: ${tables.join(", ")}\n');

    print('4. Verifying table schemas...');
    final schemas = await dbHelper.getRequiredTableSchemas();
    for (var table in schemas.keys) {
      final tableColumns = await dbHelper.getTableColumns(table);
      final expectedColumns = schemas[table]!;
      print('\nChecking $table:');
      print('  Expected columns: ${expectedColumns.join(", ")}');
      print('  Actual columns: ${tableColumns.keys.join(", ")}');
      
      final missingColumns = expectedColumns.where(
        (col) => !tableColumns.containsKey(col.toLowerCase())
      ).toList();
      
      if (missingColumns.isNotEmpty) {
        throw DatabaseException(
          'Table $table is missing columns: ${missingColumns.join(", ")}'
        );
      }
      print('  ✓ Schema verified');
    }

    print('\n✓ All database checks passed');
  } catch (e) {
    print('\n✗ Database verification failed:');
    print(e.toString());
    rethrow;
  } finally {
    await dbHelper.closeConnection();
  }
}

Future<void> runAllTests() async {
  print('Starting database tests...\n');
  await testDatabaseConnection();
  
  // Add more test functions here as needed
  print('\nTests completed.');
}

void main() async {
  print('Running database tests...');
  await runAllTests();
}