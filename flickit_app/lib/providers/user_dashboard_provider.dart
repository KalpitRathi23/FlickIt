import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class UserDashboardProvider with ChangeNotifier {
  List<dynamic> _userDrills = [];
  bool _isLoading = false;

  List<dynamic> get userDrills => _userDrills;
  bool get isLoading => _isLoading;

  Future<void> fetchUserDrills(String userId) async {
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse(
        'https://flickit.onrender.com/api/drills/user/$userId/dashboard');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        _userDrills = json.decode(response.body);
      } else {
        _showSnackBar('Failed to load dashboard: ${response.statusCode}');
      }
    } catch (error) {
      _showSnackBar('Error fetching user drills: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );
    scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
  }
}
