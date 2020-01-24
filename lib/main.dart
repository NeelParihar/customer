import 'package:customer/root_page.dart';
import 'package:flutter/material.dart';
import 'auth.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     return MaterialApp(
      home: RootPage(auth: new Auth()),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepOrange, primaryColor: Colors.indigo),
    );

//     FirebaseAuth.instance.currentUser().then((firebaseUser){
//      if(firebaseUser == null)
//      {
//        return MaterialApp(
//            debugShowCheckedModeBanner: false,
//            theme: ThemeData(
//                primarySwatch: Colors.deepOrange, primaryColor: Colors.indigo),
//            home: MainLogin()
//        );
//        //signed out
//      }
//      else{
//        return MaterialApp(
//            debugShowCheckedModeBanner: false,
//            theme: ThemeData(
//                primarySwatch: Colors.deepOrange, primaryColor: Colors.indigo),
//            home: Home()
//        );
//        //signed in
//      }
//    });
//     return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//             primarySwatch: Colors.deepOrange, primaryColor: Colors.indigo),
//         home: MainLogin()
//     );



  }

}
