import 'dart:async';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Somali_Yurecipe/Screen/BottomNavBar/BottomNavBar.dart';
import 'package:Somali_Yurecipe/Screen/Login/onBoarding.dart';
import 'package:Somali_Yurecipe/Screen/Settings/Bloc.dart';
import 'package:Somali_Yurecipe/Style/Style.dart';
import 'dart:io' show Platform;
import 'package:shared_preferences/shared_preferences.dart';

import 'ChosseLogin.dart';

class Splash extends StatefulWidget {
  Splash({Key key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  /// Create _themeBloc for double theme (Dark and White themse)

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_themeBloc = ThemeBloc();
  }

  @override
  Widget build(BuildContext context) {
    ///Set color status bar
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
    ));

    /// To set orientation always portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Best Somali Recipe APP',
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          primaryColorLight: Colors.white,
          primaryColorBrightness: Brightness.light,
          primaryColor: Colors.white),
    );
  }
}

class SplashScreen extends StatefulWidget {
  ThemeBloc themeBloc;
  SplashScreen({this.themeBloc});
  @override
  _SplashScreenState createState() => _SplashScreenState(themeBloc);
}

class _SplashScreenState extends State<SplashScreen> {
  var _connectionStatus = 'Unknown';
  Connectivity connectivity;
  StreamSubscription<ConnectivityResult> subscription;

  bool _connection = false;

  ThemeBloc themeBloc;
  _SplashScreenState(this.themeBloc);

  @override
  void _Navigator() {
    FirebaseAuth.instance
        .currentUser()
        .then((currentUser) => {
              if (currentUser == null)
                {
                  Navigator.of(context).pushReplacement(PageRouteBuilder(
                    pageBuilder: (_, __, ___) =>
                        chooseLogin(themeBloc: themeBloc),
                  ))
                }
              else
                {
                  Firestore.instance
                      .collection("users")
                      .document(currentUser.uid)
                      .get()
                      .then((DocumentSnapshot result) =>
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BottomNavBar(
                                        idUser: currentUser.uid,
                                        themeBloc: themeBloc,
                                      ))))
                      .catchError((err) => print(err))
                }
            })
        .catchError((err) => print(err));
  }

  /// Set timer SplashScreen
  _timer() async {
    return Timer(Duration(milliseconds: 1000), _Navigator);
  }

  @override
  void initState() {
    super.initState();

    ///
    /// Check connectivity
    ///
    connectivity = new Connectivity();
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _connectionStatus = result.toString();
      print(_connectionStatus);
      if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile) {
        setState(() {
          _timer();
          _connection = false;
        });
      } else {
        setState(() {
          _connection = true;
        });
      }
    });

    if (Platform.isAndroid) {
      // Android-specific code
    } else if (Platform.isIOS) {
      _timer();
      // iOS-specific code
    }

    @override
    void dispose() {
      subscription.cancel();
      super.dispose();
    }
  }

  /// Check user
  bool _checkUser = true;

  bool loggedIn = false;

  @override
  SharedPreferences prefs;

  ///
  /// Checking user is logged in or not logged in
  ///
  Future<Null> _function() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    this.setState(() {
      if (prefs.getString("username") != null) {
        print('false');
        _checkUser = false;
      } else {
        print('true');
        _checkUser = true;
      }
    });
  }

  Widget build(BuildContext context) {
    return _connection

        ///
        /// Layout if user not connect internet
        ///
        ? Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: <Widget>[
                SizedBox(
                  height: 150.0,
                ),
                Container(
                  height: 270.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/image/noInternet.png")),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "No Connection",
                  style: TextStyle(
                      fontSize: 25.0,
                      fontFamily: "Sofia",
                      letterSpacing: 1.1,
                      fontWeight: FontWeight.w700,
                      color: colorStyle.primaryColor),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                  child: Text(
                    "No internet connection found. Check your connection or try again",
                    style: TextStyle(
                      fontSize: 17.0,
                      fontFamily: "Sofia",
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          )
        : Scaffold(
            body: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image:
                              AssetImage("assets/image/splashBackground.png"),
                          fit: BoxFit.cover)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 90.0),
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        "Best Somali Recipe App",
                        style: TextStyle(
                            fontFamily: "Lemon",
                            fontSize: 50.0,
                            color: Colors.black),
                      )),
                ),
              ],
            ),
          );
  }
}
