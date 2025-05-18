// ResultPage.dart
import 'package:cgpa_calculator/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResultPage extends StatelessWidget {
  final double cgpa;

  const ResultPage(this.cgpa, {super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final gradientColors = themeProvider.isDarkMode
        ? [const Color(0xFFEEEEEE), const Color(0xFFE0E0E0)]
        : [const Color(0xFFFFF3E0), const Color(0xFFE1F5FE)];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Result", style: TextStyle(color: Colors.black87)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: themeProvider.isDarkMode
                  ? [Colors.grey[800]!, Colors.grey[700]!]
                  : [Colors.lightBlueAccent, Colors.blue.shade300],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(themeProvider.isDarkMode 
                ? Icons.light_mode 
                : Icons.dark_mode),
            onPressed: () => themeProvider.toggleTheme(),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Your CGPA is:",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 20),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: cgpa),
                duration: const Duration(seconds: 1),
                builder: (context, value, _) => Text(
                  value.toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    shadows: [
                      Shadow(
                        blurRadius: 10,
                        color: Colors.black.withOpacity(0.1),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh, color: Colors.black87),
                label: const Text("CALCULATE AGAIN", style: TextStyle(color: Colors.black87)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  backgroundColor: themeProvider.isDarkMode
                      ? Colors.grey[300]
                      : Colors.lightBlueAccent,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}