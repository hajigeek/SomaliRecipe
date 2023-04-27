import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Somali_Yurecipe/Screen/B4_Profile_Screen/YourRecipes.dart';

import 'package:Somali_Yurecipe/Screen/B4_Profile_Screen/editProfile.dart';
import 'package:Somali_Yurecipe/Screen/Login/ChosseLogin.dart';
import 'package:Somali_Yurecipe/Screen/MealPlan_Screen/MealPlan.dart';
import 'package:Somali_Yurecipe/Style/Style.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'AddRecipes.dart';
import 'aboutApps.dart';

class B4ProfileScreen extends StatefulWidget {
  String idUser;
  B4ProfileScreen({this.idUser});

  @override
  _B4ProfileScreenState createState() => _B4ProfileScreenState();
}

class _B4ProfileScreenState extends State<B4ProfileScreen> {
  @override

  ///
  /// Function for if user logout all preferences can be deleted
  ///
  _delete() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            StreamBuilder(
                stream: Firestore.instance
                    .collection('users')
                    .document(widget.idUser)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return new Stack(children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topCenter,
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                      width: 100.0,
                                      height: 100.0,
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png"),
                                              fit: BoxFit.cover),
                                          borderRadius: BorderRadius.all(Radius.circular(75.0)),
                                          boxShadow: [
                                            BoxShadow(
                                                blurRadius: 7.0,
                                                color: Colors.black26)
                                          ])),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20.0, left: 15.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Loading Name",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Sofia",
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Text(
                                      "Loading Email",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Sofia",
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                    ]);
                  }
                  var userDocument = snapshot.data;
                  var string = userDocument["name"];

                  String getInitials({String string, int limitTo}) {
                    var buffer = StringBuffer();
                    var split = string.split(' ');
                    for (var i = 0; i < (limitTo ?? split.length); i++) {
                      buffer.write(split[i][0]);
                    }

                    return buffer.toString();
                  }

                  var output = getInitials(string: string);

                  return Stack(children: <Widget>[
                    Container(
                      height: 262.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                "assets/image/background10.png",
                              ),
                              fit: BoxFit.cover)),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 67.0, left: 20.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        image: DecorationImage(
                                            image: NetworkImage(userDocument[
                                                        "photoProfile"] !=
                                                    null
                                                ? userDocument["photoProfile"]
                                                : "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png"),
                                            fit: BoxFit.cover),
                                        borderRadius: BorderRadius.all(Radius.circular(75.0)),
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 7.0,
                                              color: Colors.black26)
                                        ])),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25.0, top: 20.0),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          userDocument["name"] != null
                                              ? userDocument["name"]
                                              : "Name",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: "Sofia",
                                              fontWeight: FontWeight.w700,
                                              fontSize: 20.0),
                                        ),
                                        Text(
                                          userDocument["email"] != null
                                              ? userDocument["email"]
                                              : "Email",
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontFamily: "Sofia",
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16.0),
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                      ]),
                                ),
                              ]),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 290.0),
                      child: Column(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (_, __, ___) => new MealPlan(
                                        idUser: widget.idUser,
                                      )));
                            },
                            child: category(
                              txt: "Meal Plan",
                              image: "assets/image/mealPlan.png",
                              padding: 20.0,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (_, __, ___) => new AddRecipe(
                                        userId: widget.idUser,
                                      )));
                            },
                            child: category(
                              txt: "Add Recipes",
                              image: "assets/image/addRecipe.png",
                              padding: 20.0,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (_, __, ___) => new YourRecipes(
                                        uid: widget.idUser,
                                      )));
                            },
                            child: category(
                              txt: "Your Recipes",
                              image: "assets/image/yourRecipes.png",
                              padding: 20.0,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (_, ___, ____) =>
                                      new updateProfile(
                                        country: userDocument["country"],
                                        city: userDocument["city"],
                                        name: userDocument["name"],
                                        photoProfile: userDocument[
                                                    "photoProfile"] !=
                                                null
                                            ? userDocument["photoProfile"]
                                            : "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png",
                                        uid: widget.idUser,
                                      )));
                            },
                            child: category(
                              txt: "Edit Profile",
                              image: "assets/image/editProfile.png",
                              padding: 20.0,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              
                            },
                            child: category(
                              txt: "Call Center",
                              image: "assets/image/callCenter.png",
                              padding: 20.0,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (_, __, ___) =>
                                      new aboutApps()));
                            },
                            child: category(
                              txt: "About Apps",
                              image: "assets/image/phone.png",
                              padding: 20.0,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _delete();
                              FirebaseAuth.instance.signOut().then((result) =>
                                  Navigator.of(context).pushReplacement(
                                      PageRouteBuilder(
                                          pageBuilder: (_, ___, ____) =>
                                              new chooseLogin())));
                            },
                            child: category(
                              txt: "Logout",
                              image: "assets/image/logout.png",
                              padding: 20.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]);
                }),
          ],
        ),
      ),
    );
  }
}

/// Component category class to set list
class category extends StatelessWidget {
  @override
  String txt, image;
  GestureTapCallback tap;
  double padding;

  category({this.txt, this.image, this.tap, this.padding});

  Widget build(BuildContext context) {
    return InkWell(
      onTap: tap,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: padding),
                      child: Image.asset(
                        image,
                        height: 25.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Text(
                        txt,
                        style: TextStyle(
                          fontSize: 14.5,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Sofia",
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black26,
                    size: 15.0,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Divider(
            color: Colors.black12,
          )
        ],
      ),
    );
  }
}
