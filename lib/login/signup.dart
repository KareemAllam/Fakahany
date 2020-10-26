import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fakahany/Get_Location.dart';
import 'package:fakahany/HomeScreen.dart';
import 'package:fakahany/SecondSplash.dart';
import 'package:fakahany/login/services/usermanagment.dart';
import 'package:fakahany/login/signIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:fakahany/global/Colors.dart' as myColors;

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  FirebaseAuth auth = FirebaseAuth.instance;

  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();

  TextEditingController _phoneNumber = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  bool _success;
  String _userEmail;
  final formKey = new GlobalKey<FormState>();
  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  String text;
  UserManagement userManagement = new UserManagement();
  // FirebaseMessaging xnm = new FirebaseMessaging();

  String phoneNo;
  String smsOTP;
  String verificationId;
  String errorMessage = '';
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController massege = TextEditingController();

  Future<void> verifyPhone() async {
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsOTPDialog(context).then((value) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => Get_Location()));
      });
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: '+20' + this.phoneNo, // PHONE NUMBER TO SEND OTP
          codeAutoRetrievalTimeout: (String verId) {
            //Starts the phone number verification process for the given phone number.
            //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.
            this.verificationId = verId;
          },
          codeSent:
              smsOTPSent, // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
          timeout: const Duration(seconds: 20),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            print(phoneAuthCredential);
          },
          verificationFailed: (AuthException exceptio) {
            print('${exceptio.message}');
          });
    } catch (e) {
      handleError(e);
    }
  }

  Future<bool> smsOTPDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter SMS Code'),
            content: Container(
              height: 85,
              child: Column(children: [
                TextField(
                  onChanged: (value) {
                    this.smsOTP = value;
                  },
                  controller: massege,
                ),
                (errorMessage != ''
                    ? Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red),
                      )
                    : Container())
              ]),
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              FlatButton(
                child: Text('Done'),
                onPressed: () {
                  _auth.currentUser().then((user) async {
                    Firestore.instance
                        .collection('user')
                        .document(phoneNo)
                        .setData({
                      'id': phoneNo,
                      'name': _nameController.text,
                      'phone': phoneNo,
                    });
                    if (this.smsOTP == massege.text &&
                        massege.toString().isNotEmpty) {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => Get_Location()),
                          (Route<dynamic> route) => false);
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString('phone', this.phoneNo);
                    } else {
                      Navigator.pop(context);
                      Text('The Code is Not Correct');
                    }
                  });
                },
              )
            ],
          );
        });
  }

  signIn() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: smsOTP,
      );
      final FirebaseUser user =
          (await _auth.signInWithCredential(credential)) as FirebaseUser;
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/SecondSplash', (Route<dynamic> route) => false);
    } catch (e) {
      handleError(e);
    }
  }

  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          errorMessage = 'Invalid Code';
        });
        //  Navigator.of(context).pop();
        smsOTPDialog(context).then((value) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/SecondSplash', (Route<dynamic> route) => false);
        });
        break;
      default:
        setState(() {
          errorMessage = error.message;
        });

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Container(
                    padding: EdgeInsets.all(25.0),
                    child: Form(
                      key: formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 100,
                            ),
                            Center(
                              child: SizedBox(
                                  width: 170,
                                  height: 170,
                                  child: SvgPicture.asset(
                                      'assets/images/logofinal.svg')),
                            ),
                            //returnImage(),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 5.0, bottom: 10),
                              child: TextFormField(
                                controller: _nameController,
                                decoration: new InputDecoration(
                                  labelText: "Enter Your Name",
                                  labelStyle: TextStyle(color: Colors.grey),
                                  focusedBorder: new OutlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.blue[700]),
                                  ),
                                  border: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(20.0),
                                    borderSide:
                                        new BorderSide(color: Colors.black),
                                  ),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Name is Required';
                                  }
                                  return null;
                                },
                              ),
                            ),

                            SizedBox(height: 15.0),
                            TextFormField(
                              // textCapitalization: TextCapitalization.words,
                              keyboardType: TextInputType.phone,

                              autofocus: false,
                              maxLength: 11,
                              onChanged: (value) {
                                this.phoneNo = value;
                              },
                              // controller: _phoneNumber,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Phone is Required';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                prefix: Container(
                                  padding: EdgeInsets.all(4.0),
                                  child: Text(
                                    "+20",
                                    style: TextStyle(
                                        color: myColors.red,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(left: 5.0),
                                  child: Icon(
                                    Icons.phone,
                                    color: myColors.red,
                                  ), // icon is 48px widget.
                                ),
                                hintText: 'Enter your Phone Number',
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                              ),
                            ),
                            (errorMessage != ''
                                ? Text(
                                    errorMessage,
                                    style: TextStyle(color: Colors.red),
                                  )
                                : Container()),
                            SizedBox(
                              height: 40,
                            ),
                            Container(
                              width: 400,
                              height: 50,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(13.0),
                                ),
                                color: myColors.Primary,
                                child: Text('Sign In',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white)),
                                onPressed: () {
                                  if (formKey.currentState.validate()) {
                                    print("Process data");
                                  } else {
                                    print('Error');
                                  }
                                  verifyPhone();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /* @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Center(
          child: Container(
              padding: EdgeInsets.all(25.0),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Text(
                          "Register",
                          style: TextStyle(
                            fontFamily: 'Bold',
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          width: 170,
                          height: 170,
                          child: Image(
                            image: AssetImage('assets/shader.png'),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      //returnImage(),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(height: 15.0),
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        keyboardType: TextInputType.phone,
                        autofocus: false,
                        maxLength: 11,
                        controller: _phoneNumber,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Phone is Required';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefix: Container(
                            padding: EdgeInsets.all(4.0),
                            child: Text(
                              "+20",
                              style: TextStyle(
                                  color: myColors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 5.0),
                            child: Icon(
                              Icons.phone,
                              color: myColors.red,
                            ), // icon is 48px widget.
                          ),
                          hintText: 'Enter your Phone Number',
                          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                        ),
                      ),
                      error(),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: FlatButton(
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          child: Text(
                            'Sign Up',
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
                          onPressed: () {
                            NewSignup();
                            //signUp();
                          },
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 50.0, right: 50),
                        child: Center(
                          child: Row(
                            children: <Widget>[
                              Text('I already have an account. '),
                              InkWell(
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                      color: myColors.red,
                                      fontFamily: "Bold",
                                      fontSize: 18),
                                ),
                                onTap: () {
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                                      builder: (BuildContext context) => LoginPage()));                   },
                              ),
                            ],
                          ),
                        ),
                      ),
                   ],
                  ),
                ),
              )),
        ));
  }*/
  bool _autovalidation = false;
  bool _isLoading = false;
  bool check = false;

  Widget error() {
    if (text == null) {
      return Text('');
    } else {
      return Text(
        text,
        style: TextStyle(color: Colors.red),
      );
    }
  }

  // NewSignup() {
  //   if (!formKey.currentState.validate()) {
  //     setState(() {
  //       _autovalidation = true;
  //     });
  //   } else {
  //     setState(() {
  //       _isLoading = true;
  //       _autovalidation = false;
  //     });
  //     FirebaseAuth.instance
  //         .createUserWithEmailAndPassword(
  //             email: _emailController.text, password: _passwordController.text)
  //         .then((signedInUser) async {
  //       FirebaseUser user = await FirebaseAuth.instance.currentUser();
  //       print(user.uid);
  //       Firestore.instance.collection('user').document().setData({
  //         'id': user.uid,
  //         'phone': _phoneNumber.text,
  //       });
  //       //SharedPreferences prefs = await SharedPreferences.getInstance();
  //       //prefs.setString('email', _emailController.text);
  //       Navigator.of(context).pushReplacement(MaterialPageRoute(
  //           builder: (BuildContext context) => SecondSplash()));
  //     }).catchError((e) {
  //       print(e);
  //       print(e.code);
  //       text = e.code;
  //       Toast.show("${e.code}", context,
  //           duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
  //     });
  //   }

  //   signUp() async {
  //     FirebaseAuth.instance
  //         .createUserWithEmailAndPassword(
  //             email: '_emailController.text',
  //             password: '_passwordController.text')
  //         .then((signedInUser) async {
  //       /*  Firestore.instance
  //         .collection('selectedarea')
  //         .document("${user.uid}")
  //         .setData({
  //       'email': _emailController.text,
  //       'password': _passwordController.text,
  //       'name': _nameController.text,
  //       'phone': _phoneNumber.text,
  //       'uid': user.uid,
  //       //    'imageurl': _uploadedFileURL,
  //       //   'national_id':"https://i.ibb.co/khV5wXx/Whats-App-Image-2020-07-26-at-4-56-26-AM.jpg",
  //     });*/
  //       Navigator.of(context).pushReplacement(
  //           MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
  //     }).catchError((e) {
  //       print(e);
  //     });
  //     //SharedPreferences prefs = await SharedPreferences.getInstance();
  //     //prefs.setString('email', _emailController.text);
  //   }
  // }
}
