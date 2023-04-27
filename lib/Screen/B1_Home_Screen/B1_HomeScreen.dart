import 'dart:async';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Somali_Yurecipe/Screen/Search/search.dart';
import 'package:Somali_Yurecipe/Style/Style.dart';
import 'package:shimmer/shimmer.dart';

import 'Category/CategoryDetail.dart';
import 'Detail/SeeAllScreen.dart';
import 'Detail/detail_recipe.dart';

class HomeScreenT1 extends StatefulWidget {
  String userID;
  HomeScreenT1({this.userID});

  @override
  _HomeScreenT1State createState() => _HomeScreenT1State();
}

class _HomeScreenT1State extends State<HomeScreenT1> {
  @override
  List<DocumentSnapshot> _image;
  bool loadData = true;
  bool loadImage = true;

  @override
  void initState() {
    Timer(Duration(milliseconds: 3500), () {
      setState(() {
        loadData = false;
      });
    });
    Timer(Duration(milliseconds: 4500), () {
      setState(() {
        loadImage = false;
      });
    });
    // TODO: implement initState
    super.initState();
  }

  var _background = Stack(
    children: <Widget>[
      Image(
        image: AssetImage('assets/image/profileBackground.png'),
        height: 310.0,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
      Container(
        height: 325.0,
        margin: EdgeInsets.only(top: 0.0, bottom: 75.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(0.0, 1.0),
            // stops: [0.0, 1.0],
            colors: <Color>[
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.3),
              Colors.white,
              //  Color(0xFF1E2026),
            ],
          ),
        ),
      ),
    ],
  );

  var _categories = Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[],
  );

  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light));

    var _search = Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (_, __, ___) => new Search(
                      userId: widget.userID,
                    )));
          },
          child: Container(
            height: 45.0,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5.0,
                      spreadRadius: 0.0)
                ]),
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: <Widget>[
                      Icon(
                        EvaIcons.searchOutline,
                        color: Color(0xFFFF975D),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        "Find a food recipes",
                        style: TextStyle(
                            color: Colors.grey[400],
                            fontFamily: "Sofia",
                            fontSize: 16.0),
                      ),
                    ],
                  ),
                  Icon(
                    EvaIcons.activity,
                    color: Color(0xFFFF975D),
                  ),
                ],
              ),
            ),
          ),
        ));

    Future getCarouselWidget() async {
      var firestore = Firestore.instance;
      QuerySnapshot qn = await firestore.collection("banner").getDocuments();
      return qn.documents;
    }

    var _sliderImage = Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 190,
          aspectRatio: 24 / 18,
          viewportFraction: 0.9,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 3),
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          scrollDirection: Axis.horizontal,
        ),
        items: [0, 1, 2, 3, 4].map((i) {
          return FutureBuilder(
              future: getCarouselWidget(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) return Text('Error: ${snapshot.error}');

                if (!snapshot.hasData) {
                  return new Container(
                    height: 190.0,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                "https://firebasestorage.googleapis.com/v0/b/recipeadmin-9b5fb.appspot.com/o/chef.png?alt=media&token=fa89a098-7e68-45d6-b58d-0cfbaef189cc"),
                            fit: BoxFit.cover)),
                  );
                } else {
                  List<String> ingredients =
                      List.from(snapshot.data[i].data['ingredients']);
                  List<String> directions =
                      List.from(snapshot.data[i].data['directions']);
                  String title = snapshot.data[i].data['title'].toString();
                  num rating = snapshot.data[i].data['rating'];
                  String category =
                      snapshot.data[i].data['category'].toString();
                  String image = snapshot.data[i].data['image'].toString();
                  String id = snapshot.data[i].data['id'].toString();
                  String time = snapshot.data[i].data['time'].toString();
                  String calorie = snapshot.data[i].data['calorie'].toString();
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (_, __, ___) => new RecipeDetailScreen(
                                title: title,
                                id: id,
                                image: image,
                                category: category,
                                time: time,
                                userId: widget.userID,
                                rating: rating,
                                calorie: calorie,
                                directions: directions,
                                ingredient: ingredients,
                              )));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin:
                          EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 9.0,
                                spreadRadius: 7.0,
                                color: Colors.black12.withOpacity(0.03))
                          ],
                          image: DecorationImage(
                              image: NetworkImage(loadImage
                                  ? "https://firebasestorage.googleapis.com/v0/b/recipeadmin-9b5fb.appspot.com/o/chef.png?alt=media&token=fa89a098-7e68-45d6-b58d-0cfbaef189cc"
                                  : snapshot.data[i].data["imageBanner"]),
                              fit: BoxFit.cover),
                          color: Color(0xFF23252E)),
                    ),
                  );
                }
              });
        }).toList(),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          brightness: Brightness.light,
        ),
      ),
      body: loadData
          ? animationLoadData()
          : SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  _background,
                  Stack(
                    children: [
                      StreamBuilder(
                          stream: Firestore.instance
                              .collection('users')
                              .document(widget.userID)
                              .snapshots(),
                          builder: (context, snapshot) {
                            var userDocument = snapshot.data;

                            if (!snapshot.hasData) {
                              return Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, top: 40.0),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Hello ",
                                          style: TextStyle(
                                              fontFamily: "Sofia",
                                              fontWeight: FontWeight.w800,
                                              fontSize: 33.0,
                                              letterSpacing: 0.5,
                                              color: Colors.black
                                                  .withOpacity(0.7)),
                                        ),
                                        Text(
                                          "Name",
                                          style: TextStyle(
                                              fontFamily: "Sofia",
                                              fontWeight: FontWeight.w800,
                                              fontSize: 33.0,
                                              letterSpacing: 0.5,
                                              color: Colors.black
                                                  .withOpacity(0.7)),
                                        ),
                                      ]),
                                ),
                              );
                            }

                            return Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, top: 40.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Hello ",
                                        style: TextStyle(
                                            fontFamily: "Sofia",
                                            fontWeight: FontWeight.w800,
                                            fontSize: 33.0,
                                            letterSpacing: 0.5,
                                            color:
                                                Colors.black.withOpacity(0.7)),
                                      ),
                                      Text(
                                        userDocument["name"] != null
                                            ? userDocument["name"]
                                            : "Name",
                                        style: TextStyle(
                                            fontFamily: "Sofia",
                                            fontWeight: FontWeight.w800,
                                            fontSize: 33.0,
                                            letterSpacing: 0.5,
                                            color:
                                                Colors.black.withOpacity(0.7)),
                                      ),
                                    ]),
                              ),
                            );
                          }),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 120.0),
                    child: Column(
                      children: <Widget>[
                        _search,
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 30.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Categories",
                                  style: TextStyle(
                                      fontFamily: "Sofia",
                                      fontSize: 18.5,
                                      color: Colors.black.withOpacity(0.9),
                                      fontWeight: FontWeight.w600),
                                ),
                              ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10.0,
                          ),
                          child: Container(
                            height: 110.0,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: <Widget>[
                                SizedBox(
                                  width: 20.0,
                                ),
                                cardPopular(
                                    image: "assets/image/lunch.png",
                                    title: "Lunch",
                                    userId: widget.userID,
                                    category: "Lunch"),
                                cardPopular(
                                    image: "assets/image/dinner.png",
                                    title: "Dinner",
                                    userId: widget.userID,
                                    category: "Dinner"),
                                cardPopular(
                                    image: "assets/image/breakfast.png",
                                    title: "Breakfast",
                                    userId: widget.userID,
                                    category: "Breakfast"),
                              
                              ],
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 25.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Suggest",
                                      style: TextStyle(
                                          fontFamily: "Sofia",
                                          fontSize: 18.5,
                                          color: Colors.black.withOpacity(0.9),
                                          fontWeight: FontWeight.w600),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            PageRouteBuilder(
                                                pageBuilder: (_, __, ___) =>
                                                    new SeeAll(
                                                      data: "suggest",
                                                      idUser: widget.userID,
                                                    ),
                                                transitionDuration: Duration(
                                                    milliseconds: 1000),
                                                transitionsBuilder: (_,
                                                    Animation<double> animation,
                                                    __,
                                                    Widget child) {
                                                  return Opacity(
                                                    opacity: animation.value,
                                                    child: child,
                                                  );
                                                }));
                                      },
                                      child: Text(
                                        "See all",
                                        style: TextStyle(
                                            fontFamily: "Sofia",
                                            color: Colors.black54,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ]),
                            ),
                            Container(
                              height: 195.0,
                              child: StreamBuilder(
                                stream: Firestore.instance
                                    // .collection("recipe")
                                    // .where('type', isEqualTo: 'suggest')
                                    .collection('recipe')
  .orderBy('rating', descending: true)
                                    .snapshots(),
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
                                      ? new cardNear(
                                          dataUser: widget.userID,
                                          loadImage: loadImage,
                                          list: snapshot.data.documents,
                                        )
                                      : loadData = false;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0, top: 30.0),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Trending",
                                      style: TextStyle(
                                          fontFamily: "Sofia",
                                          fontSize: 18.5,
                                          color: Colors.black.withOpacity(0.9),
                                          fontWeight: FontWeight.w600),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            PageRouteBuilder(
                                                pageBuilder: (_, __, ___) =>
                                                    new SeeAll(
                                                      data: "trending",
                                                      idUser: widget.userID,
                                                    ),
                                                transitionDuration: Duration(
                                                    milliseconds: 1000),
                                                transitionsBuilder: (_,
                                                    Animation<double> animation,
                                                    __,
                                                    Widget child) {
                                                  return Opacity(
                                                    opacity: animation.value,
                                                    child: child,
                                                  );
                                                }));
                                      },
                                      child: Text(
                                        "See all",
                                        style: TextStyle(
                                            fontFamily: "Sofia",
                                            color: Colors.black54,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ]),
                            ),
                            Container(
                              height: 195.0,
                              child: StreamBuilder(
                                stream: Firestore.instance
                                    .collection("recipe")
                                    .where('type', isEqualTo: 'trending')
                                    .snapshots(),
                                builder: (BuildContext ctx,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  return snapshot.hasData
                                      ? new cardNear(
                                          dataUser: widget.userID,
                                          loadImage: loadImage,
                                          list: snapshot.data.documents,
                                        )
                                      : loadData = false;
                                },
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 30.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Popular",
                                  style: TextStyle(
                                      fontFamily: "Sofia",
                                      fontSize: 18.5,
                                      color: Colors.black.withOpacity(0.9),
                                      fontWeight: FontWeight.w600),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(PageRouteBuilder(
                                        pageBuilder: (_, __, ___) => new SeeAll(
                                              data: "popular",
                                              idUser: widget.userID,
                                            ),
                                        transitionDuration:
                                            Duration(milliseconds: 1000),
                                        transitionsBuilder: (_,
                                            Animation<double> animation,
                                            __,
                                            Widget child) {
                                          return Opacity(
                                            opacity: animation.value,
                                            child: child,
                                          );
                                        }));
                                  },
                                  child: Text(
                                    "See all",
                                    style: TextStyle(
                                        fontFamily: "Sofia",
                                        color: Colors.black54,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ]),
                        ),
                        StreamBuilder(
                          stream: Firestore.instance
                              .collection("recipe")
                              .where('type', isEqualTo: 'popular')
                              .snapshots(),
                          builder: (BuildContext ctx,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            return snapshot.hasData
                                ? new cardDinner(
                                    dataUser: widget.userID,
                                    list: snapshot.data.documents,
                                  )
                                : loadData = false;
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}

class animationLoadData extends StatelessWidget {
  @override
  final color = Colors.black38;
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 40.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Shimmer.fromColors(
            baseColor: color,
            highlightColor: Colors.white,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 40.0,
                    width: 170.0,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10.0),
                          topLeft: Radius.circular(10.0)),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    height: 45.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(EvaIcons.searchOutline, color: Colors.white),
                          Icon(EvaIcons.options2Outline,
                              color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    height: 200.0,
                    width: double.infinity,
                    color: Colors.black12,
                    alignment: Alignment.topRight,
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Container(
                    height: 40.0,
                    width: 120.0,
                    color: Colors.black12,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: Container(
                            height: 100.0,
                            width: MediaQuery.of(context).size.width / 3.8,
                            color: Colors.black12,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: Container(
                            height: 100.0,
                            width: MediaQuery.of(context).size.width / 3.8,
                            color: Colors.black12,
                          ),
                        ),
                        Container(
                          height: 100.0,
                          width: MediaQuery.of(context).size.width / 3.8,
                          color: Colors.black12,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Container(
                    height: 40.0,
                    width: 120.0,
                    color: Colors.black12,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: Container(
                            height: 100.0,
                            width: MediaQuery.of(context).size.width / 2.5,
                            color: Colors.black12,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: Container(
                            height: 100.0,
                            width: MediaQuery.of(context).size.width / 2.5,
                            color: Colors.black12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}

class cardBanner extends StatelessWidget {
  List<DocumentSnapshot> list;
  String dataUser;
  cardBanner({this.dataUser, this.list});
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        itemCount: 3,
        itemBuilder: (context, i) {
          String title = list[i].data['title'].toString();
          String category = list[i].data['category'].toString();
          String imageUrl = list[i].data['imageUrl'].toString();
          String id = list[i].data['id'].toString();
          String description = list[i].data['desc1'].toString();
          String price = list[i].data['price'].toString();
          String hours = list[i].data['time'].toString();
          String date = list[i].data['date'].toString();
          String location = list[i].data['place'].toString();
          String description2 = list[i].data['desc2'].toString();
          String description3 = list[i].data['desc3'].toString();
          return InkWell(
            onTap: () {},
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(imageUrl), fit: BoxFit.cover),
                  color: Color(0xFF23252E)),
            ),
          );
        });
  }
}

/// Component category class to set list
class category extends StatelessWidget {
  @override
  String txt, image;
  GestureTapCallback tap;
  double padding, sizeImage;

  category({this.txt, this.image, this.tap, this.padding, this.sizeImage});

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
                        height: sizeImage,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Text(
                        txt,
                        style: TextStyle(
                          fontSize: 14.5,
                          color: Colors.black,
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
                    color: Colors.black,
                    size: 15.0,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            height: 0.1,
            color: Colors.black87,
          )
        ],
      ),
    );
  }
}

class cardPopular extends StatelessWidget {
  String image, title, userId, category;
  cardPopular({this.title, this.image, this.userId, this.category});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 4.0, top: 3.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (_, __, ___) => new categoryDetail(
                  title: title, userId: userId, category: category),
              transitionDuration: Duration(milliseconds: 1000),
              transitionsBuilder:
                  (_, Animation<double> animation, __, Widget child) {
                return Opacity(
                  opacity: animation.value,
                  child: child,
                );
              }));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 98.0,
              width: 99.0,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12.withOpacity(0.04),
                      blurRadius: 3.0,
                      spreadRadius: 1.0)
                ],
                color: Colors.white,
                border: Border.all(color: Colors.grey[300], width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        image,
                        height: 45,
                        width: 45,
                        colorBlendMode: BlendMode.darken,
                      )),
                  SizedBox(
                    height: 7.0,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Sofia",
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class cardNear extends StatelessWidget {
  String dataUser;
  bool loadImage;
  final List<DocumentSnapshot> list;
  cardNear({this.dataUser, this.list, this.loadImage});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      primary: false,
      itemCount: list.length,
      itemBuilder: (context, i) {
        List<String> ingredients = List.from(list[i].data['ingredients']);
        List<String> directions = List.from(list[i].data['directions']);
        String title = list[i].data['title'].toString();
        num rating = list[i].data['rating'];
        String category = list[i].data['category'].toString();
        String image = list[i].data['image'].toString();
        String id = list[i].data['id'].toString();
        String time = list[i].data['time'].toString();
        String calorie = list[i].data['calorie'].toString();

        return InkWell(
          onTap: () {
            Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (_, __, ___) => new RecipeDetailScreen(
                      title: title,
                      id: id,
                      image: image,
                      category: category,
                      time: time,
                      userId: dataUser,
                      rating: rating,
                      calorie: calorie,
                      directions: directions,
                      ingredient: ingredients,
                    ),
                transitionDuration: Duration(milliseconds: 1000),
                transitionsBuilder:
                    (_, Animation<double> animation, __, Widget child) {
                  return Opacity(
                    opacity: animation.value,
                    child: child,
                  );
                }));
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Hero(
                  tag: 'hero-tag-${id + title}',
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    child: Container(
                      height: 110.0,
                      width: 180.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(loadImage
                                ? "https://firebasestorage.googleapis.com/v0/b/recipeadmin-9b5fb.appspot.com/o/undraw_relaunch_day_902d.png?alt=media&token=e6938e87-aebf-4ba5-bebb-0b379f428519"
                                : image),
                            fit: BoxFit.cover),
                        boxShadow: [
                          BoxShadow(blurRadius: 0.0, color: Colors.black87)
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        gradient: LinearGradient(
                            colors: [Colors.white, Colors.white],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                // Column(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: ingredients.map((item) => new Text(item)).toList()),
                Container(
                  width: 170.0,
                  child: Text(
                    title,
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Sofia",
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  height: 2.0,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2.2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.query_builder,
                            size: 18.0,
                            color: Colors.black26,
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          Text(
                            time,
                            style: TextStyle(
                                color: Colors.black45,
                                fontFamily: "Sofia",
                                fontSize: 14.0,
                                fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.whatshot,
                            size: 18.0,
                            color: Colors.black26,
                          ),
                          Text(
                            calorie,
                            style: TextStyle(
                                color: Colors.black45,
                                fontFamily: "Sofia",
                                fontSize: 14.0,
                                fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.star,
                      size: 20.0,
                      color: Colors.yellow,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 3.0),
                      child: Text(
                        rating.toString(),
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Sofia",
                            fontSize: 14.0),
                      ),
                    ),
                    SizedBox(
                      width: 35.0,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class cardDinner extends StatelessWidget {
  String dataUser;
  final List<DocumentSnapshot> list;
  cardDinner({this.dataUser, this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 0.0),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      primary: false,
      itemCount: list.length,
      itemBuilder: (context, i) {
        List<String> ingredients = List.from(list[i].data['ingredients']);
        List<String> directions = List.from(list[i].data['directions']);
        String title = list[i].data['title'].toString();
        num rating = list[i].data['rating'];
        String category = list[i].data['category'].toString();
        String image = list[i].data['image'].toString();
        String id = list[i].data['id'].toString();
        String time = list[i].data['time'].toString();
        String calorie = list[i].data['calorie'].toString();

        return InkWell(
          onTap: () {
            Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (_, __, ___) => new RecipeDetailScreen(
                      title: title,
                      id: id,
                      image: image,
                      category: category,
                      time: time,
                      userId: dataUser,
                      rating: rating,
                      calorie: calorie,
                      directions: directions,
                      ingredient: ingredients,
                    ),
                transitionDuration: Duration(milliseconds: 1000),
                transitionsBuilder:
                    (_, Animation<double> animation, __, Widget child) {
                  return Opacity(
                    opacity: animation.value,
                    child: child,
                  );
                }));
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Hero(
                  tag: 'hero-tag-${id + title}',
                  child: Material(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: Color(0xFF1E2026),
                    child: Container(
                      height: 110.0,
                      width: 110.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(image),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(blurRadius: 0.0, color: Colors.black87)
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        gradient: LinearGradient(
                            colors: [
                              Color(0xFF1E2026),
                              Color(0xFF23252E),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 19.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 200.0,
                        child: Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Sofia",
                              fontSize: 18.0,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        height: 2.0,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.7,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Icon(
                                  Icons.query_builder,
                                  size: 19.0,
                                  color: Colors.black26,
                                ),
                                SizedBox(
                                  width: 4.0,
                                ),
                                Text(
                                  time,
                                  style: TextStyle(
                                      color: Colors.black45,
                                      fontFamily: "Sofia",
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                            Container(
                              //   width: MediaQuery.of(context).size.width / 3.6,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    Icons.whatshot,
                                    size: 19.0,
                                    color: Colors.black26,
                                  ),
                                  Container(
                                    width: 90.0,
                                    child: Text(
                                      calorie,
                                      style: TextStyle(
                                          color: Colors.black45,
                                          fontFamily: "Sofia",
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.9,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.star,
                                  size: 21.0,
                                  color: Colors.yellow,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 3.0),
                                  child: Text(
                                    rating.toString(),
                                    style: TextStyle(
                                        color: Colors.black45,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: "Sofia",
                                        fontSize: 16.0),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 27.0,
                              decoration: BoxDecoration(
                                color: colorStyle.primaryColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, right: 15.0),
                                child: Center(
                                  child: Text(
                                    category,
                                    style: TextStyle(
                                        fontFamily: "Sofia",
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
