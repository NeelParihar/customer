import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'Widgets/SocialIcons.dart';
import 'CustomIcons.dart';
import 'auth.dart';

class MainLogin extends StatefulWidget {
  const MainLogin({Key key, this.auth, this.onSignedIn}) : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedIn;
  @override
  _MyAppState createState() => new _MyAppState();
}

enum FormType { login, register }

class _MyAppState extends State<MainLogin> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _email;
  String _password;
  bool _isObscured = true;
  Color _eyeButtonColor = Colors.grey;
  FormType _formType = FormType.login;
  String _user = "New User?";
  String _text = "SignUp";

  String _phoneNo;
  String smsCode;
  String verificationId;
  FirebaseUser firebaseUser;

  Widget horizontalLine() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          width: ScreenUtil.getInstance().setWidth(120),
          height: 1.0,
          color: Colors.black26.withOpacity(.2),
        ),
      );

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Image.asset("assets/courier_deliver.png"),
                ),
                Expanded(
                  child: Container(),
                ),
                Expanded(child: Image.asset("assets/image_02.png"))
              ],
            ),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 60.0),
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      "assets/logo.png",
                      height: ScreenUtil.getInstance().setHeight(120),
                    ),
                    SizedBox(height: ScreenUtil.getInstance().setHeight(100)),
                    buildform(),
                    SizedBox(height: ScreenUtil.getInstance().setHeight(40)),
                    InkWell(
                      child: Container(
                        width: ScreenUtil.getInstance().setWidth(350),
                        height: ScreenUtil.getInstance().setHeight(100),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Color(0xFF17ead9), Color(0xFF6078ea)]),
                            borderRadius: BorderRadius.circular(6.0),
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0xFF6078ea).withOpacity(.3),
                                  offset: Offset(0.0, 8.0),
                                  blurRadius: 8.0)
                            ]),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              _signIn();
                            },
                            child: Center(
                              child: Text(showtext(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Poppins-Bold",
                                      fontSize: 18,
                                      letterSpacing: 1.0)),
                            ),
                          ),
                        ),
                      ),
                      onTap: _signIn,
                    ),
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(50),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          _user,
                          style: TextStyle(fontFamily: "Poppins-Medium"),
                        ),
                        InkWell(
                          onTap: () {
                            if (_formType == FormType.login) {
                              _formKey.currentState.reset();
                              setState(() {
                                _formType = FormType.register;
                                _user = 'Old User?';
                                _text = 'SignIn';
                              });
                            } else {
                              _formKey.currentState.reset();
                              setState(() {
                                _formType = FormType.login;

                                _user = 'New User?';
                                _text = 'SignUp';
                              });
                            }
                          },
                          child: new Text(" " + _text,
                              style: TextStyle(
                                  color: Color(0xFF5d74e3),
                                  fontFamily: "Poppins-Bold")),
                        )
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(40),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        horizontalLine(),
                        Text("Social Login",
                            style: TextStyle(
                                fontSize: 16.0, fontFamily: "Poppins-Medium")),
                        horizontalLine()
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(10),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SocialIcon(
                          colors: [
                            Color(0xFFff4f38),
                            Color(0xFFff355d),
                          ],
                          iconData: CustomIcons.googlePlus,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _signIn() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      ProgressDialog pr =
          new ProgressDialog(context, ProgressDialogType.Normal);
      try {
        if (_formType == FormType.login) {
          pr.setMessage('Loging in');
          pr.show();
          String userId = await widget.auth
              .signInWithEmailAndPassword(_email.trim(), _password);
          print("signed in: $userId");
          pr.hide();
          widget.onSignedIn();
        } else {
          pr.setMessage('Registering');
          pr.show();
          verifyPhone(pr);

          print("Registered user: ${firebaseUser.toString()}");
        }

//        Navigator.pushAndRemoveUntil(
//          context,
//          MaterialPageRoute(builder: (context) => Home()),
//          (Route<dynamic> route) => false,
//        );

      } catch (e) {
        print(e);
        pr.hide();
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text('Something Went Wrong...$e')));
      }
    }
  }

  buildform() {
    if (_formType == FormType.login) {
      return new Container(
        width: double.infinity,
        height: ScreenUtil.getInstance().setHeight(530),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0.0, 15.0),
                  blurRadius: 15.0),
              BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0.0, -10.0),
                  blurRadius: 10.0),
            ]),
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Login",
                    style: TextStyle(
                        fontSize: ScreenUtil.getInstance().setSp(45),
                        fontFamily: "Poppins-Bold",
                        letterSpacing: .6)),
                SizedBox(
                  height: ScreenUtil.getInstance().setHeight(30),
                ),
                Text("Username",
                    style: TextStyle(
                        fontFamily: "Poppins-Medium",
                        fontSize: ScreenUtil.getInstance().setSp(26))),
                TextFormField(
                  decoration: InputDecoration(
                      hintText: "Username",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                  validator: (value) => value.isEmpty || !value.contains("@")
                      ? "Incorrect email"
                      : null,
                  onSaved: (value) => _email = value,
                ),
                SizedBox(
                  height: ScreenUtil.getInstance().setHeight(30),
                ),
                Text("Password",
                    style: TextStyle(
                        fontFamily: "Poppins-Medium",
                        fontSize: ScreenUtil.getInstance().setSp(26))),
                Expanded(
                  child: TextFormField(
                    onSaved: (passwordInput) => _password = passwordInput,
                    validator: (passwordInput) {
                      if (passwordInput.isEmpty) {
                        return 'Please enter a password';
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),
                      suffixIcon: IconButton(
                        onPressed: () {
                          if (_isObscured) {
                            setState(() {
                              _isObscured = false;
                              _eyeButtonColor = Theme.of(context).primaryColor;
                            });
                          } else {
                            setState(() {
                              _isObscured = true;
                              _eyeButtonColor = Colors.grey;
                            });
                          }
                        },
                        icon: Icon(
                          Icons.remove_red_eye,
                          color: _eyeButtonColor,
                        ),
                      ),
                    ),
                    obscureText: _isObscured,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "Forgot Password?",
                      style: TextStyle(
                          color: Colors.blue,
                          fontFamily: "Poppins-Medium",
                          fontSize: ScreenUtil.getInstance().setSp(28)),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
    } else {
      return new Container(
        width: double.infinity,
        height: ScreenUtil.getInstance().setHeight(790),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0.0, 15.0),
                  blurRadius: 15.0),
              BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0.0, -10.0),
                  blurRadius: 10.0),
            ]),
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("SignUp",
                    style: TextStyle(
                        fontSize: ScreenUtil.getInstance().setSp(45),
                        fontFamily: "Poppins-Bold",
                        letterSpacing: .6)),
                SizedBox(
                  height: ScreenUtil.getInstance().setHeight(10),
                ),
                Text("Enter Email",
                    style: TextStyle(
                        fontFamily: "Poppins-Medium",
                        fontSize: ScreenUtil.getInstance().setSp(26))),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: "Email",
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 12.0)),
                    validator: (value) => value.isEmpty || !value.contains("@")
                        ? "Incorrect email"
                        : null,
                    onSaved: (value) => _email = value,
                  ),
                ),
                SizedBox(
                  height: ScreenUtil.getInstance().setHeight(10),
                ),
                Text("Enter Password",
                    style: TextStyle(
                        fontFamily: "Poppins-Medium",
                        fontSize: ScreenUtil.getInstance().setSp(26))),
                Expanded(
                  child: TextFormField(
                    onSaved: (passwordInput) => _password = passwordInput,
                    validator: (passwordInput) {
                      if (passwordInput.isEmpty) {
                        return 'This Field May Not Be Blank';
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),
                      suffixIcon: IconButton(
                        onPressed: () {
                          if (_isObscured) {
                            setState(() {
                              _isObscured = false;
                              _eyeButtonColor = Theme.of(context).primaryColor;
                            });
                          } else {
                            setState(() {
                              _isObscured = true;
                              _eyeButtonColor = Colors.grey;
                            });
                          }
                        },
                        icon: Icon(
                          Icons.remove_red_eye,
                          color: _eyeButtonColor,
                        ),
                      ),
                    ),
                    obscureText: _isObscured,
                  ),
                ),
                SizedBox(
                  height: ScreenUtil.getInstance().setHeight(10),
                ),
                Text("Confirm Password",
                    style: TextStyle(
                        fontFamily: "Poppins-Medium",
                        fontSize: ScreenUtil.getInstance().setSp(26))),
                Expanded(
                  child: TextFormField(
                      validator: (passwordInput) {
                        if (passwordInput.isEmpty) {
                          return 'This Field May Not Be Blank';
                        }
                        if (identical(passwordInput, _password)) {
                          return "Password typed doesn't match";
                        }
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Re-Enter Password',
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 12.0),
                      )),
                ),
                SizedBox(
                  height: ScreenUtil.getInstance().setHeight(10),
                ),
                Text("Enter Phone Number",
                    style: TextStyle(
                        fontFamily: "Poppins-Medium",
                        fontSize: ScreenUtil.getInstance().setSp(26))),
                Expanded(
                  child: TextFormField(
                    onSaved: (phoneno) => _phoneNo = "+91" + phoneno,
                    validator: (phoneno) {
                      if (phoneno.isEmpty) {
                        return 'This Field May Not Be Blank';
                      }
                    },
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),
                      hintText: "Phone Number",
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

  String showtext() {
    if (_formType == FormType.login) {
      return "SIGNIN";
    } else {
      return "SIGNUP";
    }
  }

  Future<void> verifyPhone(ProgressDialog pr) async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationId = verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
    };
    Future<void> _linkWithPhoneNumber(AuthCredential credential) async {
      final errorMessage = "We couldn't verify your code, please try again!";
      firebaseUser = await widget.auth
          .createUserWithEmailAndPassword(_email.trim(), _password);

      await firebaseUser
          .updatePhoneNumberCredential(credential)
          .catchError((error) {
        print("Failed to verify SMS code: $errorMessage");
        _scaffoldKey.currentState.showSnackBar(
            SnackBar(content: Text('Something Went Wrong...$errorMessage')));
        //_showErrorSnackbar(errorMessage);
      }).timeout(const Duration(seconds: 100), onTimeout: () {
        pr.hide();
        _scaffoldKey.currentState.showSnackBar(
            SnackBar(content: Text('Please check your phone number')));
      });
      pr.hide();
      widget.onSignedIn();
      //await _onCodeVerified(_firebaseUser).then((codeVerified) async {
      //this._codeVerified = codeVerified;
      //Logger.log(
//        TAG,
//        message: "Returning ${this._codeVerified} from _onCodeVerified",
//      );
//      if (this._codeVerified) {
//        await _finishSignIn(_firebaseUser);
//      } else {
//        _showErrorSnackbar(errorMessage);
//      }
      //});
    }

    final PhoneVerificationFailed veriFailed = (AuthException exception) {
      print('${exception.message}');
      pr.hide();
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: this._phoneNo,
        codeAutoRetrievalTimeout: autoRetrieve,
        codeSent: smsCodeSent,
        timeout: const Duration(seconds: 5),
        verificationCompleted: _linkWithPhoneNumber,
        verificationFailed: veriFailed);
  }
}
