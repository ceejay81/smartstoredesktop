enum Environment { development, production }

class EnvironmentConfig {
  static const environment = Environment.development;
  
  static String get databaseHost {
    return environment == Environment.development 
        ? 'localhost' 
        : 'your.production.host';
  }
}