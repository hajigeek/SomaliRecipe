import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Somali_Yurecipe/Screen/B3_Favorite_Screen/B3_Favorite_Screen.dart';
import 'package:Somali_Yurecipe/Widget/loader_animation/dot.dart';
import 'package:Somali_Yurecipe/Widget/loader_animation/loader.dart';
import 'package:uuid/uuid.dart';

class ShoppingSearch extends StatefulWidget {
  String userId;
  ShoppingSearch({this.userId});

  @override
  _ShoppingSearchState createState() => _ShoppingSearchState();
}

class _ShoppingSearchState extends State<ShoppingSearch> {
  TextEditingController _addNameController;
  String searchString;

  bool load = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 3), () {
      setState(() {
        load = false;
      });
    });
    _addNameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    // Create uuid object
    var uuid = Uuid();

    // Generate a v4 (random) id
    var v4 = uuid.v4(); // -> '110ec58a-a0f2-4ac4-8393-c866d813b8d1'

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 18.0),
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black54,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 25.0, right: 20.0, left: 20.0, bottom: 20.0),
                      child: Container(
                        height: 50.0,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 15.0,
                                  spreadRadius: 0.0)
                            ]),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 20.0,
                              right: 10.0,
                            ),
                            child: Theme(
                              data: ThemeData(hintColor: Colors.transparent),
                              child: TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    searchString = value.toLowerCase();
                                  });
                                },
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    icon: Icon(
                                      Icons.search,
                                      color: Colors.orangeAccent,
                                      size: 28.0,
                                    ),
                                    hintText: "Search",
                                    hintStyle: TextStyle(
                                        color: Colors.black38,
                                        fontFamily: "Sofia",
                                        fontWeight: FontWeight.w400)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              StreamBuilder<QuerySnapshot>(
                stream: (searchString == null || searchString.trim() == "")
                    ? Firestore.instance.collection("shopping").snapshots()
                    : Firestore.instance
                        .collection("shopping")
                        .where("searchIndex", arrayContains: searchString)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');
                  if (searchString == null) return _searchNull();
                  if (searchString.trim() == "") return _searchNull();
                  if (snapshot.data.documents.isEmpty)
                    return StreamBuilder(
                      stream:
                          Firestore.instance.collection("shopping").snapshots(),
                      builder: (BuildContext ctx,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return new Container(
                            height: 190.0,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        "https://firebasestorage.googleapis.com/v0/b/recipeadmin-9b5fb.appspot.com/o/chef.png?alt=media&token=fa89a098-7e68-45d6-b58d-0cfbaef189cc"))),
                          );
                        }
                        return snapshot.hasData
                            ? new CardListShopping(
                                dataUser: widget.userId,
                                list: snapshot.data.documents,
                                v4: v4)
                            : SizedBox();
                      },
                    );
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Padding(
                        padding: const EdgeInsets.only(top: 110.0),
                        child: Center(
                            child: ColorLoader5(
                          dotOneColor: Colors.red,
                          dotTwoColor: Colors.blueAccent,
                          dotThreeColor: Colors.green,
                          dotType: DotType.circle,
                          dotIcon: Icon(Icons.adjust),
                          duration: Duration(seconds: 1),
                        )),
                      );
                    default:
                      return new Column(
                          children: snapshot.data.documents
                              .map((DocumentSnapshot document) {
                        return InkWell(
                          onTap: () {
                            Firestore.instance.runTransaction(
                                (Transaction transaction) async {
                              Firestore.instance
                                  .collection("users")
                                  .document(widget.userId)
                                  .collection('ShoppingList')
                                  .document(v4 + widget.userId)
                                  .setData({
                                "user": widget.userId,
                                "name": document['name'],
                                "category": document['category'],
                                "id": v4,
                              });
                            });
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0,
                                right: 10.0,
                                top: 10.0,
                                bottom: 10.0),
                            child: Container(
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.add,
                                    color: Colors.orangeAccent,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    document['name'],
                                    style: TextStyle(
                                      fontFamily: "Sofia",
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList());
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchNull() {
    return Container(
      width: 800.0,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 150.0)),
            Image.asset(
              "assets/image/search.png",
              height: 200.0,
            ),
            Padding(padding: EdgeInsets.only(bottom: 10.0)),
            Text(
              "Search Material Shopping Item",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 17.5,
                  color: Colors.black26.withOpacity(0.3),
                  fontFamily: "Popins"),
            ),
          ],
        ),
      ),
    );
  }
}

class CardListShopping extends StatelessWidget {
  String dataUser, v4;
  final List<DocumentSnapshot> list;
  CardListShopping({this.dataUser, this.list, this.v4});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.only(top: 0.0),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        primary: false,
        itemCount: list.length,
        itemBuilder: (context, i) {
          String name = list[i].data['name'].toString();
          String category = list[i].data['category'].toString();
          return InkWell(
            onTap: () {
              Firestore.instance
                  .runTransaction((Transaction transaction) async {
                Firestore.instance
                    .collection("users")
                    .document(dataUser)
                    .collection('ShoppingList')
                    .document(v4 + dataUser)
                    .setData({
                  "user": dataUser,
                  "name": name,
                  "category": category,
                  "id": v4,
                });
              });
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
              child: Container(
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.add,
                      color: Colors.orangeAccent,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      name,
                      style: TextStyle(
                        fontFamily: "Sofia",
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
