import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService extends ChangeNotifier {
  // Instance of Auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Instance of Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign User In
  Future<UserCredential> signInWithEmailandPassword(
      String email, String password) async {
    try {
      // Sign In
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
              email: email,
              password: password,
          );

          // Add a new document for the user in users collection if it doesn't already exist
          _firestore.collection('users').doc(userCredential.user!.uid).set({
            'uid': userCredential.user!.uid,
            'email': email,
          }, SetOptions(merge: true));

      return userCredential;
    }

    // Catch any errors
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Create New User
  Future<UserCredential> signUpWithEmailandPassword(
      String email, password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: email,
              password: password,
          );

      // After creating the user, create a new document for the user in the users' collection
      _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }


  // Sign User Out
  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }

}