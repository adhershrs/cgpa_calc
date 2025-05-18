// CGPAPage.dart
import 'package:cgpa_calculator/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ResultPage.dart';

class CGPAcalc extends StatefulWidget {
  final int numberOfSemesters;
  const CGPAcalc(this.numberOfSemesters, {super.key});

  @override
  CGPAcalcState createState() => CGPAcalcState();
}

class CGPAcalcState extends State<CGPAcalc> with SingleTickerProviderStateMixin {
  late List<TextEditingController> sgpaControllers;
  late List<TextEditingController> creditControllers;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    sgpaControllers = List.generate(widget.numberOfSemesters, (index) => TextEditingController());
    creditControllers = List.generate(widget.numberOfSemesters, (index) => TextEditingController());
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
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
        ? [const Color(0xFFEEEEEE), const Color(0xFFE0E0E0)]
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
          ),
        ),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.1),
            end: Offset.zero,
          ).animate(_animation),
          child: FadeTransition(
            opacity: _animation,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("SGPA", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                          Text("Credits", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                        ],
                      ),
                    ),
                    ...List.generate(widget.numberOfSemesters, (index) {
                      return AnimatedOpacity(
                        opacity: 1,
                        duration: Duration(milliseconds: 500 + (index * 100)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: themeProvider.isDarkMode
                                      ? [Colors.grey[200]!, Colors.grey[300]!]
                                      : [Colors.lightBlueAccent.shade100, Colors.blue.shade50],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    Text("Semester ${index + 1}:",
                                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                                    const Spacer(),
                                    SizedBox(
                                      width: 80,
                                      child: TextField(
                                        controller: sgpaControllers[index],
                                        style: const TextStyle(color: Colors.black87),
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          hintText: "SGPA",
                                          hintStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    SizedBox(
                                      width: 80,
                                      child: TextField(
                                        controller: creditControllers[index],
                                        style: const TextStyle(color: Colors.black87),
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          hintText: "Credits",
                                          hintStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 20),
                    ScaleTransition(
                      scale: _animation,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.calculate, color: Colors.black87),
                        label: const Text("CALCULATE CGPA", 
                            style: TextStyle(fontSize: 18, color: Colors.black87)),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          backgroundColor: themeProvider.isDarkMode
                              ? Colors.grey[300]
                              : Colors.lightBlueAccent,
                        ),
                        onPressed: _calculateCGPA,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _calculateCGPA() {
    double totalCredits = 0;
    double totalPoints = 0;
    bool allFieldsFilled = true;

    for (int i = 0; i < widget.numberOfSemesters; i++) {
      if (sgpaControllers[i].text.isEmpty || creditControllers[i].text.isEmpty) {
        allFieldsFilled = false;
        break;
      }
      
      final sgpa = double.tryParse(sgpaControllers[i].text) ?? 0;
      final credits = double.tryParse(creditControllers[i].text) ?? 0;
      
      totalPoints += sgpa * credits;
      totalCredits += credits;
    }

    if (allFieldsFilled && totalCredits > 0) {
      final cgpa = totalPoints / totalCredits;
      Navigator.push(
        context,
        CustomPageRoute(child: ResultPage(cgpa)),
      );
    } else {
      _showErrorAlert();
    }
  }

  void _showErrorAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error', style: TextStyle(color: Colors.black87)),
        content: const Text('Please fill all fields with valid numbers', 
            style: TextStyle(color: Colors.black87)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Colors.black87)),
          )
        ],
      ),
    );
  }
}