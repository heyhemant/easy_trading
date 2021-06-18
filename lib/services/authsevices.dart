import 'package:demo_stock/pages/navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  Future<FirebaseUser> loginWithPhone(
      String number, BuildContext context) async {
    TextEditingController _codeController = TextEditingController();
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: (AuthCredential credential) async {
          Navigator.of(context).pop();
          AuthResult result = await _auth.signInWithCredential(credential);
          FirebaseUser _user = result.user;
          if (_user != null) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => NavigationBar()));
            return _user;
          } else {
            print('Error Uchiha');
            return null;
          }
        },
        verificationFailed: (AuthException e) {
          print(e);
          return null;
        },
        codeSent: (String varifivationId, [int forceResendingToken]) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (contex) => AlertDialog(
                    title: Text('Enter Code'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(controller: _codeController)
                      ],
                    ),
                    actions: <Widget>[
                      FlatButton(
                          onPressed: () async {
                            final code = _codeController.text.trim();
                            AuthCredential credential =
                                PhoneAuthProvider.getCredential(
                                    verificationId: varifivationId,
                                    smsCode: code);
                            AuthResult result =
                                await _auth.signInWithCredential(credential);
                            FirebaseUser _user = result.user;
                            if (_user != null) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NavigationBar()));
                              return _user;
                            } else {
                              print('Error Uchiha');
                              return null;
                            }
                          },
                          child: Text('Confirm')),
                    ],
                  ));
        },
        codeAutoRetrievalTimeout: null,
        timeout: Duration(seconds: 60));
  }

  Future<FirebaseUser> signup(
      String email, String pass, BuildContext context) async {
    String message = 'Error occur';
    try {
      FirebaseAuth _auth = FirebaseAuth.instance;
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: pass);
      FirebaseUser _user = result.user;
      return _user;
    } on PlatformException catch (e) {
      if (e.code == 'ERROR_INVALID_EMAIL')
        message = 'Enter a vaild Email Address';
      if (e.code == 'ERROR_WEAK_PASSWORD') message = 'Enter a strong password';
      if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE')
        message = 'Already Registred Email, \n Please login';
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (contex) => AlertDialog(
                title: Text('Error'),
                content: Text(message),
                actions: <Widget>[
                  TextButton(
                      onPressed: () async {
                        Navigator.pop(contex);
                      },
                      child: Text('Ok')),
                ],
              ));
      print(e);
      return null;
    }
  }

  Future<FirebaseUser> logingoogle() async {
    try {
      final GoogleSignInAccount _account =
          await GoogleSignIn(scopes: ['email']).signIn();
      final GoogleSignInAuthentication googleauth =
          await _account.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleauth.idToken, accessToken: googleauth.accessToken);
      final result =
          await FirebaseAuth.instance.signInWithCredential(credential);
      print(result.user.email);
      return result.user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<FirebaseUser> signInEmail(TextEditingController _email,
      TextEditingController _pass, BuildContext context) async {
    FirebaseUser _user;
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: _email.text, password: _pass.text);
      _user = result.user;
      if (_user == null) {
        SnackBar(content: Text('Failed Motherfucker !!!'));
        return null;
      } else {
        SnackBar(
          content: Text('Welcome'),
        );
        return _user;
      }
    } on PlatformException catch (e) {
      String message = 'Error';
      if (e.code == 'ERROR_INVALID_EMAIL')
        message = 'Invaild Email Address Found';
      else if (e.message == 'ERROR_USER_NOT_FOUND')
        message = 'User not registered';
      else if (e.code == 'ERROR_WRONG_PASSWORD')
        message = 'Wrong password entered \n please enter Correct password';
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (contex) => AlertDialog(
                title: Text('Error'),
                content: Text(message),
                actions: <Widget>[
                  TextButton(
                      onPressed: () async {
                        _pass.clear();
                        Navigator.pop(contex);
                      },
                      child: Text('Ok')),
                ],
              ));
      print(e.code);
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
    } catch (e) {
      print(e);
    }
  }
}
