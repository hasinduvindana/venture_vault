import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isRegisterVisible = false;
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('users').add({
          'firstName': _fNameController.text.trim(),
          'lastName': _lNameController.text.trim(),
          'email': _emailController.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });
        _showSuccessDialog();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AlertDialog(
          backgroundColor: Colors.white.withOpacity(0.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: Colors.white24)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.greenAccent, size: 70),
              SizedBox(height: 20),
              Text("Account Created Successfully!", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pop(context);
      setState(() => isRegisterVisible = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset('assets/login-bg.jpg', fit: BoxFit.cover)),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo.png', width: 140),
                Text("Login", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                _GlassyButton(onPressed: () {}, child: Text("Sign in with Google")),
                TextButton(onPressed: () => setState(() => isRegisterVisible = true), child: Text("Register New Account")),
              ],
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 700),
            curve: Curves.easeOutBack,
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
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.75,
          color: Colors.black.withOpacity(0.4),
          padding: EdgeInsets.all(25),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Register Driver", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    IconButton(icon: Icon(Icons.close), onPressed: () => setState(() => isRegisterVisible = false)),
                  ],
                ),
                _inputField("First Name", _fNameController, false),
                _inputField("Last Name", _lNameController, false),
                _inputField("Gmail Address", _emailController, true),
                SizedBox(height: 30),
                _GlassyButton(onPressed: _handleRegister, child: Text("Create Account")),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField(String label, TextEditingController cont, bool isEmail) {
    return TextFormField(
      controller: cont,
      decoration: InputDecoration(labelText: label),
      validator: (v) {
        if (v == null || v.isEmpty) return "Cannot be empty";
        if (isEmail && !v.toLowerCase().endsWith("@gmail.com")) return "Must be @gmail.com";
        return null;
      },
    );
  }
}

class _GlassyButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  const _GlassyButton({required this.child, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withOpacity(0.1),
        border: Border.all(color: Colors.white12),
      ),
      child: MaterialButton(onPressed: onPressed, child: child, padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15)),
    );
  }
}