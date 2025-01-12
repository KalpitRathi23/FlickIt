import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class LeaderboardProvider with ChangeNotifier {
  List<dynamic> _leaderboard = [];
  bool _isLoading = false;

  List<dynamic> get leaderboard => _leaderboard;
  bool get isLoading => _isLoading;

  Future<void> fetchLeaderboard() async {
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse('https://flickit.onrender.com/api/leaderboard');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        _leaderboard = json.decode(response.body);
      } else {
        _showSnackBar('Failed to load leaderboard: ${response.statusCode}');
      }
    } catch (error) {
      _showSnackBar('Error fetching leaderboard: $error');
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
