import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Somali_Yurecipe/Screen/BottomNavBar/BottomNavBar.dart';
import 'package:Somali_Yurecipe/Screen/Settings/Bloc.dart';
import 'package:Somali_Yurecipe/Widget/loader_animation/dot.dart';
import 'package:Somali_Yurecipe/Widget/loader_animation/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'SignIn.dart';

class SignUp extends StatefulWidget {
  ThemeBloc themeBloc;

  SignUp({this.themeBloc});

  @override
  _SignUpState createState() => _SignUpState(themeBloc);
}

class _SignUpState extends State<SignUp> {
  ThemeBloc themeBloc;
  _SignUpState(this.themeBloc);
  bool isLoading = false;
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  String _email, _pass, _pass2, _name;
  var profilePicUrl;
  TextEditingController signupEmailController = new TextEditingController();
  TextEditingController signupNameController = new TextEditingController();
  TextEditingController signupPasswordController = new TextEditingController();
  TextEditingController signupConfirmPasswordController =
      new TextEditingController();
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ?

          ///
          /// Loading layout login
          ///
          Center(
              child: ColorLoader5(
              dotOneColor: Colors.red,
              dotTwoColor: Colors.blueAccent,
              dotThreeColor: Colors.green,
              dotType: DotType.circle,
              dotIcon: Icon(Icons.adjust),
              duration: Duration(seconds: 1),
            ))
          : SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  Container(
                    height: _height,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                "https://images.pexels.com/photos/3987395/pexels-photo-3987395.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260"),
                            fit: BoxFit.cover)),
                  ),
                  Container(
                    height: _height,
                    width: double.infinity,
                    decoration:
                        BoxDecoration(color: Colors.black12.withOpacity(0.05)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 230.0),
                    child: Container(
                      height: _height,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0)),
                          color: Colors.white),
                      child: Form(
                        key: _registerFormKey,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 30.0,
                            ),
                            Text(
                              "Create Account",
                              style: TextStyle(
                                  fontFamily: "Sofia",
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 28.0),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 40.0),
                              child: Container(
                                height: 53.5,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 6.0,
                                        color: Colors.black12.withOpacity(0.05),
                                        spreadRadius: 1.0)
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12.0, right: 12.0, top: 5.0),
                                  child: Theme(
                                    data: ThemeData(
                                        hintColor: Colors.transparent),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: TextFormField(
                                        validator: (input) {
                                          if (input.isEmpty) {
                                            return 'Please input your name';
                                          }
                                        },
                                        onSaved: (input) => _name = input,
                                        controller: signupNameController,
                                        style:
                                            new TextStyle(color: Colors.black),
                                        textAlign: TextAlign.start,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        autocorrect: false,
                                        autofocus: false,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.all(0.0),
                                            filled: true,
                                            fillColor: Colors.transparent,
                                            labelText: 'Username',
                                            hintStyle: TextStyle(
                                                color: Colors.black38),
                                            labelStyle: TextStyle(
                                              fontFamily: "Sofia",
                                              color: Colors.black38,
                                            )),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 15.0),
                              child: Container(
                                height: 53.5,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 6.0,
                                        color: Colors.black12.withOpacity(0.05),
                                        spreadRadius: 1.0)
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12.0, right: 12.0, top: 5.0),
                                  child: Theme(
                                    data: ThemeData(
                                        hintColor: Colors.transparent),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: TextFormField(
                                        validator: (input) {
                                          if (input.isEmpty) {
                                            return 'Please input your email';
                                          }
                                        },
                                        onSaved: (input) => _email = input,
                                        controller: signupEmailController,
                                        style:
                                            new TextStyle(color: Colors.black),
                                        textAlign: TextAlign.start,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        autocorrect: false,
                                        autofocus: false,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.all(0.0),
                                            filled: true,
                                            fillColor: Colors.transparent,
                                            labelText: 'Email',
                                            hintStyle: TextStyle(
                                                color: Colors.black38),
                                            labelStyle: TextStyle(
                                              fontFamily: "Sofia",
                                              color: Colors.black38,
                                            )),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 15.0),
                              child: Container(
                                height: 53.5,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 6.0,
                                        color: Colors.black12.withOpacity(0.05),
                                        spreadRadius: 1.0)
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12.0, right: 12.0, top: 5.0),
                                  child: Theme(
                                    data: ThemeData(
                                        hintColor: Colors.transparent),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: TextFormField(
                                        controller: signupPasswordController,
                                        validator: (input) {
                                          if (input.isEmpty) {
                                            return 'Please input your password';
                                          }
                                          if (input.length < 8) {
                                            return 'Input more 8 character';
                                          }
                                        },
                                        onSaved: (input) => _pass = input,
                                        style:
                                            new TextStyle(color: Colors.black),
                                        textAlign: TextAlign.start,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        autocorrect: false,
                                        obscureText: true,
                                        autofocus: false,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.all(0.0),
                                            filled: true,
                                            fillColor: Colors.transparent,
                                            labelText: 'Password',
                                            hintStyle: TextStyle(
                                                color: Colors.black38),
                                            labelStyle: TextStyle(
                                              fontFamily: "Sofia",
                                              color: Colors.black38,
                                            )),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0, top: 64.0),
                              child: InkWell(
                                onTap: () async {
                                  SharedPreferences prefs;
                                  prefs = await SharedPreferences.getInstance();
                                  final formState =
                                      _registerFormKey.currentState;
                                  if (formState.validate()) {
                                    formState.save();
                                    setState(() {
                                      isLoading = true;
                                    });
                                    try {
                                      prefs.setString("username", _name);
                                      prefs.setString("email", _email);
                                      prefs.setString(
                                          "photoURL", profilePicUrl.toString());
                                      FirebaseAuth.instance
                                          .createUserWithEmailAndPassword(
                                              email: signupEmailController.text
                                                  .trim(),
                                              password:
                                                  signupPasswordController.text)
                                          .then((currentUser) => Firestore
                                              .instance
                                              .collection("users")
                                              .document(currentUser.uid)
                                              .setData({
                                                "uid": currentUser.uid,
                                                "name":
                                                    signupNameController.text,
                                                "email":
                                                    signupEmailController.text,
                                                "password":
                                                    signupPasswordController
                                                        .text,
                                              })
                                              .then((result) => {
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                            PageRouteBuilder(
                                                                pageBuilder: (_,
                                                                        __,
                                                                        ___) =>
                                                                    new BottomNavBar(
                                                                      idUser:
                                                                          currentUser
                                                                              .uid,
                                                                      themeBloc:
                                                                          themeBloc,
                                                                    ))),
                                                  })
                                              .catchError((err) => print(err)))
                                          .catchError((err) => print(err));
                                    } catch (e) {
                                      print(e.message);
                                      print(_email);
                                      print(_pass);
                                    }
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("Error"),
                                            content:
                                                Text("Please input all form"),
                                            actions: <Widget>[
                                              ElevatedButton(
                                                child: Text("Close"),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              )
                                            ],
                                          );
                                        });
                                  }
                                },
                                child: Container(
                                  height: 52.0,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(80.0),
                                    gradient: LinearGradient(colors: [
                                      Color(0xFFFEE140),
                                      Color(0xFFFF942F),
                                    ]),
                                  ),
                                  child: Center(
                                      child: Text(
                                    "Signup",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: "Sofia",
                                        letterSpacing: 0.9),
                                  )),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 18.0,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                    PageRouteBuilder(
                                        pageBuilder: (_, __, ___) => SignIn()));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Have an account?",
                                    style: TextStyle(
                                        fontFamily: "Sofia",
                                        color: Colors.black38,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15.0),
                                  ),
                                  Text(" Signin",
                                      style: TextStyle(
                                          fontFamily: "Sofia",
                                          color: Color(0xFFFF942F),
                                          fontWeight: FontWeight.w300,
                                          fontSize: 15.0))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
