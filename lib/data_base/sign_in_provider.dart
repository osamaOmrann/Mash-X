import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInProvider extends ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  bool _hasError = false;
  bool get hasError => _hasError;

  String? _errorCode;
  String? get errorCode => _errorCode;

  String? _provider;
  String? get provider => _provider;

  String? _uid;
  String? get uid => _uid;

  String? _name;
  String? get name => _name;

  String? _email;
  String? get email => _email;

  String? _imageUrl;
  String? get imageUrl => _imageUrl;

  String? _password;
  String? get password => _password;

  SignInProvider() {
    checkSignInUser();
  }

  Future checkSignInUser() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("signed_in") ?? false;
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool('signed_in', true);
    _isSignedIn = true;
    notifyListeners();
  }

  //Sign In With Google
  Future signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      //Executing Authentication
      try {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);

        //Signing In To Firebase User Instance
        final User userDetails =
            (await firebaseAuth.signInWithCredential(credential)).user!;

        //Save Data
        _name = userDetails.displayName;
        _email = userDetails.email;
        _imageUrl = userDetails.photoURL;
        _provider = "GOOGLE";
        _uid = userDetails.uid;
        _password = 'null';
        notifyListeners();
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "account-exists-with-different-credential":
            _errorCode = "You already have an account";
            _hasError = true;
            notifyListeners();
            break;
          case "null":
            _errorCode = "Unexpected error while trying to sign in";
            _hasError = true;
            notifyListeners();
            break;
          default:
            _errorCode = e.toString();
            _hasError = true;
            notifyListeners();
        }
      }
    } else {
      _hasError = true;
      notifyListeners();
    }
  }

  Future getUserDataFromFireStore(uid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((DocumentSnapshot snapshot) => {
              _uid = snapshot['uid'],
              _name = snapshot['name'],
              _email = snapshot['email'],
              _imageUrl = snapshot['image_url'],
              _provider = snapshot['provider'],
      _password = snapshot['password']
            });
  }

  Future saveDataToFireStore() async {
    final DocumentReference r = FirebaseFirestore.instance.collection('users').doc(uid);
    await r.set({
      'name': _name,
      'email': _email,
      'uid': _uid,
      'image_url': _imageUrl,
      'provider': _provider,
      'password': _password
    });
    notifyListeners();
  }

  Future saveDataToSharedPreferences() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    await s.setString('name', _name!);
    await s.setString('email', _email!);
    await s.setString('uid', _uid!);
    await s.setString('image_url', _imageUrl!);
    await s.setString('provider', _provider!);
    await s.setString('password', _password!);
    notifyListeners();
  }

  Future getDataFromSharedPreferences() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _name = s.getString('name');
    _email = s.getString('email');
    _imageUrl = s.getString('image_url');
    _uid = s.getString('uid');
    _provider = s.getString('provider');
    _password = s.getString('password');
    notifyListeners();
  }

  //Check User Existence In Cloud FireStore
  Future<bool> checkUserExists() async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    if (snap.exists) {
      log('Existing User');
      return true;
    } else {
      log('New User');
      return false;
    }
  }

  Future userSignOut() async {
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
    _isSignedIn = false;
    notifyListeners();

    //Clear Storage Information
    clearStoredData();
  }

  Future clearStoredData() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.clear();
  }

  void phoneNumberUser(User user, email, name) {
    _name = name;
    _email = email;
    _imageUrl = 'https://cdn-icons-png.flaticon.com/512/149/149071.png';
    _uid = firebaseAuth.currentUser?.uid;
    _provider = 'PHONE';
    _password = 'null';
    notifyListeners();
  }

  void emailPasswordUser(User user, email, name, password) {
    _name = name;
    _email = email;
    _imageUrl = 'https://cdn-icons-png.flaticon.com/512/149/149071.png';
    _uid = firebaseAuth.currentUser?.uid;
    _password = password;
    _provider = 'EMAIL AND PASSWORD';
    notifyListeners();
  }
}
