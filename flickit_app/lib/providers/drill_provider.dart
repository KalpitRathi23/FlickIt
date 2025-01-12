import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/drill.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class DrillProvider with ChangeNotifier {
  List<Drill> _drills = [];
  bool _isLoading = false;

  List<Drill> get drills => _drills;
  bool get isLoading => _isLoading;

  Future<void> fetchDrills() async {
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse('https://flickit.onrender.com/api/drills');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _drills = data.map((drill) => Drill.fromJson(drill)).toList();
      } else {
        _showSnackBar('Failed to fetch drills: ${response.statusCode}');
      }
    } catch (error) {
      _showSnackBar('Error fetching drills: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> submitDrillCount({
    required String userId,
    required String drillId,
    required int completedCount,
  }) async {
    final url = Uri.parse('https://flickit.onrender.com/api/drills/submit');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': userId,
          'drillId': drillId,
          'completedCount': completedCount,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        _showSnackBar('Failed to submit count: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      _showSnackBar('Error submitting drill count: $error');
      return false;
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
