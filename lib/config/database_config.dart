import 'environment.dart';

class DatabaseConfig {
  static String get host => EnvironmentConfig.environment == Environment.development 
      ? 'localhost' 
      : 'localhost';  // Changed both to localhost
  
  static const int port = 3306;
  
  static String get user => EnvironmentConfig.environment == Environment.development 
      ? 'smartstore_app'  // Changed from 'root'
      : 'smartstore_app';
      
  static String get password => EnvironmentConfig.environment == Environment.development 
      ? 'smartstoreapp'  // Changed from empty string
      : 'smartstoreapp';
      
  static const String database = 'smartstore';
  
  // Set SSL to false for local development
  static bool get useSSL => false;
  
  // Connection pool settings
  static const int maxConnections = 10;
  static const int connectionTimeoutInSeconds = 30;
}