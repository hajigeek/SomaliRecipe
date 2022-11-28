import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:Somali_Yurecipe/Style/Style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecipeFavoriteDetail extends StatefulWidget {
  num rating;
  List<String> ingredient, directions;
  String image, title, category, time, id, calorie, userId;
  RecipeFavoriteDetail(
      {this.image,
      this.title,
      this.ingredient,
      this.directions,
      this.category,
      this.time,
      this.calorie,
      this.id,
      this.userId,
      this.rating});

  @override
  _RecipeFavoriteDetailState createState() => _RecipeFavoriteDetailState();
}

class _RecipeFavoriteDetailState extends State<RecipeFavoriteDetail> {
  @override
  Widget build(BuildContext context) {
    String _name, _email;
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    void _getData() {
      StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .document(widget.userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new Text("Loading");
          } else {
            var userDocument = snapshot.data;
            _name = userDocument["name"];
            _email = userDocument["email"];

            setState(() {
              var userDocument = snapshot.data;
              _name = userDocument["name"];
              _email = userDocument["email"];
            });
          }

          var userDocument = snapshot.data;
          return Stack(
            children: <Widget>[Text(userDocument["name"])],
          );
        },
      );
    }

    _checkFirst() async {
      SharedPreferences prefs;
      prefs = await SharedPreferences.getInstance();
      if (prefs.getString(widget.title) == null) {
        setState(() {
          //   _favorite = "Favorite";
        });
      } else {
        setState(() {
          //   _join = "Joined";
        });
      }
    }

    @override
    void initState() {
      _checkFirst();
      _getData();
      // TODO: implement initState
      super.initState();
    }

    var _ingredients = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
              top: 60.0, left: 20.0, right: 20.0, bottom: 10.0),
          child: Text(
            "Ingredients :",
            style: TextStyle(
                fontFamily: "Sofia",
                fontSize: 20.0,
                color: Colors.black,
                fontWeight: FontWeight.w700),
            textAlign: TextAlign.justify,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: 0.0, left: 20.0, right: 20.0, bottom: 0.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.ingredient
                  .map((item) => Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, left: 10.0, bottom: 10.0),
                        child: new Text(
                          "- " + item,
                          style: TextStyle(
                              fontFamily: "Sofia",
                              color: Colors.black54,
                              fontSize: 18.0),
                        ),
                      ))
                  .toList()),
        ),
      ],
    );

    var _directions = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
              top: 60.0, left: 20.0, right: 20.0, bottom: 10.0),
          child: Text(
            "Directions :",
            style: TextStyle(
                fontFamily: "Sofia",
                fontSize: 20.0,
                color: Colors.black,
                fontWeight: FontWeight.w700),
            textAlign: TextAlign.justify,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: 0.0, left: 20.0, right: 20.0, bottom: 0.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.directions
                  .map((item) => Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, left: 10.0, bottom: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "-   ",
                              style: TextStyle(color: Colors.black),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 1.3,
                              child: new Text(
                                item,
                                style: TextStyle(
                                    fontFamily: "Sofia",
                                    color: Colors.black54,
                                    fontSize: 18.0),
                                overflow: TextOverflow.clip,
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList()),
        ),
      ],
    );

    // void addData() {
    //   Firestore.instance.runTransaction((Transaction transaction) async {
    //     Firestore.instance
    //         .collection("Favorite")
    //         .document("user")
    //         .collection(widget.title)
    //         .document(widget.userId)
    //         .setData({
    //       "nama": _name,
    //       "userId": widget.userId,
    //     });
    //   });
    // }

    void userSaved() {
      Firestore.instance.runTransaction((Transaction transaction) async {
        SharedPreferences prefs;
        prefs = await SharedPreferences.getInstance();
        Firestore.instance
            .collection("users")
            .document(widget.userId)
            .collection('Bookmark')
            .add({
          "user": widget.userId,
          "title": widget.title,
          "category": widget.category,
          "image": widget.image,
          "ingredients": widget.ingredient,
          "time": widget.time,
          "rating": widget.rating,
          "id": widget.id,
          "directions": widget.directions,
          "calorie": widget.calorie
        });
      });
      Navigator.pop(context);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: <Widget>[
            /// AppBar
            SliverPersistentHeader(
              delegate: MySliverAppBar(
                  expandedHeight: _height - 30.0,
                  img: widget.image,
                  id: widget.id,
                  title: widget.title,
                  time: widget.time,
                  category: widget.category,
                  rating: widget.rating),
              pinned: true,
            ),

            SliverToBoxAdapter(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 80.0),
                    child: Container(
                        height: 90.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12.withOpacity(0.13),
                                blurRadius: 7.0,
                                spreadRadius: 1.0),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 40.0, right: 40.0, top: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                _infoCircleIcon(
                                    EvaIcons.shoppingBag,
                                    widget.ingredient.length.toString() +
                                        " Stuff"),
                                _infoCircleIcon(
                                    Icons.query_builder, widget.time),
                                _infoCircleIcon(
                                  Icons.whatshot,
                                  widget.calorie,
                                )
                              ],
                            ),
                          ),
                        )),
                  ),

                  /// Description
                  _ingredients,

                  /// Description
                  _directions,

                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 25.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 30.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Recomended",
                                style: TextStyle(
                                    fontFamily: "Sofia",
                                    fontSize: 20.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                "See all",
                                style: TextStyle(
                                    fontFamily: "Sofia",
                                    color: Colors.black54,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400),
                              ),
                            ]),
                      ),
                      Container(
                        height: 195.0,
                        child: StreamBuilder(
                          stream: Firestore.instance
                              .collection("recipe")
                              .snapshots(),
                          builder: (BuildContext ctx,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            return new cardPopular(
                              dataUser: "dasdsa",
                              list: snapshot.data.documents,
                            );
                            // if (loadImage) {
                            //   return cardNear(
                            //       dataUser: "dasdsa",
                            //       list: snapshot.data.documents,
                            //     );
                            // } else {
                            //   if (!snapshot.hasData) {
                            //     return cardNear(
                            //       dataUser: "dasdsa",
                            //       list: snapshot.data.documents,
                            //     );
                            //   } else {
                            //     return new cardNear(
                            //       dataUser: "dasdsa",
                            //       list: snapshot.data.documents,
                            //     );
                            //   }
                            // }
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                ])),
          ],
        ),
      ),
    );
  }
}

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  num rating;
  String img, id, title, category, time;
  MySliverAppBar(
      {@required this.expandedHeight,
      this.img,
      this.id,
      this.title,
      this.time,
      this.category,
      this.rating});

  var _txtStyleTitle = TextStyle(
    color: Colors.black54,
    fontFamily: "Sofia",
    fontSize: 20.0,
    fontWeight: FontWeight.w800,
  );

  var _txtStyleSub = TextStyle(
    color: Colors.black26,
    fontFamily: "Sofia",
    fontSize: 12.5,
    fontWeight: FontWeight.w600,
  );

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          height: 50.0,
          width: double.infinity,
          color: Colors.white,
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            "Recipe",
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Sofia",
              fontWeight: FontWeight.w700,
              fontSize: (expandedHeight / 40) - (shrinkOffset / 40) + 18,
            ),
          ),
        ),
        Opacity(
          opacity: (1 - shrinkOffset / expandedHeight),
          child: Hero(
            tag: 'hero-tag-${id + title}',
            child: Material(
              color: Colors.transparent,
              child: new DecoratedBox(
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    fit: BoxFit.cover,
                    image: new NetworkImage(img),
                  ),
                  shape: BoxShape.rectangle,
                ),
                child: Container(
                  margin: EdgeInsets.only(top: 620.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: FractionalOffset(0.0, 0.0),
                      end: FractionalOffset(0.0, 1.0),
                      stops: [0.0, 1.0],
                      colors: <Color>[
                        Color(0x00FFFFFF),
                        Color(0xFFFFFFFF),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Opacity(
            opacity: (1 - shrinkOffset / expandedHeight),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 20.0, right: 20.0, left: 20.0, bottom: 40.0),
              child: Container(
                height: 170.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: Colors.white.withOpacity(0.85)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 2.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                    width: 200.0,
                                    child: Text(
                                      title,
                                      style: _txtStyleTitle.copyWith(
                                          fontSize: 27.0),
                                      overflow: TextOverflow.clip,
                                      maxLines: 2,
                                      softWrap: true,
                                    )),
                                Padding(
                                  padding: const EdgeInsets.only(right: 3.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        category,
                                        style: TextStyle(
                                            fontSize: 25.0,
                                            color: colorStyle.primaryColor,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Sofia"),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(boxShadow: [
                                        BoxShadow(
                                            color: Colors.black12
                                                .withOpacity(0.03))
                                      ]),
                                      child: RatingBar.builder(
                                        initialRating: rating + .0,
                                        minRating: 1,
                                        itemSize: 21.0,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemPadding: EdgeInsets.symmetric(
                                            horizontal: 0.0),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          size: 12.0,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {
                                          print(rating);
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            child: Text(
                                              time + " cooking time",
                                              style: TextStyle(
                                                  color: Colors.black26,
                                                  fontSize: 15.5,
                                                  fontFamily: "Sofia",
                                                  fontWeight: FontWeight.w400),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                      child: Container(
                          height: 35.0,
                          width: 35.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(40.0),
                            ),
                            color: Colors.white70,
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          )),
                    ))),
            SizedBox(
              width: 36.0,
            )
          ],
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

Widget _photo(String image, id, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Material(
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (BuildContext context, _, __) {
                    return new Material(
                      color: Colors.black54,
                      child: Container(
                        padding: EdgeInsets.all(30.0),
                        child: InkWell(
                          child: Hero(
                              tag: "hero-grid-${id}",
                              child: Image.asset(
                                image,
                                width: 300.0,
                                height: 300.0,
                                alignment: Alignment.center,
                                fit: BoxFit.contain,
                              )),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    );
                  },
                  transitionDuration: Duration(milliseconds: 500)));
            },
            child: Container(
              height: 130.0,
              width: 130.0,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(image), fit: BoxFit.cover),
                  color: Colors.black12,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 5.0,
                        color: Colors.black12.withOpacity(0.1),
                        spreadRadius: 2.0)
                  ]),
            ),
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
      ],
    ),
  );
}

Widget _line() {
  return Container(
    height: 0.9,
    width: double.infinity,
    color: Colors.white10,
  );
}

Widget _infoCircleIcon(IconData icons, String title) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Center(
        child: Icon(
          icons,
          size: 28.0,
          color: Colors.black54,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                  fontFamily: "Sofia",
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _relatedPost(String image, title, location, ratting) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 110.0,
          width: 180.0,
          decoration: BoxDecoration(
              image:
                  DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
              color: Colors.black12,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              boxShadow: [
                BoxShadow(
                    blurRadius: 5.0,
                    color: Colors.black12.withOpacity(0.1),
                    spreadRadius: 2.0)
              ]),
        ),
        SizedBox(
          height: 5.0,
        ),
        Text(
          title,
          style: TextStyle(
              fontFamily: "Sofia",
              fontWeight: FontWeight.w600,
              fontSize: 17.0,
              color: Colors.black87),
        ),
        SizedBox(
          height: 2.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.location_on,
              size: 18.0,
              color: Colors.black12,
            ),
            Text(
              location,
              style: TextStyle(
                  fontFamily: "Sofia",
                  fontWeight: FontWeight.w500,
                  fontSize: 15.0,
                  color: Colors.black26),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.star,
              size: 18.0,
              color: Colors.yellow,
            ),

            Padding(
              padding: const EdgeInsets.only(top: 3.0),
              child: Text(
                ratting,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontFamily: "Sofia",
                    fontSize: 13.0),
              ),
            ),

            // Text("(233 Rating)",style: TextStyle(fontWeight: FontWeight.w500,fontFamily: "Sofia",fontSize: 11.0,color: Colors.black38),),
            SizedBox(
              width: 35.0,
            ),
          ],
        ),
      ],
    ),
  );
}

class reviewList extends StatelessWidget {
  String image, name, time;
  reviewList({this.image, this.name, this.time});

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        //    Navigator.of(context).push(PageRouteBuilder(pageBuilder: (_,__,___)=>new chatting(name: this.name,)));
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, bottom: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(image), fit: BoxFit.cover),
                      color: Colors.black12,
                      borderRadius: BorderRadius.all(Radius.circular(50.0))),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 10.0,
                              spreadRadius: 2.0,
                              color: Colors.black12.withOpacity(0.05))
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(name,
                              style: TextStyle(
                                fontFamily: "Sofia",
                                fontWeight: FontWeight.w700,
                                fontSize: 17.0,
                                color: Colors.black,
                              )),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                              width: _width - 140.0,
                              child: Text(
                                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                                style: TextStyle(
                                    fontFamily: "Sofia",
                                    fontWeight: FontWeight.w300,
                                    fontSize: 13.5,
                                    color: Colors.black45),
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.justify,
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class cardPopular extends StatelessWidget {
  String dataUser;
  final List<DocumentSnapshot> list;
  cardPopular({this.dataUser, this.list});

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
            padding: const EdgeInsets.only(top: 10.0, left: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Hero(
                  tag: 'hero-tag-${id}',
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    child: Container(
                      height: 110.0,
                      width: 180.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(image), fit: BoxFit.cover),
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
