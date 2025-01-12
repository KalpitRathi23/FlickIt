import 'package:flickit_app/providers/drill_provider.dart';
import 'package:flickit_app/providers/leaderboard_provider.dart';
import 'package:flickit_app/providers/user_dashboard_provider.dart';
import 'package:flickit_app/screens/drill_detail_screen.dart';
import 'package:flickit_app/screens/leaderboard_screen.dart';
import 'package:flickit_app/screens/register_screen.dart';
import 'package:flickit_app/screens/user_dashboard_screen.dart';
import 'package:flickit_app/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'providers/auth_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DrillProvider()),
        ChangeNotifierProvider(create: (_) => UserDashboardProvider()),
        ChangeNotifierProvider(create: (_) => LeaderboardProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/home': (context) => const HomeScreen(),
          '/drillDetail': (context) => const DrillDetailScreen(),
          '/dashboard': (context) => const UserDashboardScreen(),
          '/leaderboard': (context) => const LeaderboardScreen(),
        },
      ),
    );
  }
}
