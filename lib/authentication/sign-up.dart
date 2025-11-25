import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kwiki/authentication/login.dart';

import 'package:kwiki/services/auth_services.dart';
import 'package:kwiki/widgets/custom-button.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordControler = TextEditingController();
  final TextEditingController _confirmPasswordControler =
      TextEditingController();
  final AuthServices _auth = AuthServices();

  bool _obscureText = true;
  bool _obscureConfirmText = true;
  bool loadingPa = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordControler.dispose();
    _confirmPasswordControler.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
   
    if (_emailController.text.isEmpty ||
        _passwordControler.text.isEmpty ||
        _confirmPasswordControler.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please fill all fields",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Color(0xFFFF7622),
        textColor: Colors.white,
        fontSize: 14.0,
      );
      return;
    }

    // Check if passwords match
    if (_passwordControler.text != _confirmPasswordControler.text) {
      Fluttertoast.showToast(
        msg: "Passwords do not match",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Color(0xFFFF7622),
        textColor: Colors.white,
        fontSize: 14.0,
      );
      return;
    }

    // Check password length
    if (_passwordControler.text.length < 6) {
      Fluttertoast.showToast(
        msg: "Password must be at least 6 characters",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Color(0xFFFF7622),
        textColor: Colors.white,
        fontSize: 14.0,
      );
      return;
    }

    setState(() {
      loadingPa = true;
    });

    try {
      final user = await _auth.registerWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordControler.text,
     
      );

      if (mounted) {
        if (user != null) {
          Fluttertoast.showToast(
            msg: "Created Succesfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            backgroundColor: Color(0xFFFF7622),
            textColor: Colors.white,
            fontSize: 14.0,
          );
        }
       
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          loadingPa = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/background_images/Bg.png"),
                  fit: BoxFit.fill),
            ),
          ),
          Align(
            alignment: Alignment(-1, -0.9),
            child: Container(
              margin: const EdgeInsets.only(top: 40, left: 20),
              decoration: BoxDecoration(
                color: Colors.white, // Background color
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Colors.black, // Icon color
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          Align(
              alignment: Alignment(0, -0.7),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Sign Up",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins'),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Please sign up to get started",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  )
                ],
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 530,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "EMAIL",
                    style: TextStyle(
                        color: Color(0xFF646982), fontWeight: FontWeight.w500),
                  ),
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color(0xFFF0F5FA), // Background color with opacity
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none)),
                    ),
                  ),
                  Text(
                    "PASSWORD",
                    style: TextStyle(
                        color: Color(0xFF646982), fontWeight: FontWeight.w500),
                  ),
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color(0xFFF0F5FA),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _passwordControler,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            child: Icon(_obscureText
                                ? Icons.visibility
                                : Icons.visibility_off),
                          )),
                    ),
                  ),
                  Text(
                    "RE-TYPE PASSWORD",
                    style: TextStyle(
                        color: Color(0xFF646982), fontWeight: FontWeight.w500),
                  ),
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color(0xFFF0F5FA),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _confirmPasswordControler,
                      obscureText: _obscureConfirmText,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureConfirmText = !_obscureConfirmText;
                              });
                            },
                            child: Icon(_obscureConfirmText
                                ? Icons.visibility
                                : Icons.visibility_off),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 65,
                    child: CustomButton(
                      loadingPa: loadingPa,
                      text: 'SIGN UP',
                      onPressed: _handleSignUp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
