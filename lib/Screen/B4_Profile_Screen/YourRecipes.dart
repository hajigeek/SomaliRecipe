import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:Somali_Yurecipe/Screen/B1_Home_Screen/Detail/detail_recipe.dart';
import 'package:Somali_Yurecipe/Screen/B3_Favorite_Screen/RecipeDetailFavorite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class YourRecipes extends StatefulWidget {
  String uid;
  YourRecipes({this.uid});

  _YourRecipesState createState() => _YourRecipesState();
}

class _YourRecipesState extends State<YourRecipes> {
  bool checkMail = true;
  String mail;

  SharedPreferences prefs;

  Future<Null> _function() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    this.setState(() {
      mail = prefs.getString("username") ?? '';
    });
  }

  ///
  /// Get image data dummy from firebase server
  ///
  var imageNetwork = NetworkImage(
      "https://firebasestorage.googleapis.com/v0/b/beauty-look.appspot.com/o/Artboard%203.png?alt=media&token=dc7f4bf5-8f80-4f38-bb63-87aed9d59b95");

  ///
  /// check the condition is right or wrong for image loaded or no
  ///
  bool loadImage = true;

  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      setState(() {
        loadImage = false;
      });
    });
    _function();
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Text(
            "Your Recipes",
            style: TextStyle(
              fontFamily: "Sofia",
              letterSpacing: 1.5,
              fontWeight: FontWeight.w700,
              fontSize: 24.0,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 5.0,
            ),
            Padding(
                padding: EdgeInsets.only(top: 0.0, bottom: 0.0),
                child: StreamBuilder(
                  stream: Firestore.instance
                      .collection("users")
                      .document(widget.uid)
                      .collection('recipe')
                      .snapshots(),
                  builder: (
                    BuildContext ctx,
                    AsyncSnapshot<QuerySnapshot> snapshot,
                  ) {
                    if (!snapshot.hasData) {
                      return noItem();
                    } else {
                      if (snapshot.data.documents.isEmpty) {
                        return noItem();
                      } else {
                        if (loadImage) {
                          return _loadingDataList(
                              ctx, snapshot.data.documents.length);
                        } else {
                          return new dataFirestore(
                              list: snapshot.data.documents);
                        }

                        //  return  new noItem();
                      }
                    }
                  },
                )),
          ],
        ),
      ),
    );
  }
}

Widget cardHeaderLoading(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      height: 500.0,
      width: 275.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: Color(0xFF2C3B4F),
      ),
      child: Shimmer.fromColors(
        baseColor: Color(0xFF3B4659),
        highlightColor: Color(0xFF606B78),
        child: Padding(
          padding: const EdgeInsets.only(top: 320.0),
          child: Column(
            children: <Widget>[
              Container(
                height: 17.0,
                width: 70.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
              ),
              SizedBox(
                height: 25.0,
              ),
              Container(
                height: 20.0,
                width: 150.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                height: 20.0,
                width: 250.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                height: 20.0,
                width: 150.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

///
///
/// Calling imageLoading animation for set a list layout
///
///
Widget _loadingDataList(BuildContext context, int panjang) {
  return Container(
    child: ListView.builder(
      shrinkWrap: true,
      primary: false,
      padding: EdgeInsets.only(top: 0.0),
      itemCount: panjang,
      itemBuilder: (ctx, i) {
        return loadingCard(ctx);
      },
    ),
  );
}

Widget loadingCard(BuildContext ctx) {
  return Padding(
    padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
    child: Container(
      height: 250.0,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          boxShadow: [
            BoxShadow(
                color: Colors.black12.withOpacity(0.1),
                blurRadius: 3.0,
                spreadRadius: 1.0)
          ]),
      child: Shimmer.fromColors(
        baseColor: Colors.black38,
        highlightColor: Colors.white,
        child: Column(children: [
          Container(
            height: 165.0,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10.0),
                  topLeft: Radius.circular(10.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, right: 10.0),
              child: CircleAvatar(
                  radius: 20.0,
                  backgroundColor: Colors.black12,
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  )),
            ),
            alignment: Alignment.topRight,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 220.0,
                        height: 25.0,
                        color: Colors.black12,
                      ),
                      Padding(padding: EdgeInsets.only(top: 5.0)),
                      Container(
                        height: 15.0,
                        width: 100.0,
                        color: Colors.black12,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.9),
                        child: Container(
                          height: 12.0,
                          width: 140.0,
                          color: Colors.black12,
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 13.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 35.0,
                        width: 55.0,
                        color: Colors.black12,
                      ),
                      Padding(padding: EdgeInsets.only(top: 8.0)),
                      Container(
                        height: 10.0,
                        width: 55.0,
                        color: Colors.black12,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    ),
  );
}

class dataFirestore extends StatelessWidget {
  dataFirestore({this.list});
  final List<DocumentSnapshot> list;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var imageOverlayGradient = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: FractionalOffset.bottomCenter,
          end: FractionalOffset.topCenter,
          colors: [
            const Color(0xFF000000),
            const Color(0x00000000),
            Colors.black,
            Colors.black,
            Colors.black,
            Colors.black,
          ],
        ),
      ),
    );

    return SizedBox.fromSize(
//      size: const Size.fromHeight(410.0),
        child: ListView.builder(
      shrinkWrap: true,
      primary: false,
      padding: EdgeInsets.only(top: 0.0),
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

        return Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 0.0),
          child: InkWell(
              onTap: () {
                Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (_, __, ___) => new RecipeFavoriteDetail(
                          title: title,
                          id: id,
                          image: image,
                          category: category,
                          time: time,
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
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12.withOpacity(0.1),
                            spreadRadius: 3.0,
                            blurRadius: 10.0)
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Hero(
                        tag: 'hero-tag-list-$id',
                        child: Material(
                          child: Container(
                            height: 165.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(image),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15.0),
                                  topRight: Radius.circular(15.0)),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 10.0, right: 10.0),
                              child: InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) => NetworkGiffyDialog(
                                            image: Image.network(
                                              "https://firebasestorage.googleapis.com/v0/b/cryptocanyon9.appspot.com/o/original.gif?alt=media&token=ee61ee91-1d4b-40c9-91a0-be9c8aef1767",
                                              fit: BoxFit.cover,
                                            ),
                                            title: Text('Delete Recipes?',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontFamily: "Gotik",
                                                    fontSize: 22.0,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            description: Text(
                                              "Are you sure you want to delete " +
                                                  title,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: "Sofia",
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.black26),
                                            ),
                                            onOkButtonPressed: () {
                                              Navigator.pop(context);

                                              Firestore.instance.runTransaction(
                                                  (transaction) async {
                                                DocumentSnapshot snapshot =
                                                    await transaction
                                                        .get(list[i].reference);
                                                await transaction
                                                    .delete(snapshot.reference);
                                                SharedPreferences prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                prefs.remove(title);
                                              });
                                              Scaffold.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text("Delete" + title),
                                                backgroundColor: Colors.red,
                                                duration: Duration(seconds: 3),
                                              ));
                                            },
                                          ));
                                },
                                child: CircleAvatar(
                                    radius: 20.0,
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.black38,
                                    )),
                              ),
                            ),
                            alignment: Alignment.topRight,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, right: 10.0, bottom: 13.0, top: 7.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 5.0),
                            Text(
                              title,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 19.0,
                                  fontFamily: "Sofia"),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 9.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(children: <Widget>[
                                    Icon(
                                      Icons.query_builder,
                                      size: 17.0,
                                    ),
                                    Container(
                                        width: 120.0,
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              time,
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontFamily: "Sofia",
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black38),
                                              overflow: TextOverflow.ellipsis,
                                            )))
                                  ]),
                                  Row(children: <Widget>[
                                    Icon(
                                      Icons.whatshot,
                                      size: 17.0,
                                    ),
                                    Container(
                                        width: 140.0,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            calorie,
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontFamily: "Sofia",
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black38),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ))
                                  ]),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(children: <Widget>[
                              Icon(
                                Icons.star,
                                size: 17.0,
                                color: Colors.yellow,
                              ),
                              Container(
                                  width: 140.0,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      rating.toString(),
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontFamily: "Sofia",
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black38),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                            ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        );
      },
    ));
  }
}

///
///
/// If no item cart this class showing
///
class noItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      width: 500.0,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding:
                    EdgeInsets.only(top: mediaQueryData.padding.top + 80.0)),
            Image.asset(
              "assets/ilustration/5.png",
              height: 300.0,
            ),
            Padding(padding: EdgeInsets.only(bottom: 1.0)),
            Text(
              "Not Have Item Recipe",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 17.5,
                  color: Colors.black26.withOpacity(0.2),
                  fontFamily: "Sofia"),
            ),
          ],
        ),
      ),
    );
  }
}
