import 'package:cgpa_calculator/gpaScreens/CGPAPage.dart' as first;
import 'package:flutter/material.dart';
import 'cgpapage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final TextEditingController semController = TextEditingController();
  int? n;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CGPA Calculator"),
        backgroundColor: Colors.lightBlueAccent,
      ),
      backgroundColor: Colors.orange[100],
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent, width: 25.0),
          color: Colors.transparent,
        ),
        child: ListView(
          children: <Widget>[
            TextField(
              textAlign: TextAlign.center,
              autofocus: true,
              decoration: const InputDecoration(
                fillColor: Colors.lightBlueAccent,
                hintText: "Enter number of semester",
                hintStyle: TextStyle(color: Colors.black54),
              ),
              keyboardType: TextInputType.number,
              controller: semController,
              onChanged: (String str) {
                setState(() {
                  n = int.tryParse(str);
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.touch_app, size: 35.0, color: Colors.deepPurpleAccent),
              onPressed: () {
                if (n != null && n! > 0) {
                  final int pass = n!;
                  semController.text = "";
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => first.CGPAcalc(pass)),
                  );
                } else {
                  semController.text = "";
                  _showAlert();
                }
              },
            )
          ],
        ),
      ),
    );
  }

  void _showAlert() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Please enter number of semester to calculate CGPA'),
          actions: <Widget>[
            TextButton(
              child: const Icon(Icons.clear, size: 40.0),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}