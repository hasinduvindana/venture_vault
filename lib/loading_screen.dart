import 'dart:async';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _wheelController;
  late Animation<double> _logoScale;
  
  final String _loadingText = "LOADING...";

  @override
  void initState() {
    super.initState();

    // Logo Controller: 6 seconds total (3s in, 3s out)
    _logoController = AnimationController(vsync: this, duration: Duration(seconds: 6));
    _logoScale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.2), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 0.0), weight: 50),
    ]).animate(_logoController);

    // Wheel Controller: Continuous rotation
    _wheelController = AnimationController(vsync: this, duration: Duration(seconds: 2))..repeat();

    _logoController.forward();

    // Navigate to Login after 6 seconds
    Timer(Duration(seconds: 6), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _wheelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(child: Image.asset('assets/car.jpg', fit: BoxFit.cover)),
          
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Zooming Logo
                ScaleTransition(scale: _logoScale, child: Image.asset('assets/loading-logo.png', width: 200)),
                SizedBox(height: 50),
                
                // Rotating Wheel
                RotationTransition(
                  turns: _wheelController,
                  child: Image.asset('assets/wheel.png', width: 80),
                ),
                
                // Staggered Loading Text
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(_loadingText.length, (index) {
                    return _StaggeredLetter(text: _loadingText[index], delay: index * 400);
                  }),
                ),
              ],
            ),
          ),
          
          // Footer
          Positioned(
            bottom: 20,
            left: 0, right: 0,
            child: Text(
              "© ${DateTime.now().year} CoderixSoft Technologies",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          )
        ],
      ),
    );
  }
}

class _StaggeredLetter extends StatefulWidget {
  final String text;
  final int delay;
  const _StaggeredLetter({required this.text, required this.delay});

  @override
  _StaggeredLetterState createState() => _StaggeredLetterState();
}

class _StaggeredLetterState extends State<_StaggeredLetter> {
  bool _visible = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 300),
      child: Text(
        widget.text,
        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 4),
      ),
    );
  }
}