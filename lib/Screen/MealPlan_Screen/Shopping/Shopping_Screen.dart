import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

import 'Item_Detail.dart';
import 'Shopping_Search.dart';

class Shopping extends StatefulWidget {
  String userId;
  Shopping({this.userId});

  @override
  _ShoppingState createState() => _ShoppingState();
}

class _ShoppingState extends State<Shopping> {
  @override
  Widget build(BuildContext context) {
    double mediaQueryData = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var pageRouteBuilder = PageRouteBuilder(
              pageBuilder: (_, __, ___) => ShoppingSearch(
                    userId: widget.userId,
                  ));
          Navigator.of(context).push(pageRouteBuilder);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(top: 0.0, bottom: 0.0),
                child: StreamBuilder(
                  stream: Firestore.instance
                      .collection("users")
                      .document(widget.userId)
                      .collection('ShoppingList')
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
                        return dataFirestore(
                            userId: widget.userId,
                            list: snapshot.data.documents);

                        //  return  new noItem();
                      }
                    }
                  },
                )),
            SizedBox(
              height: 40.0,
            )
          ],
        ),
      ),
    );
  }

  Widget noItem() {
    return Container(
      width: 500.0,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 40.0)),
            Image.asset(
              "assets/ilustration/4.png",
              height: 300.0,
            ),
            Text(
              "Add something to your shopping list",
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

class dataFirestore extends StatelessWidget {
  String userId;
  dataFirestore({this.list, this.userId});
  final List<DocumentSnapshot> list;

  bool rememberMe = false;

  void _onRememberMeChanged(bool newValue) {
    rememberMe = newValue;

    if (rememberMe) {
      // TODO: Here goes your functionality that remembers the user.
    } else {
      // TODO: Forget the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
//      size: const Size.fromHeight(410.0),
        child: ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      primary: false,
      itemCount: list.length,
      itemBuilder: (context, i) {
        String id = list[i].data['id'].toString();
        String category = list[i].data['category'].toString();
        String name = list[i].data['name'].toString();
        String quantity = list[i].data['quantity'];

        return InkWell(
          onTap: () {
            Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (_, __, ___) => new ItemShoppingDetail(
                      name: name,
                      id: id,
                      category: category,
                      idUSer: userId,
                      quantity: quantity,
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
            padding: const EdgeInsets.only(bottom: 10.0, top: 5.0, left: 15.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      //           Checkbox(
                      //               activeColor: Colors.blue,
                      //               value: rememberMe,
                      //               onChanged: (bool value) {
                      //   // setState(() {
                      //     rememberMe = true;
                      //   // });
                      // },),
                      Container(
                        height: 40.0,
                        width: 180.0,
                        child: Text(
                          name,
                          style: TextStyle(
                              color: Colors.black87.withOpacity(0.7),
                              fontFamily: "Sofia",
                              fontSize: 17.0,
                              fontWeight: FontWeight.w700),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Row(
                          children: <Widget>[
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
                                            title: Text(
                                                'Delete ' +
                                                    name +
                                                    '\n' +
                                                    ' Item?',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontFamily: "Gotik",
                                                    fontSize: 22.0,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            description: Text(
                                              "Are you sure you want to delete " +
                                                  name,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: "Popins",
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.black26),
                                            ),
                                            onOkButtonPressed: () {
                                              Navigator.pop(context);
                                              Firestore.instance
                                                  .collection("ShoppingList")
                                                  .document(id + userId)
                                                  .delete();

                                              Firestore.instance.runTransaction(
                                                  (transaction) async {
                                                DocumentSnapshot snapshot =
                                                    await transaction
                                                        .get(list[i].reference);
                                                await transaction
                                                    .delete(snapshot.reference);
                                              });
                                              Scaffold.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text("Delete " + name),
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
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    height: 0.5,
                    color: Colors.black12.withOpacity(0.1),
                  ),
                )
              ],
            ),
          ),
        );
      },
    ));
  }
}
