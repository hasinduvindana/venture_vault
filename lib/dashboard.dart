import 'dart:async';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  final String firstName;
  const Dashboard({Key? key, required this.firstName}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // --- Background Slideshow Logic ---
  final List<String> _bgImages = [
    'assets/dash-bg1.jpg',
    'assets/dash-bg2.jpg',
    'assets/dash-bg3.jpg',
  ];
  int _currentBgIndex = 0;
  late Timer _bgTimer;

  // --- Footer Navigation State ---
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Changes background every 5 seconds with a state update
    _bgTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        _currentBgIndex = (_currentBgIndex + 1) % _bgImages.length;
      });
    });
  }

  @override
  void dispose() {
    _bgTimer.cancel();
    super.dispose();
  }

  String _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Professional Background Transition
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 1500), // Smooth 1.5s fade
            child: Container(
              key: ValueKey<int>(_currentBgIndex),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(_bgImages[_currentBgIndex]),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5), // Darken for text legibility
                    BlendMode.darken,
                  ),
                ),
              ),
            ),
          ),

          // 2. Main Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                // Moving Greeting and Session up
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getGreeting(),
                        style: const TextStyle(color: Colors.white70, fontSize: 22),
                      ),
                      Text(
                        widget.firstName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Welcome to VentureVault.",
                        style: TextStyle(color: Colors.white54, fontSize: 16),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
                
                // 3. Upcoming Tours Section
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "Upcoming Tours",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Horizontal List View for Tours
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: 3, // Dummy count
                    itemBuilder: (context, index) {
                      return _buildTourCard();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      
      // 4. Custom Footer Navigation
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.black87),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() => _selectedIndex = index);
            if (index == 4) { /* Handle Exit logic */ }
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.white54,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
            BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: "Add Tour"),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
            BottomNavigationBarItem(icon: Icon(Icons.exit_to_app), label: "Exit"),
          ],
        ),
      ),
    );
  }

  Widget _buildTourCard() {
    return Container(
      width: 280,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("Sigiriya Day Trip", 
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text("Date: Jan 25 - Jan 26", style: TextStyle(color: Colors.white70)),
          SizedBox(height: 8),
          Text("Vehicle: Toyota Raize", style: TextStyle(color: Colors.white70)),
          Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Icon(Icons.arrow_forward_ios, color: Colors.blueAccent, size: 16),
          )
        ],
      ),
    );
  }
}