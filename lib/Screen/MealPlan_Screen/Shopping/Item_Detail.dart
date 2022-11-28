import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ItemShoppingDetail extends StatefulWidget {
  String name, category;
  String quantity;
  String idUSer, id;
  ItemShoppingDetail(
      {this.idUSer, this.category, this.name, this.quantity, this.id});

  @override
  _ItemShoppingDetailState createState() => _ItemShoppingDetailState();
}

class _ItemShoppingDetailState extends State<ItemShoppingDetail> {
  TextEditingController nameController, categoryController, quantityController;
  String name = "";
  String category = "Empty Country";
  String quantity = "Empty City";

  @override
  void initState() {
    nameController = TextEditingController(text: widget.name);
    categoryController = TextEditingController(text: widget.category);
    quantityController = TextEditingController(text: widget.quantity);
    // TODO: implement initState
    super.initState();
  }

  updateData() async {
    await Firestore.instance
        .collection('users')
        .document(widget.idUSer)
        .collection('ShoppingList')
        .document(widget.id + widget.idUSer)
        .updateData({
      "name": nameController.text,
      "category": categoryController.text,
      "quantity": quantityController.text
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "Edit Item",
          // widget.idUSer.toString(),
          style: TextStyle(fontFamily: "Sofia", color: Colors.orangeAccent),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Container(
                height: 50.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 10.0,
                          color: Colors.black12.withOpacity(0.1)),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(40.0))),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Theme(
                      data: ThemeData(
                        highlightColor: Colors.white,
                        hintColor: Colors.white,
                      ),
                      child: TextFormField(
                          style: TextStyle(
                              color: Colors.black87, fontFamily: "Sofia"),
                          controller: nameController,
                          decoration: InputDecoration(
                            hintText: 'Name',
                            hintStyle: TextStyle(
                                color: Colors.black54, fontFamily: "Sofia"),
                            enabledBorder: new UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1.0,
                                  style: BorderStyle.none),
                            ),
                          )),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Container(
                height: 50.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 10.0,
                          color: Colors.black12.withOpacity(0.1)),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(40.0))),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Theme(
                      data: ThemeData(
                        highlightColor: Colors.white,
                        hintColor: Colors.white,
                      ),
                      child: TextFormField(
                          style: TextStyle(
                              color: Colors.black87, fontFamily: "Sofia"),
                          controller: categoryController,
                          decoration: InputDecoration(
                            hintText: 'Category',
                            hintStyle: TextStyle(
                                color: Colors.black54, fontFamily: "Sofia"),
                            enabledBorder: new UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1.0,
                                  style: BorderStyle.none),
                            ),
                          )),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Container(
                height: 50.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 10.0,
                          color: Colors.black12.withOpacity(0.1)),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(40.0))),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Theme(
                      data: ThemeData(
                        highlightColor: Colors.white,
                        hintColor: Colors.white,
                      ),
                      child: TextFormField(
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                              color: Colors.black87, fontFamily: "Sofia"),
                          controller: quantityController,
                          decoration: InputDecoration(
                            hintText: 'Quantity',
                            hintStyle: TextStyle(
                                color: Colors.black54, fontFamily: "Sofia"),
                            enabledBorder: new UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1.0,
                                  style: BorderStyle.none),
                            ),
                          )),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 280.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: InkWell(
                onTap: () {
                  updateData();
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: 55.0,
                  width: double.infinity,
                  child: Center(
                    child: Text("Saved",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 17.0,
                            fontFamily: "Sofia")),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
