import 'dart:io';

import 'package:demo_stock/models/user_data.dart';
import 'package:demo_stock/pages/navigation.dart';
import 'package:demo_stock/services/databaseservices.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:demo_stock/Login%20and%20Signup/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserRegistrationScreen extends StatefulWidget {
  @override
  _UserRegistrationScreenState createState() => _UserRegistrationScreenState();
}

class _UserRegistrationScreenState extends State<UserRegistrationScreen> {
  TextEditingController _email = TextEditingController();
  TextEditingController _mobile = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _add = TextEditingController();
  bool email = false;
  bool mobile = false;
  String image = '';
  FirebaseAuth auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  File _image = null;
  String url;

  final picker = ImagePicker();

  StorageUploadTask _uploadTask;
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://easy-trade-e106b.appspot.com');

  void _startUpload(String uid) async {
    String filePath = '$uid.jpeg';

    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(_image);
      if (_uploadTask.isInProgress) CircularProgressIndicator();
      _storage.ref().getDownloadURL().then((value) => print(value));
    });
    image = await (await _uploadTask.onComplete).ref.getDownloadURL();
  }

  Future getImage() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _startUpload(user.uid);
        print(_image.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: kLabelStyle,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 50.0,
          child: TextField(
            readOnly: email,
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              hintText: 'Enter your Email',
              prefix: SizedBox(
                width: 25,
              ),
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
        SizedBox(height: 15.0),
      ],
    );
  }

  Widget _buildNameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Name',
          style: kLabelStyle,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 50.0,
          child: TextField(
            controller: _name,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              prefix: SizedBox(
                width: 25,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              hintText: 'Enter your Name',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
        SizedBox(height: 15.0),
      ],
    );
  }

  Widget _buildMobileTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Mobile Number',
          style: kLabelStyle,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 50.0,
          child: TextField(
            readOnly: mobile,
            keyboardType: TextInputType.phone,
            controller: _mobile,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefix: SizedBox(
                width: 25,
              ),
              hintText: 'Enter Mobile Number',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
        SizedBox(
          height: 15,
        )
      ],
    );
  }

  Widget _buildaddressTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Address',
          style: kLabelStyle,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 50.0,
          child: TextField(
            maxLines: 5,
            controller: _add,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              prefix: SizedBox(
                width: 25,
              ),
              contentPadding: EdgeInsets.only(top: 14.0),
              hintText: 'Enter your Address',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
        SizedBox(
          height: 15,
        )
      ],
    );
  }

  Widget form() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _buildNameTF(),
          _buildEmailTF(),
          _buildMobileTF(),
          _buildaddressTF(),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildUserRegistrationBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          try {
            FirebaseUser _user;
            if (image.isNotEmpty &&
                image != null &&
                _name.text != '' &&
                _email.text != '' &&
                _mobile.text != '' &&
                _add.text != '') {
              UserData data = UserData(
                  _name.text, image, _email.text, _add.text, _mobile.text);
              DatabaseServices().addUser(data);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => NavigationBar()));
            } else {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (contex) => AlertDialog(
                        title: Text('Error'),
                        content: Text('Please Fill All Details'),
                        actions: <Widget>[
                          TextButton(
                              onPressed: () async {
                                Navigator.pop(contex);
                              },
                              child: Text('Ok')),
                        ],
                      ));
            }
          } catch (e) {}
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'Register',
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

  @override
  Widget build(BuildContext context) {
    auth.currentUser().then((value) {
      if (value.email != null && value.email != '') {
        _email.text = value.email;
        setState(() {
          email = true;
        });
      }
      if (value.phoneNumber != null && value.phoneNumber != '') {
        _mobile.text = value.phoneNumber.toString();
        setState(() {
          mobile = true;
        });
      }
    });
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
                      MaterialButton(
                        child: CircleAvatar(
                            radius: 55,
                            child: _image == null
                                ? Image.network(
                                    'https://www.hotelkramervalencia.com/assets/themes/adminlte/bower_components/Ionicons/png/512/android-add-contact.png',
                                    height: 80,
                                  )
                                : Image.network(
                                    'https://www.getspini.com/wp-content/uploads/2019/11/x_icon_png_1542642_14466.png',
                                    height: 80,
                                  )),
                        onPressed: () {
                          getImage();
                        },
                      ),
                      SizedBox(height: 10.0),
                      form(),
                      SizedBox(
                        height: 25,
                      ),
                      _buildUserRegistrationBtn(),
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
