import 'package:flutter/material.dart';
import 'ResultPage.dart';

class CGPAcalc extends StatefulWidget {
  final int numberOfSemesters;
  const CGPAcalc(this.numberOfSemesters, {super.key});

  @override
  CGPAcalcState createState() => CGPAcalcState();
}

class CGPAcalcState extends State<CGPAcalc> {
  late List<TextEditingController> sgpaControllers;
  late List<TextEditingController> creditControllers;

  @override
  void initState() {
    super.initState();
    sgpaControllers = List.generate(widget.numberOfSemesters, (index) => TextEditingController());
    creditControllers = List.generate(widget.numberOfSemesters, (index) => TextEditingController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CGPA Calculator"),
        backgroundColor: Colors.lightBlueAccent,
      ),
      backgroundColor: Colors.orange[100],
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("SGPA", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                  Text("Credits", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                ],
              ),
            ),
            ...List.generate(widget.numberOfSemesters, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text("Semester ${index + 1}:",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      width: 80,
                      child: TextField(
                        controller: sgpaControllers[index],
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: "SGPA"),
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 80,
                      child: TextField(
                        controller: creditControllers[index],
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: "Credits"),
                      ),
                    ),
                  ],
                ),
              );
            }),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              onPressed: _calculateCGPA,
              child: const Text("Calculate CGPA", 
                  style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
          ],
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
        MaterialPageRoute(builder: (context) => ResultPage(cgpa)),
      );
    } else {
      _showErrorAlert();
    }
  }

  void _showErrorAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: const Text('Please fill all fields with valid numbers'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }
}