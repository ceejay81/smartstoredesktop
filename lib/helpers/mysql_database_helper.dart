import 'package:mysql1/mysql1.dart';
import '../config/database_config.dart';
import '../utils/password_hasher.dart';
import '../utils/database_exception.dart';
import '../helpers/mysql_database_helper.dart';

class MySqlDatabaseHelper {
    MySqlConnection? _connection;
    
    Future<MySqlConnection> get connection async {
        if (_connection == null) {
            try {
                final settings = ConnectionSettings(
                    host: DatabaseConfig.host,
                    port: DatabaseConfig.port,
                    user: DatabaseConfig.user,
                    password: DatabaseConfig.password,
                    db: DatabaseConfig.database,
                    useSSL: DatabaseConfig.useSSL,
                    timeout: Duration(seconds: DatabaseConfig.connectionTimeoutInSeconds),
                );
                _connection = await MySqlConnection.connect(settings);
            } catch (e) {
                throw DatabaseException(
                    'Could not connect to database. Is XAMPP running?\nError: ${e.toString()}'
                );
            }
        }
        return _connection!;
    }

    // Add a method to get table schemas for verification
    Future<Map<String, List<String>>> getRequiredTableSchemas() async {
        return Future.value({
            'users': [
                'id',
                'name',
                'email',
                'password',
                'role',
                'created_at',
                'updated_at'
            ],
            'products': [
                'id',
                'barcode',
                'name',
                'description',
                'cost_price',
                'sale_price',
                'stock_quantity',
                'reorder_level',
                'stock',
                'created_at',
                'updated_at'
            ],
            'sales': [
                'id',
                'sale_datetime',
                'total_amount',
                'user_id',
                'payment_method',
                'receipt_printed_at',
                'created_at',
                'updated_at'
            ],
            'sale_items': [
                'sale_item_id',
                'sale_id',
                'product_id',
                'quantity',
                'sale_price',
                'created_at',
                'updated_at'
            ],
            'expenses': [
                'expense_id',
                'expense_date',
                'description',
                'amount',
                'category',
                'created_at',
                'updated_at'
            ],
            'stock_alerts': [
                'alert_id',
                'product_id',
                'alert_date',
                'message',
                'acknowledged',
                'created_at',
                'updated_at'
            ]
        });
    }

    Future<bool> checkUserExists(String email) async {
        final conn = await connection;
        var results = await conn.query(
            'SELECT COUNT(*) as count FROM users WHERE email = ?',
            [email]
        );
        return results.first['count'] > 0;
    }

    Future<void> registerUser(String name, String email, String passwordHash) async {
        try {
            final conn = await connection;
            await conn.query(
                '''INSERT INTO users 
                   (name, email, password, role, created_at, updated_at) 
                   VALUES (?, ?, ?, ?, NOW(), NOW())''',
                [name, email, passwordHash, 'Cashier'] // Default role as Cashier
            );
        } catch (e) {
            if (e.toString().contains('users_email_unique')) {
                throw DatabaseException('Email already exists');
            }
            if (e.toString().contains('users_name_unique')) {
                throw DatabaseException('Username already exists');
            }
            throw DatabaseException('Registration failed: ${e.toString()}');
        }
    }

    Future<Map<String, dynamic>?> loginUser(String email, String password) async {
        try {
            final conn = await connection;
            var results = await conn.query(
                'SELECT id, name, email, password, role FROM users WHERE email = ?',
                [email]
            );

            if (results.isEmpty) {
                return null;
            }

            var user = results.first;
            if (PasswordHasher.verifyPassword(password, user['password'])) {
                return {
                    'id': user['id'],
                    'name': user['name'],
                    'email': user['email'],
                    'role': user['role'],
                };
            }
            return null;
        } catch (e) {
            throw DatabaseException('Login failed: ${e.toString()}');
        }
    }

    // Add methods for closing connection
    Future<void> closeConnection() async {
        if (_connection != null) {
            await _connection!.close();
            _connection = null;
        }
    }

    Future<void> executeQuery(String query, [List<dynamic>? params]) async {
        try {
            final conn = await connection;
            await conn.query(query, params);
        } catch (e) {
            if (e.toString().contains('Connection refused')) {
                throw DatabaseException('Cannot connect to database. Is XAMPP running?');
            }
            throw DatabaseException('Database error: ${e.toString()}');
        }
    }

    Future<List<String>> getExistingTables() async {
        final conn = await connection;
        var results = await conn.query(
            'SHOW TABLES FROM ${DatabaseConfig.database}'
        );
        
        List<String> tables = [];
        for (var row in results) {
            tables.add(row[0].toString().toLowerCase());
        }
        return tables;
    }

    Future<Map<String, String>> getTableColumns(String tableName) async {
        final conn = await connection;
        var results = await conn.query('''
            SELECT COLUMN_NAME, DATA_TYPE 
            FROM INFORMATION_SCHEMA.COLUMNS 
            WHERE TABLE_SCHEMA = ? AND TABLE_NAME = ?
        ''', [DatabaseConfig.database, tableName]);
        
        Map<String, String> columns = {};
        for (var row in results) {
            columns[row['COLUMN_NAME'].toString().toLowerCase()] = 
                row['DATA_TYPE'].toString();
        }
        return columns;
    }

    Future<bool> tableExists(String tableName) async {
        final conn = await connection;
        var results = await conn.query(
            'SHOW TABLES LIKE ?',
            [tableName]
        );
        return results.isNotEmpty;
    }

    Future<List<bool>> checkTablesExist() async {
        final conn = await connection;
        final requiredTables = [
            'Users',
            'Products',
            'Sales',
            'Sale_Items',
            'Expenses',
            'Stock_Alerts'
        ];
        
        List<bool> tableStatus = [];
        
        for (var tableName in requiredTables) {
            var results = await conn.query(
                'SHOW TABLES LIKE ?',
                [tableName]
            );
            tableStatus.add(results.isNotEmpty);
        }
        
        return tableStatus;
    }

    Future<bool> allTablesExist() async {
        var tableStatus = await checkTablesExist();
        return !tableStatus.contains(false);
    }

    // Replace createTablesIfNotExist with this method
    Future<void> verifyDatabaseSetup() async {
        try {
            var tables = await getExistingTables();
            var requiredSchemas = await getRequiredTableSchemas();
            
            for (var tableName in requiredSchemas.keys) {
                if (!tables.contains(tableName.toLowerCase())) {
                    throw DatabaseException(
                        'Required table $tableName is missing'
                    );
                }
            }
            
            print('Database verification completed successfully');
        } catch (e) {
            throw DatabaseException(
                'Failed to verify database setup. Error: ${e.toString()}'
            );
        }
    }

    Future<Map<String, dynamic>?> getUserById(int userId) async {
        try {
            final conn = await connection;
            var results = await conn.query(
                'SELECT id, name, email, role FROM users WHERE id = ?',
                [userId]
            );

            if (results.isNotEmpty) {
                return {
                    'id': results.first['id'],
                    'name': results.first['name'],
                    'email': results.first['email'],
                    'role': results.first['role'],
                };
            }
            return null;
        } catch (e) {
            throw DatabaseException('Failed to get user data: ${e.toString()}');
        }
    }

    Future<void> logoutUser() async {
        // Implement any cleanup needed for logout
        await closeConnection();
    }
}

class DatabaseHelper {
  Future<MySqlConnection> getConnection() async {
    final settings = ConnectionSettings(
      host: DatabaseConfig.host,
      port: DatabaseConfig.port,
      user: DatabaseConfig.user,
      password: DatabaseConfig.password,
      db: DatabaseConfig.database
    );

    try {
      final conn = await MySqlConnection.connect(settings);
      print('Database connected successfully');
      return conn;
    } catch (e) {
      print('Database connection failed: $e');
      rethrow;
    }
  }
}

class LaravelDatabaseChecker {
    static Future<bool> verifyLaravelTables(MySqlDatabaseHelper dbHelper) async {
        try {
            var tables = await dbHelper.getExistingTables();
            
            // Check for essential Laravel tables
            var requiredTables = [
                'users',
                'password_reset_tokens',
                'migrations',
                'failed_jobs',
                'personal_access_tokens'
            ];
            
            for (var table in requiredTables) {
                if (!tables.contains(table)) {
                    print('Warning: Laravel table $table not found');
                }
            }
            
            // Verify users table structure
            var userColumns = await dbHelper.getTableColumns('users');
            var requiredColumns = [
                'id',
                'name',
                'email',
                'password',
                'created_at',
                'updated_at'
            ];
            
            for (var column in requiredColumns) {
                if (!userColumns.containsKey(column)) {
                    print('Warning: Required column $column not found in users table');
                }
            }
            
            return true;
        } catch (e) {
            print('Database verification failed: $e');
            return false;
        }
    }
}