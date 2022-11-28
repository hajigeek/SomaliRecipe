import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Somali_Yurecipe/Screen/B1_Home_Screen/Detail/detail_recipe.dart';
import 'package:Somali_Yurecipe/Widget/Page_Transformer_Card/page_transformer.dart';
import 'package:shimmer/shimmer.dart';

class DinnerDiscover extends StatefulWidget {
  String idUser;
  DinnerDiscover({this.idUser});

  _DinnerDiscoverState createState() => _DinnerDiscoverState();
}

class _DinnerDiscoverState extends State<DinnerDiscover> {
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
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 0.0),
                    child: StreamBuilder(
                      stream: Firestore.instance
                          .collection("recipe")
                          .where('category', isEqualTo: 'Dinner')
                          .snapshots(),
                      builder: (BuildContext ctx,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (loadImage) {
                          return _loadingDataHeader(ctx);
                        } else {
                          if (!snapshot.hasData) {
                            return _loadingDataHeader(ctx);
                          } else {
                            return new dataFirestore(
                              list: snapshot.data.documents,
                              dataUser: widget.idUser,
                            );
                          }
                        }
                      },
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

///
///
/// Calling imageLoading animation for set a grid layout
///
///
Widget _loadingDataHeader(BuildContext context) {
  double _height = MediaQuery.of(context).size.height;
  return SizedBox.fromSize(
    size: Size.fromHeight(_height / 1.45),
    child: PageTransformer(
      pageViewBuilder: (context, visibilityResolver) {
        return PageView.builder(
          controller: PageController(viewportFraction: 0.87),
          itemCount: 5,
          itemBuilder: (context, index) {
            return cardHeaderLoading(context);
          },
        );
      },
    ),
  );
}

Widget cardHeaderLoading(BuildContext context) {
  double _height = MediaQuery.of(context).size.height;
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      height: _height / 1.45,
      width: 275.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Colors.grey[500],
          boxShadow: [
            BoxShadow(
                color: Colors.black12.withOpacity(0.1),
                spreadRadius: 0.2,
                blurRadius: 0.5)
          ]),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[400],
        highlightColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(top: 320.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                height: 25.0,
              ),
              Container(
                height: 20.0,
                width: 190.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                height: 20.0,
                width: 270.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                height: 20.0,
                width: 190.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
              ),
              SizedBox(
                height: 30.0,
              )
            ],
          ),
        ),
      ),
    ),
  );
}

class dataFirestore extends StatelessWidget {
  String dataUser;
  dataFirestore({this.list, this.dataUser});
  final List<DocumentSnapshot> list;
  PageVisibility pageVisibility;

  Widget _applyTextEffects({
    @required double translationFactor,
    @required Widget child,
  }) {
    final double xTranslation = pageVisibility.pagePosition * translationFactor;

    return Opacity(
      opacity: pageVisibility.visibleFraction,
      child: Transform(
        alignment: FractionalOffset.topLeft,
        transform: Matrix4.translationValues(
          xTranslation,
          0.0,
          0.0,
        ),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
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
      size: Size.fromHeight(_height / 1.45),
      child: PageTransformer(
        pageViewBuilder: (context, visibilityResolver) {
          return PageView.builder(
            controller: PageController(viewportFraction: 0.86),
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
                padding: const EdgeInsets.only(right: 10.0),
                child: Hero(
                  tag: 'hero-tag-${id + title}',
                  child: Material(
                    child: Container(
                      height: 500.0,
                      width: 275.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          color: Colors.grey[500],
                          image: DecorationImage(
                              image: NetworkImage(image), fit: BoxFit.cover),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12.withOpacity(0.1),
                                spreadRadius: 0.2,
                                blurRadius: 0.5)
                          ]),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          gradient: LinearGradient(
                            begin: FractionalOffset.bottomCenter,
                            end: FractionalOffset.topCenter,
                            colors: [
                              const Color(0xFF000000),
                              const Color(0x00000000),
                            ],
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                  pageBuilder: (_, __, ___) =>
                                      new RecipeDetailScreen(
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
                                  transitionDuration:
                                      Duration(milliseconds: 600),
                                  transitionsBuilder: (_,
                                      Animation<double> animation,
                                      __,
                                      Widget child) {
                                    return Opacity(
                                      opacity: animation.value,
                                      child: child,
                                    );
                                  }),
                            );
                          },
                          child: Stack(
                            children: <Widget>[
                              imageOverlayGradient,
                              Positioned(
                                bottom: 0.0,
                                left: 0.0,
                                right: 0.0,
                                child: Container(
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 20.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.2,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.query_builder,
                                                    size: 18.0,
                                                    color: Colors.white,
                                                  ),
                                                  SizedBox(
                                                    width: 4.0,
                                                  ),
                                                  Text(
                                                    time,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: "Sofia",
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.whatshot,
                                                    size: 18.0,
                                                    color: Colors.white,
                                                  ),
                                                  Text(
                                                    calorie,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: "Sofia",
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 16.0),
                                          child: Text(
                                            title,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
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
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
