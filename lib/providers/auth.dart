import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Auth {
  String _idToken;

  final FirebaseAuth _firebaseAuth;

  Auth(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  User user;

  Future<void> signIn({
    String email,
    String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print('auth firebaseAuthException $e');
      throw e;
    } catch (e) {
      //return other types of exceptions
      print('auth other Exception $e');
      throw e;
    }
  }

  Future<void> signUp(
      {String email,
      String password,
      String name,
      BuildContext context}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User user = _firebaseAuth.currentUser;
      await user.updateDisplayName(name);
      // print('am updatat numele: ' + name);
      // BUG:nu se actualizeaza instant; imediat dupa ce te inregistrezi, nu iti va aparea numele in order screen
    } on FirebaseAuthException catch (e) {
      // return FirebaseAuthExceptions;
      print('auth firebaseAuthException $e');
      throw e;
    } catch (e) {
      //return other types of exceptions
      print('auth other Exception $e');
      throw e;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String> refreshGetToken() async {
    user = FirebaseAuth.instance.currentUser;
    _idToken = await user.getIdToken();
    return _idToken;
  }

  User getUser() {
    user = _firebaseAuth.currentUser;
    return user;
  }
}
