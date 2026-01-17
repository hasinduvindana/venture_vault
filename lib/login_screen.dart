import 'dart:ui';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isRegisterVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(child: Image.asset('assets/login-bg.jpg', fit: BoxFit.cover)),
          
          // Main Login UI
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo.png', width: 150),
                Text("Login", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                SizedBox(height: 30),
                _GlassyButton(
                  onPressed: () {}, 
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.g_mobiledata, color: Colors.white),
                      Text(" Sign in with Google", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() => isRegisterVisible = true),
                  child: Text("Need an account? Register", style: TextStyle(color: Colors.white70)),
                )
              ],
            ),
          ),

          // Sliding Register Form
          AnimatedPositioned(
            duration: Duration(milliseconds: 600),
            curve: Curves.easeInOutExpo,
            bottom: isRegisterVisible ? 0 : -MediaQuery.of(context).size.height,
            left: 0, right: 0,
            child: _buildRegisterPanel(),
          )
        ],
      ),
    );
  }

  Widget _buildRegisterPanel() {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          color: Colors.white.withOpacity(0.1),
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Register", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  IconButton(onPressed: () => setState(() => isRegisterVisible = false), icon: Icon(Icons.close, color: Colors.white))
                ],
              ),
              TextField(decoration: InputDecoration(labelText: "Full Name", labelStyle: TextStyle(color: Colors.white))),
              TextField(decoration: InputDecoration(labelText: "Vehicle Number", labelStyle: TextStyle(color: Colors.white))),
              SizedBox(height: 40),
              _GlassyButton(onPressed: () {}, child: Text("Create Account", style: TextStyle(color: Colors.white))),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassyButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  const _GlassyButton({required this.child, required this.onPressed});

  @override
  __GlassyButtonState createState() => __GlassyButtonState();
}

class __GlassyButtonState extends State<_GlassyButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: isHovered ? Colors.white.withOpacity(0.3) : Colors.white.withOpacity(0.15),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: MaterialButton(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          onPressed: widget.onPressed,
          child: widget.child,
        ),
      ),
    );
  }
}