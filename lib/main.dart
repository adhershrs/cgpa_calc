// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'gpaScreens/HomePage.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CGPA Calculator',
      theme: themeProvider.currentTheme,
      home: const HomePage(),
      routes: {
        '/home': (context) => const HomePage(),
      },
    );
  }
}

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  ThemeData get currentTheme => isDarkMode ? darkTheme : lightTheme;

  static final lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    appBarTheme: AppBarTheme(
      color: Colors.lightBlueAccent,
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.3),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
    ),
  );

  static final darkTheme = ThemeData(
    primarySwatch: Colors.blueGrey,
    brightness: Brightness.light, // Force light text scheme
    scaffoldBackgroundColor: const Color(0xFFE0E0E0), // Light gray background
    appBarTheme: AppBarTheme(
      color: Colors.grey[800], // Dark gray app bar
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.3),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87), // Black text
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: const TextStyle(color: Colors.black87),
      hintStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
  ),
  );

  void toggleTheme() {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}

class CustomPageRoute extends PageRouteBuilder {
  final Widget child;

  CustomPageRoute({required this.child})
      : super(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (context, animation, secondaryAnimation) => child,
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) =>
      FadeTransition(
        opacity: animation,
        child: child,
      );
}