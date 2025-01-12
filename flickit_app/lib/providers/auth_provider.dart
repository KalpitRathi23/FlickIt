import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _userId;
  String? _token;

  bool get isLoading => _isLoading;
  String? get userId => _userId;
  String? get token => _token;

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('token') || !prefs.containsKey('userId')) {
      return;
    }
    _token = prefs.getString('token');
    _userId = prefs.getString('userId');
    notifyListeners();
  }

  Future<bool> register(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse('http://192.168.30.71:5000/api/auth/register');
    try {
      final response = await http.post(
        url,
        body: json.encode({'username': username, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        _showSnackBar('Registration failed: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      _showSnackBar('Error during registration: $error');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse('http://192.168.30.71:5000/api/auth/login');
    try {
      final response = await http.post(
        url,
        body: json.encode({'username': username, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        await prefs.setString('userId', data['userId']);

        _token = data['token'];
        _userId = data['userId'];
        notifyListeners();
        return true;
      } else {
        _showSnackBar('Login failed: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      _showSnackBar('Error during login: $error');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _token = null;
    _userId = null;
    notifyListeners();
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );
    scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
  }
}
