import 'package:customer/welcome.dart';
import 'package:flutter/material.dart';

import 'auth.dart';
import 'home.dart';


class RootPage extends StatefulWidget {

  final BaseAuth auth;
  RootPage({this.auth});

  @override
  State<StatefulWidget>createState() =>RootPageState();
}

enum AuthStatus { notSignedIn, signedIn }

class RootPageState extends State<RootPage> {

   AuthStatus authStatus =AuthStatus.notSignedIn;

  @override
  void initState() {
    super.initState();
    widget.auth.currentUser().then((userId) {
      setState(() {
        authStatus = userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
  }

  void _signedIn() {
    setState(() {
      authStatus = AuthStatus.signedIn;
    });
  }

   void _signedOut() {
    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
    case AuthStatus.notSignedIn:
    return  MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.deepOrange, primaryColor: Colors.indigo),
        home: MainLogin(
          auth: widget.auth,
          onSignedIn: _signedIn,
        )
    );
    case AuthStatus.signedIn:
    return  MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.deepOrange, primaryColor: Colors.indigo),
        home: Home(auth: widget.auth,
          onSignedOut: _signedOut,)
    );
    }

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.deepOrange, primaryColor: Colors.indigo),
        home: MainLogin(auth: widget.auth,
            onSignedIn: _signedIn,
        )
    );

  }


}