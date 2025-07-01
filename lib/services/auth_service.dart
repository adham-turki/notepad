import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'database_helper.dart';

class AuthService {
  static const String _userIdKey = 'user_id';
  static const String _isLoggedInKey = 'is_logged_in';

  static String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  static Future<bool> register(String email, String password, String name) async {
    try {
      final existingUser = await DatabaseHelper.instance.getUserByEmail(email);
      if (existingUser != null) {
        return false; // User already exists
      }

      final hashedPassword = _hashPassword(password);
      final user = User(
        email: email,
        password: hashedPassword,
        name: name,
      );

      await DatabaseHelper.instance.createUser(user);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> login(String email, String password) async {
    try {
      final user = await DatabaseHelper.instance.getUserByEmail(email);
      if (user == null) {
        return false;
      }

      final hashedPassword = _hashPassword(password);
      if (user.password == hashedPassword) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(_userIdKey, user.id!);
        await prefs.setBool(_isLoggedInKey, true);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
    await prefs.setBool(_isLoggedInKey, false);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt(_userIdKey);
    if (userId != null) {
      return await DatabaseHelper.instance.getUserById(userId);
    }
    return null;
  }
}
