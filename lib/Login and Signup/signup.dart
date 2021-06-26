import 'package:demo_stock/Login%20and%20Signup/LoginPhone.dart';
import 'package:demo_stock/Login%20and%20Signup/constants.dart';
import 'package:demo_stock/Login%20and%20Signup/loginpage.dart';
import 'package:demo_stock/pages/navigation.dart';
import 'package:demo_stock/services/authsevices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _email = TextEditingController();
  TextEditingController _repass = TextEditingController();
  TextEditingController _pass = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Enter your Email',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: _pass,
            obscureText: true,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Enter your Password',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget form() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _buildEmailTF(),
          SizedBox(height: 40.0),
          _buildPasswordTF(),
          SizedBox(
            height: 20,
          ),
          _buildRePasswordTF()
        ],
      ),
    );
  }

  Widget _buildRePasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 20.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: _repass,
            obscureText: true,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Confirm Password',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          try {
            FirebaseUser _user;
            if (_formKey.currentState.validate()) {
              if (_pass.text.trim() == _repass.text.trim()) {
                _user = await AuthServices()
                    .signup(_email.text.trim(), _pass.text.trim(), context);
                if (_user != null) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => NavigationBar()));
                } 
              } else {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (contex) => AlertDialog(
                          title: Text('Error'),
                          content: Text('Password not matched'),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () async {
                                  _pass.clear();
                                  Navigator.pop(contex);
                                },
                                child: Text('Ok')),
                          ],
                        ));
              }
            }
          } catch (e) {
            SnackBar(
              content: Text(e.toString()),
            );
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'SIGNUP',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        Text(
          '- OR -',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          'Sign in with',
          style: kLabelStyle,
        ),
      ],
    );
  }

  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtnRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocialBtn(
            () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LoginPhoneScreen())),
            AssetImage(
              'assets/phone.png',
            ),
          ),
          _buildSocialBtn(
            () async {
              try {
                FirebaseUser _user = await AuthServices().logingoogle();
                if (_user != null) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => NavigationBar()));
                } else {
                  SnackBar(
                    content: Text('Error'),
                  );
                }
              } catch (e) {
                SnackBar(content: Text(e.toString()));
              }
            },
            AssetImage(
              'assets/google.png',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginBtn() {
    return GestureDetector(
      onTap: () => Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen())),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Already have an Account ? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Log In',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF73AEF5),
                      Color(0xFF61A4F1),
                      Color(0xFF478DE0),
                      Color(0xFF398AE5),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 90.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      // _buildEmailTF(),
                      // SizedBox(
                      //   height: 20.0,
                      // ),
                      // _buildPasswordTF(),
                      // _buildRePasswordTF(),
                      form(),
                      _buildSignUpBtn(),
                      _buildSignInWithText(),
                      _buildSocialBtnRow(),
                      _buildLoginBtn(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
