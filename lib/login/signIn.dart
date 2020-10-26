import 'dart:async';
import 'dart:math';

import 'package:fakahany/HomeScreen.dart';
import 'package:fakahany/SecondSplash.dart';
import 'package:fakahany/login/signup.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
//import 'package:google_sign_in/google_sign_in.dart';
import 'package:fakahany/global/Colors.dart' as myColors;
import 'package:rounded_loading_button/rounded_loading_button.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _phoneNumber = TextEditingController();
  final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();

  final formKey = new GlobalKey<FormState>();

  bool _autovalidation = false;
  bool _isLoading = false;
  String _error;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool isValid = false;

  Future<Null> validate(StateSetter updateState) async {
    print("in validate : ${_phoneNumber.text.length}");
    if (_phoneNumber.text.length == 10) {
      updateState(() {
        isValid = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Container(
          padding: EdgeInsets.all(25.0),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(

                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    "Sign In",
                    style: TextStyle(
                      fontFamily: 'Bold',
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 170,
                    height: 170,
                    child: Image(
                      image: AssetImage('assets/shader.png'),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    textCapitalization: TextCapitalization.words,
                    autofocus: false,
                    controller: _emailController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Email is required';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 5.0),
                        child: Icon(
                          Icons.email,
                          color: myColors.red,
                        ), // icon is 48px widget.
                      ),
                      hintText: 'Enter your Email',
                      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                  ),
                  SizedBox(height: 15.0),
                  TextFormField(
                    textCapitalization: TextCapitalization.words,
                    autofocus: false,
                    controller: _passwordController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 5.0),
                        child: Icon(
                          Icons.lock,
                          color: myColors.red,
                        ), // icon is 48px widget.
                      ),
                      hintText: 'Enter your password',
                      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    width: 600,
                    child: RoundedLoadingButton(
                      borderRadius: 10.0,
                      color: myColors.red,
                      child: Text('Sign In', style: TextStyle(fontSize: 20,color: Colors.white)),
                      controller: _btnController,
                      onPressed:(){
                        signInWithEmailAndPassword();
                      } ,
                    ),
                  ),
                  SizedBox(height: 20.0),
/*
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FlatButton(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        'Sign in',
                        style: TextStyle(
                          fontFamily: 'SemiBold',
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                      color: myColors.red,
                      textColor: Colors.white,
                      onPressed: () async {
                        signInWithEmailAndPassword();
                      },
                    ),
                  ),
*/
                  SizedBox(height: 15.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 50.0, right: 50),
                    child: Center(
                      child: Row(
                        children: <Widget>[
                          Text('Don\'t have an account? '),
                          InkWell(
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                  color: myColors.red,
                                  fontFamily: "Bold",
                                  fontSize: 18),
                            ),
                            onTap: () {
                              Navigator.of(context).pushReplacement(MaterialPageRoute(
                                  builder: (BuildContext context) => SignUp()));                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    width: 450,
                    height: 50,
                    child: SignInButton(
                      Buttons.Google,
                      text: "Sign up with Google",
                      onPressed: () {
                        signInWithGoogle();
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

 /* Widget Load()
  {
    return Scaffold(
      body: Container(
        color: Colors.lightBlue,
        child: Center(
          child: Loading(indicator: BallPulseIndicator(), size: 100.0,color: Colors.pink),
        ),
      ),
    );
  }
*/
   signInWithEmailAndPassword() async {
    if (!formKey.currentState.validate()) {
        _autovalidation = true;
        _btnController.stop();
    } else {
      Timer(Duration(seconds: 3), () {
        FirebaseAuth.instance
            .signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text)
            .then((AuthResult auth) {
          CircularProgressIndicator();
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => SecondSplash()));
        }).catchError((e) {
          showAlertDialog(context,e.toString());
        });
        _btnController.success();
      });
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      //prefs.setString('email', _emailController.text);

    }
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(value)
    ));
  }

  showAlertDialog(BuildContext context,String error) {

    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Error"),
      content: Text("${error}"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  Future signInWithGoogle() async {
    // Trigger the authentication flow
   // final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
   // final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => HomeScreen()));
    // Create a new credential
    /*final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
*/
    // Once signed in, return the UserCredential
  }


  void _doSomething() async {
    Timer(Duration(seconds: 3), () {
      signInWithEmailAndPassword();
      _btnController.success();
    });
  }

}
