// HomePage.dart
import 'package:cgpa_calculator/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'CGPAPage.dart' as first;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final TextEditingController semController = TextEditingController();
  int? n;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final gradientColors = themeProvider.isDarkMode
        ? [const Color(0xFFEEEEEE), const Color(0xFFE0E0E0)] // Light gray gradient
        : [const Color(0xFFFFF3E0), const Color(0xFFE1F5FE)];

    return Scaffold(
      appBar: AppBar(
        title: const Text("CGPA Calculator", style: TextStyle(color: Colors.black87)),
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
            stops: const [0.2, 0.8],
          ),
        ),
        child: FadeTransition(
          opacity: _animation,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(-1, 0),
                    end: Offset.zero,
                  ).animate(_animation),
                  child: TextField(
                    style: const TextStyle(color: Colors.black87), // Black text
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: "Enter number of semesters (1-8)",
                      hintStyle: TextStyle(
                        color: Colors.black.withOpacity(0.6),
                      ),
                      filled: true,
                      fillColor: themeProvider.isDarkMode
                          ? Colors.grey[200]
                          : Colors.lightBlueAccent.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    controller: semController,
                    onChanged: (String str) {
                      setState(() {
                        n = int.tryParse(str);
                      });
                    },
                  ),
                ),
                const SizedBox(height: 30),
                ScaleTransition(
                  scale: _animation,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.calculate, size: 28, color: Colors.black87),
                    label: const Text("PROCEED", style: TextStyle(fontSize: 20, color: Colors.black87)),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: themeProvider.isDarkMode
                          ? Colors.grey[300]
                          : Colors.lightBlueAccent,
                    ),
                    onPressed: () {
                      if (n != null && n! > 0 && n! <= 8) {
                        final int pass = n!;
                        semController.text = "";
                        Navigator.of(context).push(
                          CustomPageRoute(child: first.CGPAcalc(pass)),
                        );
                      } else {
                        semController.text = "";
                        _showAlert();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Invalid Input', style: TextStyle(color: Colors.black87)),
        content: const Text('Please enter a valid number between 1 and 8', 
            style: TextStyle(color: Colors.black87)),
        actions: [
          TextButton(
            child: const Text('OK', style: TextStyle(color: Colors.black87)),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}