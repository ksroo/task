import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../db/models.dart';

import '../app/app.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseAuth {
  Future<String> currentUser();
  Future<User> signInUsingEmail(String email, String password);
  Future<User> createUser(String email, String password);
  Future<void> signOut();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User> signInUsingEmail(String email, String password) async {
    UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  signInViaEmailLink(String email) async {
    await _firebaseAuth.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: ActionCodeSettings(
            url: '${App.emailLoginUrl}?email=$email',
            //url: 'http://localhost:54963/confirmLogin.html?email=$email',
            //url: 'http://tenfins.com/comped/confirmLogin.html?email=$email',
            //url: 'https://tenfins.page.link/6SuK',
            iOSBundleId: 'com.tenfins.chatapp',
            androidPackageName: 'com.tenfins.chatapp',
            androidInstallApp: true,
            androidMinimumVersion: "8",
            handleCodeInApp: true));
  }

// https://tenfins.page.link/?link=https://chatapp-c60fa.firebaseapp.com/__/auth/action?apiKey%3DAIzaSyA42EBlk5uEnXlPPCXC6YhGFmS01qiKvRc%26mode%3DsignIn%26oobCode%3DCNyio42nJpQPxqTHva2vA7D1tWH-ijP_-mOGD0SMh_QAAAF2702w0w%26continueUrl%3Dhttps://tenfins.page.link/6SuK%26lang%3Den&apn=com.tenfins.chatapp&amv&afl=https://chatapp-c60fa.firebaseapp.com/__/auth/action?apiKey%3DAIzaSyA42EBlk5uEnXlPPCXC6YhGFmS01qiKvRc%26mode%3DsignIn%26oobCode%3DCNyio42nJpQPxqTHva2vA7D1tWH-ijP_-mOGD0SMh_QAAAF2702w0w%26continueUrl%3Dhttps://tenfins.page.link/6SuK%26lang%3Den&ibi=com.tenfins.chatapp&ifl=https://chatapp-c60fa.firebaseapp.com/__/auth/action?apiKey%3DAIzaSyA42EBlk5uEnXlPPCXC6YhGFmS01qiKvRc%26mode%3DsignIn%26oobCode%3DCNyio42nJpQPxqTHva2vA7D1tWH-ijP_-mOGD0SMh_QAAAF2702w0w%26continueUrl%3Dhttps://tenfins.page.link/6SuK%26lang%3Den

  Future<User> createUser(String email, String password) async {
    Firebase.initializeApp();
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  Future<String> currentUser() async {
    User user = await _firebaseAuth.currentUser;
    if (user != null) {
      App.loggedIn = true;
      App.loginEmail = user.email;
      App.loginUserid = user.uid;
      App.loginService = "firebase";
      return user.uid;
    } else {
      return "";
    }
  }

  init() async {

    //  Setup a default test user (scott)
    App.mUser = ModelUser.lookupUserByEmail('scott@bigmindcreative.com');  

    _firebaseAuth.authStateChanges().listen((User user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        App.loggedIn = true;
        App.loginEmail = user.email;
        App.loginUserid = user.uid;
        App.loginService = "firebase";
        App.mUser = ModelUser.lookupUserByEmail(user.email);
        //return user.uid;
        print('User ${App.mUser.email} is signed in!');
      }
    });
  }

  loginOnSimulator(String email) {
    App.loggedIn = true;
    // App.email = user.email;
    // App.loginUserid = user.uid;
    App.loginService = "firebase";
    App.mUser = ModelUser.lookupUserByEmail(email);
    //return user.uid;
    print('User ${App.mUser.email} is signed in!');
  }

  Future<User> getFirebaseUser() async {
    User firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) {
      firebaseUser = await FirebaseAuth.instance.authStateChanges().first;
    }
    if (firebaseUser != null) {
      App.loggedIn = true;
      App.loginEmail = firebaseUser.email;
    }
    return firebaseUser;
  }

  Future<void> signOut() async {
    App.loggedIn = false;
    return _firebaseAuth.signOut();
  }

  static Uri lastLink = null;

  void handleLink(Uri link) async {
    if (lastLink != null && lastLink == link) return;

    lastLink = link;
    App.loggedIn = false;

    if (link != null) {
      final User user = (await _firebaseAuth.signInWithEmailLink(
        email: App.pendingLoginEmail,
        emailLink: link.toString(),
      ))
          .user;
      if (user != null) {
        App.loginUserid = user.uid;
        App.loginEmail = user.email;
        App.mUser = ModelUser.lookupUserByEmail(user.email);
        App.loggedIn = true;
        App.goto('/loggedin');
      }
    }
  }
}
