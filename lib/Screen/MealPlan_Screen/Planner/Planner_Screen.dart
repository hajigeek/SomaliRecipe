import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:Somali_Yurecipe/Screen/B3_Favorite_Screen/RecipeDetailFavorite.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Planner_Search.dart';

class Planner extends StatefulWidget {
  String userId;
  Planner({this.userId});

  @override
  _PlannerState createState() => _PlannerState();
}

class _PlannerState extends State<Planner> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Sunday",
                  style: TextStyle(
                      fontFamily: "Sofia",
                      fontSize: 18.0,
                      color: Colors.black54,
                      fontWeight: FontWeight.w700),
                ),
                InkWell(
                    onTap: () {
                      Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (_, __, ___) => new PlannerSearch(
                                day: "Sunday",
                                userId: widget.userId,
                              ),
                          transitionDuration: Duration(milliseconds: 1000),
                          transitionsBuilder: (_, Animation<double> animation,
                              __, Widget child) {
                            return Opacity(
                              opacity: animation.value,
                              child: child,
                            );
                          }));
                    },
                    child: Icon(Icons.add)),
              ],
            ),
          ),
          Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 0.0, bottom: 5.0),
                  child: StreamBuilder(
                    stream: Firestore.instance
                        .collection("users")
                        .document(widget.userId)
                        .collection('PlannerSunday')
                        .snapshots(),
                    builder: (
                      BuildContext ctx,
                      AsyncSnapshot<QuerySnapshot> snapshot,
                    ) {
                      if (!snapshot.hasData) {
                        return Container();
                      } else {
                        if (snapshot.data.documents.isEmpty) {
                          return Container();
                        } else {
                          return dataFirestore(
                              userId: widget.userId,
                              list: snapshot.data.documents);

                          //  return  new noItem();
                        }
                      }
                    },
                  )),
              SizedBox(
                height: 10.0,
              )
            ],
          ),
          _line(),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Monday",
                  style: TextStyle(
                      fontFamily: "Sofia",
                      fontSize: 18.0,
                      color: Colors.black54,
                      fontWeight: FontWeight.w700),
                ),
                InkWell(
                    onTap: () {
                      Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (_, __, ___) => new PlannerSearch(
                                day: "Monday",
                                userId: widget.userId,
                              ),
                          transitionDuration: Duration(milliseconds: 1000),
                          transitionsBuilder: (_, Animation<double> animation,
                              __, Widget child) {
                            return Opacity(
                              opacity: animation.value,
                              child: child,
                            );
                          }));
                    },
                    child: Icon(Icons.add)),
              ],
            ),
          ),
          Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 0.0, bottom: 5.0),
                  child: StreamBuilder(
                    stream: Firestore.instance
                        .collection("users")
                        .document(widget.userId)
                        .collection('PlannerMonday')
                        .snapshots(),
                    builder: (
                      BuildContext ctx,
                      AsyncSnapshot<QuerySnapshot> snapshot,
                    ) {
                      if (!snapshot.hasData) {
                        return Container();
                      } else {
                        if (snapshot.data.documents.isEmpty) {
                          return Container();
                        } else {
                          return dataFirestore(
                              userId: widget.userId,
                              list: snapshot.data.documents);

                          //  return  new noItem();
                        }
                      }
                    },
                  )),
              SizedBox(
                height: 10.0,
              )
            ],
          ),
          _line(),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tuesday",
                  style: TextStyle(
                      fontFamily: "Sofia",
                      fontSize: 18.0,
                      color: Colors.black54,
                      fontWeight: FontWeight.w700),
                ),
                InkWell(
                    onTap: () {
                      Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (_, __, ___) => new PlannerSearch(
                                day: "Tuesday",
                                userId: widget.userId,
                              ),
                          transitionDuration: Duration(milliseconds: 1000),
                          transitionsBuilder: (_, Animation<double> animation,
                              __, Widget child) {
                            return Opacity(
                              opacity: animation.value,
                              child: child,
                            );
                          }));
                    },
                    child: Icon(Icons.add)),
              ],
            ),
          ),
          Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 0.0, bottom: 5.0),
                  child: StreamBuilder(
                    stream: Firestore.instance
                        .collection("users")
                        .document(widget.userId)
                        .collection('PlannerTuesday')
                        .snapshots(),
                    builder: (
                      BuildContext ctx,
                      AsyncSnapshot<QuerySnapshot> snapshot,
                    ) {
                      if (!snapshot.hasData) {
                        return Container();
                      } else {
                        if (snapshot.data.documents.isEmpty) {
                          return Container();
                        } else {
                          return dataFirestore(
                              userId: widget.userId,
                              list: snapshot.data.documents);

                          //  return  new noItem();
                        }
                      }
                    },
                  )),
              SizedBox(
                height: 10.0,
              )
            ],
          ),
          _line(),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Wednesday",
                  style: TextStyle(
                      fontFamily: "Sofia",
                      fontSize: 18.0,
                      color: Colors.black54,
                      fontWeight: FontWeight.w700),
                ),
                InkWell(
                    onTap: () {
                      Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (_, __, ___) => new PlannerSearch(
                                day: "Wednesday",
                                userId: widget.userId,
                              ),
                          transitionDuration: Duration(milliseconds: 1000),
                          transitionsBuilder: (_, Animation<double> animation,
                              __, Widget child) {
                            return Opacity(
                              opacity: animation.value,
                              child: child,
                            );
                          }));
                    },
                    child: Icon(Icons.add)),
              ],
            ),
          ),
          Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 0.0, bottom: 5.0),
                  child: StreamBuilder(
                    stream: Firestore.instance
                        .collection("users")
                        .document(widget.userId)
                        .collection('PlannerWednesday')
                        .snapshots(),
                    builder: (
                      BuildContext ctx,
                      AsyncSnapshot<QuerySnapshot> snapshot,
                    ) {
                      if (!snapshot.hasData) {
                        return Container();
                      } else {
                        if (snapshot.data.documents.isEmpty) {
                          return Container();
                        } else {
                          return dataFirestore(
                              userId: widget.userId,
                              list: snapshot.data.documents);

                          //  return  new noItem();
                        }
                      }
                    },
                  )),
              SizedBox(
                height: 10.0,
              )
            ],
          ),
          _line(),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Thursday",
                  style: TextStyle(
                      fontFamily: "Sofia",
                      fontSize: 18.0,
                      color: Colors.black54,
                      fontWeight: FontWeight.w700),
                ),
                InkWell(
                    onTap: () {
                      Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (_, __, ___) => new PlannerSearch(
                                day: "Thursday",
                                userId: widget.userId,
                              ),
                          transitionDuration: Duration(milliseconds: 1000),
                          transitionsBuilder: (_, Animation<double> animation,
                              __, Widget child) {
                            return Opacity(
                              opacity: animation.value,
                              child: child,
                            );
                          }));
                    },
                    child: Icon(Icons.add)),
              ],
            ),
          ),
          Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 0.0, bottom: 5.0),
                  child: StreamBuilder(
                    stream: Firestore.instance
                        .collection("users")
                        .document(widget.userId)
                        .collection('PlannerThursday')
                        .snapshots(),
                    builder: (
                      BuildContext ctx,
                      AsyncSnapshot<QuerySnapshot> snapshot,
                    ) {
                      if (!snapshot.hasData) {
                        return Container();
                      } else {
                        if (snapshot.data.documents.isEmpty) {
                          return Container();
                        } else {
                          return dataFirestore(
                              userId: widget.userId,
                              list: snapshot.data.documents);

                          //  return  new noItem();
                        }
                      }
                    },
                  )),
              SizedBox(
                height: 10.0,
              )
            ],
          ),
          _line(),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Friday",
                  style: TextStyle(
                      fontFamily: "Sofia",
                      fontSize: 18.0,
                      color: Colors.black54,
                      fontWeight: FontWeight.w700),
                ),
                InkWell(
                    onTap: () {
                      Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (_, __, ___) => new PlannerSearch(
                                day: "Friday",
                                userId: widget.userId,
                              ),
                          transitionDuration: Duration(milliseconds: 1000),
                          transitionsBuilder: (_, Animation<double> animation,
                              __, Widget child) {
                            return Opacity(
                              opacity: animation.value,
                              child: child,
                            );
                          }));
                    },
                    child: Icon(Icons.add)),
              ],
            ),
          ),
          Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 0.0, bottom: 5.0),
                  child: StreamBuilder(
                    stream: Firestore.instance
                        .collection("users")
                        .document(widget.userId)
                        .collection('PlannerFriday')
                        .snapshots(),
                    builder: (
                      BuildContext ctx,
                      AsyncSnapshot<QuerySnapshot> snapshot,
                    ) {
                      if (!snapshot.hasData) {
                        return Container();
                      } else {
                        if (snapshot.data.documents.isEmpty) {
                          return Container();
                        } else {
                          return dataFirestore(
                              userId: widget.userId,
                              list: snapshot.data.documents);

                          //  return  new noItem();
                        }
                      }
                    },
                  )),
              SizedBox(
                height: 10.0,
              )
            ],
          ),
          _line(),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Saturday",
                  style: TextStyle(
                      fontFamily: "Sofia",
                      fontSize: 18.0,
                      color: Colors.black54,
                      fontWeight: FontWeight.w700),
                ),
                InkWell(
                    onTap: () {
                      Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (_, __, ___) => new PlannerSearch(
                                day: "Saturday",
                                userId: widget.userId,
                              ),
                          transitionDuration: Duration(milliseconds: 1000),
                          transitionsBuilder: (_, Animation<double> animation,
                              __, Widget child) {
                            return Opacity(
                              opacity: animation.value,
                              child: child,
                            );
                          }));
                    },
                    child: Icon(Icons.add)),
              ],
            ),
          ),
          Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 0.0, bottom: 5.0),
                  child: StreamBuilder(
                    stream: Firestore.instance
                        .collection("users")
                        .document(widget.userId)
                        .collection('PlannerSaturday')
                        .snapshots(),
                    builder: (
                      BuildContext ctx,
                      AsyncSnapshot<QuerySnapshot> snapshot,
                    ) {
                      if (!snapshot.hasData) {
                        return Container();
                      } else {
                        if (snapshot.data.documents.isEmpty) {
                          return Container();
                        } else {
                          return dataFirestore(
                              userId: widget.userId,
                              list: snapshot.data.documents);

                          //  return  new noItem();
                        }
                      }
                    },
                  )),
              SizedBox(
                height: 10.0,
              )
            ],
          ),
          _line(),
        ],
      ),
    );
  }

  Widget _line() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: Container(
        color: Colors.black12,
        height: 0.5,
        width: double.infinity,
      ),
    );
  }
}

class dataFirestore extends StatelessWidget {
  String userId;
  dataFirestore({this.list, this.userId});
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
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 10.0, bottom: 0.0),
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
                      userId: userId,
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
            padding: const EdgeInsets.only(bottom: 10.0, top: 0.0, left: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Hero(
                  tag: 'hero-tag-${id + title}',
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    child: Container(
                      height: 100.0,
                      width: 100.0,
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
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            width: 180.0,
                            child: Text(
                              title,
                              style: TextStyle(
                                  color: Colors.black87.withOpacity(0.7),
                                  fontFamily: "Sofia",
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w700),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (_) => NetworkGiffyDialog(
                                          image: Image.network(
                                            "https://firebasestorage.googleapis.com/v0/b/cryptocanyon9.appspot.com/o/original.gif?alt=media&token=ee61ee91-1d4b-40c9-91a0-be9c8aef1767",
                                            fit: BoxFit.cover,
                                          ),
                                          title: Text('Delete this Recipe?',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: "Gotik",
                                                  fontSize: 22.0,
                                                  fontWeight: FontWeight.w600)),
                                          description: Text(
                                            "Are you sure you want to delete " +
                                                title,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: "Popins",
                                                fontWeight: FontWeight.w300,
                                                color: Colors.black26),
                                          ),
                                          onOkButtonPressed: () {
                                            Navigator.pop(context);
                                            Firestore.instance
                                                .collection("Bookmark")
                                                .document("user")
                                                .collection(title)
                                                .document(userId)
                                                .delete();

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
                                              content: Text(
                                                  "Delete Recipe " + title),
                                              backgroundColor: Colors.red,
                                              duration: Duration(seconds: 3),
                                            ));
                                          },
                                        ));
                              },
                              child: Icon(
                                Icons.delete,
                                color: Colors.black45,
                              ),
                            ),
                          ),
                        ],
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
              ],
            ),
          ),
        );
      },
    ));
  }
}
