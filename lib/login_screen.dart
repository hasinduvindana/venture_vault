import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dashboard.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isRegisterVisible = false;
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for Registration
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // --- GOOGLE SIGN IN LOGIC ---
  Future<void> _handleGoogleSignIn() async {
    try {
      // 1. Open Google Account Portal
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // User closed the portal

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 2. Sign in to Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      String? userEmail = userCredential.user?.email;

      // 3. Check if email exists in VentureVault 'users' collection
      var query = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();

      if (query.docs.isNotEmpty) {
        // Get firstName for the session
        String firstName = query.docs.first.get('firstName');
        _showLoginSuccessPopup(firstName);
      } else {
        // Not a registered tourism driver
        await FirebaseAuth.instance.signOut();
        _showErrorSnackBar("This email is not registered in VentureVault.");
      }
    } catch (e) {
      _showErrorSnackBar("Login Failed: $e");
    }
  }

  // --- REGISTRATION LOGIC ---
  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('users').add({
          'firstName': _fNameController.text.trim(),
          'lastName': _lNameController.text.trim(),
          'email': _emailController.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });
        _showAccountCreatedPopup();
      } catch (e) {
        _showErrorSnackBar("Registration Error: $e");
      }
    }
  }

  // --- POPUPS & UI FEEDBACK ---
  void _showLoginSuccessPopup(String firstName) {
    _showGlassyDialog(
      icon: Icons.check_circle,
      color: Colors.greenAccent,
      message: "Login Successful!",
      onComplete: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Dashboard(firstName: firstName)),
        );
      },
    );
  }

  void _showAccountCreatedPopup() {
    _showGlassyDialog(
      icon: Icons.person_add,
      color: Colors.greenAccent,
      message: "Account Created Successfully!",
      onComplete: () {
        setState(() => isRegisterVisible = false);
      },
    );
  }

  void _showGlassyDialog({required IconData icon, required Color color, required String message, required VoidCallback onComplete}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AlertDialog(
          backgroundColor: Colors.white.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.white24),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 80),
              SizedBox(height: 20),
              Text(message, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
        ),
      ),
    );
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pop(context);
      onComplete();
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.redAccent));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(child: Image.asset('assets/login-bg.jpg', fit: BoxFit.cover)),
          
          // MAIN LOGIN VIEW
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo.png', width: 140),
                Text("VentureVault", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                SizedBox(height: 40),
                _GlassyButton(
                  onPressed: _handleGoogleSignIn,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.login, color: Colors.white),
                      SizedBox(width: 10),
                      Text("Sign in with Google", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () => setState(() => isRegisterVisible = true),
                  child: Text("Need an account? Register Here", style: TextStyle(color: Colors.white70)),
                ),
              ],
            ),
          ),

          // SLIDING REGISTER PANEL
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
          height: MediaQuery.of(context).size.height * 0.8,
          color: Colors.black.withOpacity(0.5),
          padding: EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Driver Registration", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                      IconButton(icon: Icon(Icons.close, color: Colors.white), onPressed: () => setState(() => isRegisterVisible = false)),
                    ],
                  ),
                  _inputField("First Name", _fNameController, false),
                  _inputField("Last Name", _lNameController, false),
                  _inputField("Gmail Address", _emailController, true),
                  SizedBox(height: 40),
                  _GlassyButton(onPressed: _handleRegister, child: Text("Create Account", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField(String label, TextEditingController controller, bool isEmail) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white70),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
        ),
        validator: (v) {
          if (v == null || v.isEmpty) return "This field is required";
          if (isEmail && !v.toLowerCase().endsWith("@gmail.com")) return "Must be a valid @gmail.com address";
          return null;
        },
      ),
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
        borderRadius: BorderRadius.circular(15),
        color: Colors.white.withOpacity(0.1),
        border: Border.all(color: Colors.white12),
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: child,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      ),
    );
  }
}