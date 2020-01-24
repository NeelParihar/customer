import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';

import 'package:mailer2/mailer.dart';
import 'auth.dart';

class Home extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  Home({Key key, this.auth, this.onSignedOut}) : super(key: key);

  final drawerItems = [
    new DrawerItem("Booking", GroovinMaterialIcons.package_variant),
    new DrawerItem("Some Page", Icons.local_pizza),
    new DrawerItem(" Some Page2", Icons.info)
  ];

  @override
  _HomeState createState() => _HomeState();
}

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}


class _HomeState extends State<Home> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String _selectedDate = DateTime.now().year.toString() + '-' + DateTime.now().month.toString() + '-' + DateTime.now().day.toString();
  String _selectedTime = '';
  bool isChecked = false;

  String _pickUp, _destination;
  String _noofparcel, _weightofparcel, _codAmount;
  int _selectedDrawerIndex = 0;
  String name,email,phoneno;





  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
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
                      SizedBox(height: ScreenUtil.getInstance().setHeight(100)),
                      buildform(),
                      SizedBox(height: ScreenUtil.getInstance().setHeight(40)),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      case 1:
        return Center(child: new Text("Booked Orders"));
      case 2:
        return Center(child: new Text("new3"));

      default:
        return Center(child: new Text("Error"));
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserdetails();

  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _selectedTime=TimeOfDay.now().format(context);
    });

    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(new ListTile(
        leading: new Icon(d.icon),
        title: new Text(d.title),
        selected: i == _selectedDrawerIndex,
        onTap: () => _onSelectItem(i),
      ));
    }

    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true);


    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Image.asset("assets/logo.png"),
        centerTitle: true,
        leading: new IconButton(
            iconSize: 50,
            padding: EdgeInsets.only(left: 0.1),
            color: Colors.indigo,
            icon: new Icon(GroovinMaterialIcons.sort_variant),
            onPressed: () => _scaffoldKey.currentState.openDrawer()),
        actions: <Widget>[
          new IconButton(
            iconSize: 40,
            color: Colors.orange,
            icon: new Icon(GroovinMaterialIcons.logout),
            onPressed: () {
              _showDialog();
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      body: _getDrawerItemWidget(_selectedDrawerIndex),
      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            new UserAccountsDrawerHeader(
                accountName: Text(''), accountEmail: Text('${email}')),
            new Column(children: drawerOptions)
          ],
        ),
      ),
    );
  }
  

  buildform() {
    return Container(
      width: double.infinity,
      height: ScreenUtil.getInstance().setHeight(1200),
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
            children: <Widget>[
              Text("Add Booking Details",
                  style: TextStyle(
                      fontSize: ScreenUtil.getInstance().setSp(45),
                      fontFamily: "Poppins-Bold",
                      letterSpacing: .6)),
              Expanded(
                child: new TextFormField(
                  onSaved: (pickup) => _pickUp = pickup,
                  validator: (pickup) {
                    if (pickup.isEmpty) {
                      return 'Please enter a valid PickUp Address';
                    }
                  },
                  decoration: const InputDecoration(
                    icon: const Icon(GroovinMaterialIcons.circle_outline),
                    hintText: 'Enter Pickup Adddress',
                    labelText: 'Pickup Adddress',
                  ),
                  keyboardType: TextInputType.multiline,
                ),
              ),
              Expanded(
                child: new TextFormField(
                  onSaved: (destination) => _destination = destination,
                  validator: (destination) {
                    if (destination.isEmpty) {
                      return 'Please enter a valid Destination Address';
                    }
                  },
                  decoration: const InputDecoration(
                    icon: const Icon(GroovinMaterialIcons.truck_delivery),
                    hintText: 'Enter Destination Address',
                    labelText: 'Destination Address',
                  ),
                  keyboardType: TextInputType.multiline,
                ),
              ),
              Expanded(
                child: new TextFormField(
                  onSaved: (noofparcel) => _noofparcel = noofparcel,
                  validator: (noofparcel) {
                    if (noofparcel.isEmpty) {
                      return "Please enter  No Of Parcel's";
                    }
                  },
                  decoration: const InputDecoration(
                    icon: Icon(GroovinMaterialIcons.package_variant),
                    hintText: 'Enter Number Of Parcel',
                    labelText: 'Number Of Parcel',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                  ],
                ),
              ),
              Expanded(
                child: TextFormField(
                  onSaved: (weight) => _weightofparcel = weight,
                  validator: (weight) {
                    if (weight.isEmpty) {
                      return 'Please Enter Weight Of Parcel ';
                    }
                  },
                  decoration: const InputDecoration(
                    icon: Icon(GroovinMaterialIcons.weight_kilogram),
                    hintText: 'Enter Weight Of Parcel',
                    labelText: 'Weight Of Parcel',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                  ],
                ),
              ),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(30),
              ),
              Text("Pick a Date and Time For Delivery ",
                  style:
                      TextStyle(fontFamily: "Poppins-Bold", letterSpacing: .6)),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            FlatButton.icon(
                              icon: Icon(Icons.date_range),
                              onPressed: () => _selectDate(context),
                              label: Text("DATE"),
                              splashColor: Theme.of(context).accentColor,
                            ),
                            Text("$_selectedDate")
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            FlatButton.icon(
                              onPressed: () => _selectTime(context),
                              label: Text("TIME"),
                              splashColor: Theme.of(context).accentColor,
                              icon: Icon(Icons.access_time),
                            ),
                            Text("$_selectedTime")
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Checkbox(
                        value: isChecked,
                        onChanged: (value) {
                          setState(() {
                            isChecked = value;
                          });
                        },
                      ),
                      Text("COD"),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: isChecked
                    ? (TextFormField(
                        onSaved: (cod) => _codAmount = cod,
                        validator: (cod) {
                          if (cod.isEmpty && isChecked) {
                            return 'Please Enter COD Amount ';
                          }
                        },
                        decoration: const InputDecoration(
                          icon: Icon(GroovinMaterialIcons.cash_multiple),
                          hintText: 'Enter Amount Of COD',
                          labelText: 'Amount Of COD',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                        ],
                      ))
                    : Container(),
              ),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(30),
              ),
              InkWell(
                child: Container(
                  width: ScreenUtil.getInstance().setWidth(450),
                  height: ScreenUtil.getInstance().setHeight(75),
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
                        _book();
                      },
                      child: Center(
                        child: Text("BOOK",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Poppins-Bold",
                                fontSize: 18,
                                letterSpacing: 1.0)),
                      ),
                    ),
                  ),
                ),
                onTap: null,
              ),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(30),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _selectedDate = selectedDate.year.toString() +
            '-' +
            selectedDate.month.toString() +
            '-' +
            selectedDate.day.toString();
      });
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Logout?"),
          content: new Text("Are you sure you want to logout?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Logout"),
              onPressed: () async {
                try {
                  await widget.auth.signOut();
                  widget.onSignedOut();
                  Navigator.pop(context);
                } catch (e) {
                  print(e);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: selectedTime);
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        _selectedTime = selectedTime.format(context);
      });
    }
  }

  void _book() async {
    print("bbbbbbbb");

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      ProgressDialog pr =
          new ProgressDialog(context, ProgressDialogType.Normal);
      pr.show();

      var options = new GmailSmtpOptions()
        ..username = 'vimlaparihar00'
        ..password =
            '9870154473'; // Note: if you have Google's "app specific passwords" enabled,
      // you need to use one of those here.

      // How you use and store passwords is up to you. Beware of storing passwords in plain.

      // Create our email transport.
      var emailTransport = new SmtpTransport(options);

      // Create our mail/envelope.
      var envelope = new Envelope()
        ..from = 'vimlaparihar00@gmail.com'
        ..recipients = [
          'support@pickanddeliver.com'
        ]
        ..subject = 'New Order!!!!'
        ..html =
            """<h1 style="text-align: center;"><span style="text-decoration: underline;"><strong>Order Details</strong></span></h1>
            <table style="height: 491px; float: left;" border="2" width="665">
    <tbody>
    
    <tr>
    <td style="width: 276px;">
    <h3>Booking Number:</h3>
    </td>
    <td style="width: 373px;">${orderNumber()}</td>
    </tr>
    <tr style="height: 71px;">
    <td style="width: 276px; height: 71px;">
    <h3>Pickup Address :</h3>
    </td>
    <td style="width: 373px; height: 71px;">$_pickUp</td>
    </tr>
    <tr style="height: 72px;">
    <td style="width: 276px; height: 72px;">
    <h3>Delivery address:</h3>
    </td>
    <td style="width: 373px; height: 72px;">$_destination</td>
    </tr>
    <tr style="height: 72px;">
    <td style="width: 276px; height: 72px;">
    <h3>Date and Time:</h3>
    </td>
    <td style="width: 373px; height: 72px;">${_selectedDate + "--" + _selectedTime}</td>
    </tr>
    <tr style="height: 72px;">
    <td style="width: 276px; height: 72px;">
    <h3>No Of Parcel:</h3>
    </td>
    <td style="width: 373px; height: 72px;">$_noofparcel</td>
    </tr>
    <tr>
    <td style="width: 276px;">
    <h3>Weight of Parcel:</h3>
    </td>
    <td style="width: 373px;">$_weightofparcel Kg</td>
    </tr>
    <tr>
    <td style="width: 276px;">
    <h3>Email Id:</h3>
    </td>
    <td style="width: 373px;">$email</td>
    </tr>
    <tr>
    <td style="width: 276px;">
    <h3>Mobile Number:</h3>
    </td>
    <td style="width: 373px;">$phoneno</td>
    </tr>
    </tbody>
    </table>""";

      // Email it.
      emailTransport.send(envelope).then((envelope) {
        print('Email sent!');
        pr.hide();
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text('Booking Sucessfull!!')));
      }).catchError((e) {
        print('Error occurred: $e');
        pr.hide();
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text('Something Went Wrong...')));
      });
    }
  }
   getUserdetails() async {
    await FirebaseAuth.instance.currentUser().then((user1) {
     setState(() {
       name=user1.displayName;
       email=user1.email;
       phoneno=user1.phoneNumber;
     });
     });
}


  orderNumber() {
    int now; // '1492341545873'
    // pad with extra random digit
    // formatfinal String uuid = GUIDGen.generate()
    now = new DateTime.now().millisecondsSinceEpoch;
    print(new DateTime.now().millisecondsSinceEpoch);
    return now.toString().substring(0, 4) +
        "-" +
        now.toString().substring(4, 8) +
        "-" +
        now.toString().substring(9);
  }


}




