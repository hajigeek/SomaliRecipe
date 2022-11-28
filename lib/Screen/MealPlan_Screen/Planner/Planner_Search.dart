import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Somali_Yurecipe/Screen/B3_Favorite_Screen/B3_Favorite_Screen.dart';
import 'package:Somali_Yurecipe/Widget/loader_animation/dot.dart';
import 'package:Somali_Yurecipe/Widget/loader_animation/loader.dart';
import 'package:uuid/uuid.dart';

class PlannerSearch extends StatefulWidget {
  String userId;
  String day;
  PlannerSearch({this.userId, this.day});

  @override
  _PlannerSearchState createState() => _PlannerSearchState();
}

class _PlannerSearchState extends State<PlannerSearch> {
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
                    ? Firestore.instance.collection("recipe").snapshots()
                    : Firestore.instance
                        .collection("recipe")
                        .where("searchIndex", arrayContains: searchString)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');
                  if (searchString == null)
                    return StreamBuilder(
                      stream: Firestore.instance
                          .collection("users")
                          .document(widget.userId)
                          .collection('Bookmark')
                          .snapshots(),
                      builder: (BuildContext ctx,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        return snapshot.hasData
                            ? new cardBookmark(
                                dataUser: widget.userId,
                                list: snapshot.data.documents,
                                day: widget.day,
                                v4: v4,
                              )
                            : Container();
                      },
                    );
                  if (searchString.trim() == "")
                    return StreamBuilder(
                      stream: Firestore.instance
                          .collection("users")
                          .document(widget.userId)
                          .collection('Bookmark')
                          .snapshots(),
                      builder: (BuildContext ctx,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        return snapshot.hasData
                            ? new cardBookmark(
                                dataUser: widget.userId,
                                list: snapshot.data.documents,
                                day: widget.day,
                                v4: v4,
                              )
                            : Container();
                      },
                    );
                  if (snapshot.data.documents.isEmpty) return noItem();
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
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 15.0, bottom: 5.0),
                          child: InkWell(
                            onTap: () {
                              Firestore.instance.runTransaction(
                                  (Transaction transaction) async {
                                Firestore.instance
                                    .collection("users")
                                    .document(widget.userId)
                                    .collection('Planner' + widget.day)
                                    .document(v4 + widget.userId)
                                    .setData({
                                  "title": document['title'],
                                  "id": document['id'],
                                  "image": document['image'],
                                  "category": document['category'],
                                  "time": document['time'],
                                  "userId": widget.userId,
                                  "rating": document['rating'],
                                  "calorie": document['calorie'],
                                  "directions":
                                      List.from(document['directions']),
                                  "ingredients":
                                      List.from(document['ingredients']),
                                });
                              });
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12.withOpacity(0.1),
                                      blurRadius: 1.0,
                                      spreadRadius: 1.0)
                                ],
                              ),
                              child: Row(
                                children: <Widget>[
                                  Hero(
                                    tag: 'hero-tag-${document['id']}',
                                    child: Material(
                                      child: Container(
                                        height: 180.0,
                                        width: 120.0,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  document['image']),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20.0, left: 20.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width: 145.0,
                                          child: Text(
                                            document['title'],
                                            style: TextStyle(
                                              fontFamily: "Sofia",
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Icon(
                                              Icons.query_builder,
                                              size: 16.0,
                                              color: Colors.black38,
                                            ),
                                            SizedBox(
                                              width: 5.0,
                                            ),
                                            Container(
                                              width: 135.0,
                                              child: Text(
                                                document['time'],
                                                style: TextStyle(
                                                  fontFamily: "Sofia",
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Icon(
                                              Icons.whatshot,
                                              size: 16.0,
                                              color: Colors.black38,
                                            ),
                                            SizedBox(
                                              width: 5.0,
                                            ),
                                            Container(
                                              width: 135.0,
                                              child: Text(
                                                document['calorie'],
                                                style: TextStyle(
                                                  fontFamily: "Sofia",
                                                  fontSize: 13.0,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Icon(
                                              Icons.star,
                                              size: 16.0,
                                              color: Colors.black38,
                                            ),
                                            SizedBox(
                                              width: 5.0,
                                            ),
                                            Text(
                                              document['rating'].toString(),
                                              style: TextStyle(
                                                fontFamily: "Sofia",
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        )
                                      ],
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

class cardBookmark extends StatelessWidget {
  String dataUser, day, v4;
  final List<DocumentSnapshot> list;
  cardBookmark({this.dataUser, this.list, this.day, this.v4});

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
            Firestore.instance.runTransaction((Transaction transaction) async {
              Firestore.instance
                  .collection("users")
                  .document(dataUser)
                  .collection('Planner' + day)
                  .document(v4 + dataUser)
                  .setData({
                "ingredients": ingredients,
                "directions": directions,
                "title": title,
                "rating": rating,
                "category": category,
                "image": image,
                "id": id,
                "time": time,
                "calorie": calorie,
              });
            });
            Navigator.pop(context);
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
                        width: MediaQuery.of(context).size.width / 2.1,
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Icon(
                                  Icons.whatshot,
                                  size: 19.0,
                                  color: Colors.black26,
                                ),
                                Text(
                                  calorie,
                                  style: TextStyle(
                                      color: Colors.black45,
                                      fontFamily: "Sofia",
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
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
                                color: Colors.orangeAccent,
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
