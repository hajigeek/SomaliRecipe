import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:Somali_Yurecipe/Screen/B1_Home_Screen/Detail/detail_recipe.dart';
import 'package:Somali_Yurecipe/Screen/Search/search.dart';
import 'package:Somali_Yurecipe/Style/Style.dart';

class categoryDetail extends StatefulWidget {
  String userId, title, category;
  categoryDetail({this.userId, this.title, this.category});

  @override
  _categoryDetailState createState() => _categoryDetailState();
}

class _categoryDetailState extends State<categoryDetail> {
  @override
  bool loadData = true;
  @override
  void initState() {
    Timer(Duration(milliseconds: 3500), () {
      setState(() {
        loadData = false;
      });
    });

    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(
              fontFamily: "Sofia", fontSize: 19.0, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (_, __, ___) => new Search(
                            userId: widget.userId,
                          )));
                },
                child: Container(
                  height: 40.0,
                  alignment: AlignmentDirectional.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Color(0xFFF7F7FA),
                  ),
                  padding: EdgeInsets.only(
                      left: 20.0, right: 30.0, top: 0.0, bottom: 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.search,
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
                    ],
                  ),
                ),
              ),
            ),
            StreamBuilder(
              stream: Firestore.instance
                  .collection("recipe")
                  .where('category', isEqualTo: widget.category)
                  .snapshots(),
              builder:
                  (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                return snapshot.hasData
                    ? new cardDinner(
                        dataUser: widget.userId,
                        list: snapshot.data.documents,
                      )
                    : loadData = false;
              },
            ),
            SizedBox(
              height: 15.0,
            )
          ],
        ),
      ),
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
