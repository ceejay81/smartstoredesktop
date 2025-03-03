import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const String _userIdKey = 'user_id';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';
  static const String _userRoleKey = 'user_role';

  static Future<void> saveUserSession(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userIdKey, userData['id']);
    await prefs.setString(_userNameKey, userData['name']);
    await prefs.setString(_userEmailKey, userData['email']);
    await prefs.setString(_userRoleKey, userData['role']);
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  static Future<void> clearUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<Map<String, dynamic>?> getUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt(_userIdKey);
    if (id == null) return null;

    return {
      'id': id,
      'name': prefs.getString(_userNameKey) ?? '',
      'email': prefs.getString(_userEmailKey) ?? '',
      'role': prefs.getString(_userRoleKey) ?? '',
    };
  }

  static Future<bool> hasActiveSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_userIdKey);
  }
}