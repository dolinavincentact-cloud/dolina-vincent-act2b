import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthServices {
  final SupabaseClient _supabase = Supabase.instance.client;


  User? get currentUser => _supabase.auth.currentUser;

  
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        Fluttertoast.showToast(
            msg: "Please Fill up the Form",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            backgroundColor: Color(0xFFFF7622),
            textColor: Colors.white,
            fontSize: 14.0);
        return null;
      }

      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      return response.user;
    } on AuthException catch (e) {
      String message = "";
      if (e.message.toLowerCase().contains('invalid')) {
        message = "Invalid email or password";
      } else if (e.message.toLowerCase().contains('not found')) {
        message = "No user found";
      } else {
        message = e.message;
      }

      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Color(0xFFFF7622),
          textColor: Colors.white,
          fontSize: 14.0);
      return null;
    } catch (e) {
      Fluttertoast.showToast(
          msg: "An error occurred during sign in",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Color(0xFFFF7622),
          textColor: Colors.white,
          fontSize: 14.0);
      return null;
    }
  }

 
  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        Fluttertoast.showToast(
          msg: "Please Fill up the Form",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Color(0xFFFF7622),
          textColor: Colors.white,
          fontSize: 14.0,
        );
        return null;
      }

      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
       
      );


      return response.user;
    } on AuthException catch (e) {
      String message = "";
      if (e.message.toLowerCase().contains('already registered')) {
        message = "Email already registered";
      } else if (e.message.toLowerCase().contains('invalid')) {
        message = "Invalid Email";
      } else {
        message = e.message;
      }

      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Color(0xFFFF7622),
        textColor: Colors.white,
        fontSize: 14.0,
      );
      return null;
    } catch (e) {
      Fluttertoast.showToast(
        msg: "An error occurred during registration",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Color(0xFFFF7622),
        textColor: Colors.white,
        fontSize: 14.0,
      );
      return null;
    }
  }


  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      Fluttertoast.showToast(
        msg: "Logout successful",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Color(0xFFFF7622),
        textColor: Colors.white,
        fontSize: 14.0,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error during logout",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Color(0xFFFF7622),
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }

  // Auth state changes stream
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;
}
