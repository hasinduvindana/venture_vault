import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  final String firstName;

  // Constructor to receive the session value (First Name)
  const Dashboard({Key? key, required this.firstName}) : super(key: key);

  // Logic to determine the greeting based on current time
  String _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D1B2A), // Modern deep dark blue
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getGreeting(),
              style: TextStyle(
                color: Colors.white70,
                fontSize: 22,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 5),
            Text(
              firstName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 42,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 2,
              width: 100,
              color: Colors.blueAccent.withOpacity(0.5),
            ),
            SizedBox(height: 40),
            // Add a placeholder for your main driver features
            Text(
              "Welcome to VentureVault. Your tour requests will appear here.",
              style: TextStyle(color: Colors.white54, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}