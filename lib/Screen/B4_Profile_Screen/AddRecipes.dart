import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Somali_Yurecipe/Screen/BottomNavBar/BottomNavBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart';
import 'dart:async';

class AddRecipe extends StatefulWidget {
  String userId;
  AddRecipe({this.userId});

  @override
  _AddRecipeState createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  String _nama, _photoProfile, _email;

  var PicUrl;

  File _image;
  String filename;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      print('Image Path $_image');
    });
  }

  Future uploadPic(BuildContext context) async {
    String fileName = basename(_image.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    PicUrl = dowurl.toString();
    setState(() {
      print(" Picture uploaded");
     ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(content: Text(' Picture Uploaded')));
    });
  }

  Future selectPhoto() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
        filename = basename(_image.path);
        uploadImage();
      });
    });
  }

  Future uploadImage() async {
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(filename);

    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);

    var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    await uploadTask.onComplete;
    print('File Uploaded');
    PicUrl = dowurl.toString();
    setState(() {
      PicUrl = dowurl.toString();
    });
    print("download url = $PicUrl");
    return PicUrl;
  }

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
          _nama = userDocument["name"];
          _email = userDocument["email"];
          _photoProfile = userDocument["photoProfile"];

          setState(() {
            var userDocument = snapshot.data;
            _nama = userDocument["name"];
            _email = userDocument["email"];
            _photoProfile = userDocument["photoProfile"];
          });
        }

        var userDocument = snapshot.data;
        return Stack(
          children: <Widget>[Text(userDocument["name"])],
        );
      },
    );
  }

  String data;
  bool imageUpload = true;

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dataIn = prefs.getString("clockin") ?? 'default';
    return dataIn;
  }

  callme() async {
    await Future.delayed(Duration(seconds: 20));
    getData().then((value) => {
          setState(() {
            data = value;
            data = "test";
          })
        });
  }

  void initState() {
    callme();
    _getData();
    super.initState();
  }

  final GlobalKey<FormState> form = GlobalKey<FormState>();
  String _name, _problem, _phoneNumber, _fullName;

  String _nameRecipes;
  String _timeCooking, _rating;

  TextEditingController recipe = new TextEditingController();
  TextEditingController time = new TextEditingController();
  TextEditingController rating = new TextEditingController();
  TextEditingController calorie = new TextEditingController();

  String _setDate;
  String dateTime;

  String _setTime, _calorie;

  String _valOccassion;
  String _valAvailable;
  List _listOccassion = ["Lunch", "Dinner", "Breakfast"];

  final List<String> _dataIngredients = List.empty(growable: true);
  final TextEditingController _ingredients = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<String> _dataDirection = List.empty(growable: true);
  final TextEditingController _direction = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Create uuid object
    var uuid = Uuid();

    // Generate a v4 (random) id
    var v4 = uuid.v4();
    void userSaved() {
      Firestore.instance.runTransaction((Transaction transaction) async {
        SharedPreferences prefs;
        prefs = await SharedPreferences.getInstance();
        Firestore.instance
            .collection("users")
            .document(widget.userId)
            .collection('recipe')
            .add({
          "calorie": _calorie,
          "category": _valOccassion,
          "directions": _dataDirection,
          "id": v4,
          "image": PicUrl.toString(),
          "ingredients": _dataIngredients,
          "rating": num.parse(rating.text),
          "time": _timeCooking,
          "title": _nameRecipes,
          "type": "popular"
        });
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: Text(
          "Create Recipe",
          style: TextStyle(fontFamily: "Sofia", fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(right: 12.0, left: 12.0, top: 1.0),
          child: Form(
            key: form,
            child: StreamBuilder(
                stream: Firestore.instance
                    .collection('users')
                    .document(widget.userId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return new Text("Loading");
                  } else {
                    var userDocument = snapshot.data;

                    _nama = userDocument["name"];
                    _email = userDocument["email"];
                    _photoProfile = userDocument["photoProfile"];
                  }

                  var userDocument = snapshot.data;

                  return Stack(children: [
                    Text(
                      userDocument["name"] != null ? _nama : "Name",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Sofia",
                          fontWeight: FontWeight.w700,
                          fontSize: 20.0),
                    ),
                    Text(
                      userDocument["email"] != null
                          ? userDocument["email"]
                          : "Email",
                      style: TextStyle(
                          color: Colors.black38,
                          fontFamily: "Sofia",
                          fontWeight: FontWeight.w300,
                          fontSize: 16.0),
                    ),
                    Container(
                      height: 90.0,
                      width: 90.0,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(userDocument[
                                          "photoProfile"] !=
                                      null
                                  ? userDocument["photoProfile"]
                                  : "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png"),
                              fit: BoxFit.cover),
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(50.0),
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12.withOpacity(0.1),
                                blurRadius: 10.0,
                                spreadRadius: 2.0)
                          ]),
                    ),
                    Container(
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 30.0,
                          ),
                          imageUpload
                              ? _image == null
                                  ? new Stack(
                                      children: <Widget>[
                                        Container(
                                          height: 240.0,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      "assets/image/empty.jpeg"))),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 200.0),
                                          child: Align(
                                            alignment: Alignment.bottomRight,
                                            child: InkWell(
                                              onTap: () {
                                                selectPhoto();
                                              },
                                              child: Container(
                                                height: 55.0,
                                                width: 55.0,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              50.0)),
                                                  color: Colors.blueAccent,
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.camera_alt,
                                                    color: Colors.white,
                                                    size: 22.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : data == null
                                      ? Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 10.0,
                                            backgroundColor: Colors.red,
                                          ),
                                        )
                                      : Container(
                                          height: 240.0,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: FileImage(_image)),
                                          ))
                              : CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                ),
                          SizedBox(
                            height: 30.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10.0, top: 10.0),
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40.0))),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 15.0),
                                  child: Theme(
                                    data: ThemeData(
                                      highlightColor: Colors.white,
                                      hintColor: Colors.white,
                                    ),
                                    child: TextFormField(
                                        validator: (input) {
                                          if (input.isEmpty) {
                                            return 'Please input Name';
                                          }
                                        },
                                        onSaved: (input) =>
                                            _nameRecipes = input,
                                        controller: recipe,
                                        decoration: InputDecoration(
                                          hintText: "Recipes Name",
                                          hintStyle: TextStyle(
                                              fontFamily: "Sofia",
                                              color: Colors.black),
                                          enabledBorder:
                                              new UnderlineInputBorder(
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
                            height: 20.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10.0, top: 10.0),
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40.0))),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 15.0),
                                  child: Theme(
                                    data: ThemeData(
                                      highlightColor: Colors.white,
                                      hintColor: Colors.white,
                                    ),
                                    child: TextFormField(
                                        validator: (input) {
                                          if (input.isEmpty) {
                                            return 'Please input time cooking';
                                          }
                                        },
                                        onSaved: (String input) {
                                          _timeCooking = input;
                                        },
                                        controller: time,
                                        keyboardType: TextInputType.name,
                                        decoration: InputDecoration(
                                          hintText: "Time Cooking",
                                          hintStyle: TextStyle(
                                              fontFamily: "Sofia",
                                              color: Colors.black),
                                          enabledBorder:
                                              new UnderlineInputBorder(
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
                            height: 20.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10.0, top: 10.0),
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40.0))),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 15.0),
                                  child: Theme(
                                    data: ThemeData(
                                      highlightColor: Colors.white,
                                      hintColor: Colors.white,
                                    ),
                                    child: TextFormField(
                                        validator: (input) {
                                          if (input.isEmpty) {
                                            return 'Please input your rating';
                                          }
                                        },
                                        onSaved: (input) => _rating = input,
                                        controller: rating,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          hintText:
                                              "Rating Recipes (note: use dots '.')",
                                          hintStyle: TextStyle(
                                              fontFamily: "Sofia",
                                              color: Colors.black),
                                          enabledBorder:
                                              new UnderlineInputBorder(
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
                            height: 10.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10.0, top: 10.0),
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40.0))),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, right: 15.0),
                                child: DropdownButton(
                                  hint: Text(
                                    "Category Recipes",
                                    style: TextStyle(
                                        fontFamily: "Sofia",
                                        color: Colors.black,
                                        fontSize: 16.0),
                                  ),
                                  underline: Container(),
                                  style: TextStyle(
                                      fontFamily: "Sofia", color: Colors.black),
                                  value: _valOccassion,
                                  items: _listOccassion.map((value) {
                                    return DropdownMenuItem(
                                      child: Text(value),
                                      value: value,
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _valOccassion = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10.0, top: 10.0),
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40.0))),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 15.0),
                                  child: Theme(
                                    data: ThemeData(
                                      highlightColor: Colors.white,
                                      hintColor: Colors.white,
                                    ),
                                    child: TextFormField(
                                        validator: (input) {
                                          if (input.isEmpty) {
                                            return 'Please input Calorie';
                                          }
                                        },
                                        onSaved: (input) => _calorie = input,
                                        controller: calorie,
                                        decoration: InputDecoration(
                                          hintText: "Calorie Recipes",
                                          hintStyle: TextStyle(
                                              fontFamily: "Sofia",
                                              color: Colors.black),
                                          enabledBorder:
                                              new UnderlineInputBorder(
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
                            height: 10.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10.0, top: 10.0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 10.0,
                                        color: Colors.black12.withOpacity(0.1)),
                                  ],
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40.0))),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 5.0, left: 15.0),
                                    child: TextFormField(
                                      controller: _ingredients,
                                      maxLines: 2,
                                      decoration: InputDecoration(
                                        hintText:
                                            'Ingredients (example: tomato, sauce) comma to enter data',
                                        hintStyle: TextStyle(
                                            fontFamily: "Sofia",
                                            color: Colors.black,
                                            fontSize: 16.0),
                                      ),
                                      style: TextStyle(fontSize: 20),
                                      onChanged: (value) {
                                        if (value.contains(','))
                                          Future.delayed(
                                            Duration.zero,
                                            () => setState(() {
                                              final str =
                                                  value.replaceAll(',', '');
                                              _ingredients.text = '';
                                              if (str.isNotEmpty)
                                                _dataIngredients.add(str);
                                            }),
                                          ).then(
                                            (value) =>
                                                _scrollController.animateTo(
                                              _scrollController.position
                                                      .maxScrollExtent +
                                                  30,
                                              duration: const Duration(
                                                  milliseconds: 250),
                                              curve: Curves.easeInOut,
                                            ),
                                          );
                                      },
                                    ),
                                  ),
                                  Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: _dataIngredients
                                          .map((item) => Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0,
                                                    left: 10.0,
                                                    bottom: 10.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "-   ",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              1.3,
                                                      child: new Text(
                                                        item,
                                                        style: TextStyle(
                                                            fontFamily: "Sofia",
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 18.0),
                                                        overflow:
                                                            TextOverflow.clip,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ))
                                          .toList()),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10.0, top: 10.0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 10.0,
                                        color: Colors.black12.withOpacity(0.1)),
                                  ],
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40.0))),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 5.0, left: 15.0),
                                    child: TextFormField(
                                      maxLines: 6,
                                      controller: _direction,
                                      decoration: InputDecoration(
                                        hintText:
                                            'Direction (example : step 1, step 2) comma to enter data',
                                        hintStyle: TextStyle(
                                            fontFamily: "Sofia",
                                            color: Colors.black,
                                            fontSize: 16.0),
                                      ),
                                      style: TextStyle(fontSize: 20),
                                      onChanged: (value) {
                                        if (value.contains(','))
                                          Future.delayed(
                                            Duration.zero,
                                            () => setState(() {
                                              final str =
                                                  value.replaceAll(',', '');
                                              _direction.text = '';
                                              if (str.isNotEmpty)
                                                _dataDirection.add(str);
                                            }),
                                          ).then(
                                            (value) =>
                                                _scrollController.animateTo(
                                              _scrollController.position
                                                      .maxScrollExtent +
                                                  30,
                                              duration: const Duration(
                                                  milliseconds: 250),
                                              curve: Curves.easeInOut,
                                            ),
                                          );
                                      },
                                    ),
                                  ),
                                  Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: _dataDirection
                                          .map((item) => Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0,
                                                    left: 10.0,
                                                    bottom: 10.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "-   ",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              1.3,
                                                      child: new Text(
                                                        item,
                                                        style: TextStyle(
                                                            fontFamily: "Sofia",
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 18.0),
                                                        overflow:
                                                            TextOverflow.clip,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ))
                                          .toList()),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          InkWell(
                            onTap: () async {
                              SharedPreferences prefs;
                              prefs = await SharedPreferences.getInstance();

                              final formState = form.currentState;
                              if (formState.validate()) {
                                formState.save();
                                try {
                                  // user.sendEmailVerification();

                                } catch (e) {
                                  print('Error: $e');
                                  CircularProgressIndicator();
                                  print(e.message);
                                  print(_email);
                                } finally {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => BottomNavBar(
                                                idUser: widget.userId,
                                              )),
                                      (Route<dynamic> route) => false);
                                  _addToSearchIndex(_nameRecipes, v4);

                                  userSaved();
                                }
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Error"),
                                        content:
                                            Text("Please input your recipe"),
                                        actions: <Widget>[
                                          ElevatedButton(
                                            child: Text("Close"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      );
                                    });
                              }
                            },
                            child: Container(
                              height: 55.0,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Color(0xFFFF975D),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40.0))),
                              child: Center(
                                child: Text(
                                  "Create Recipe",
                                  style: TextStyle(
                                      fontFamily: "Sofia",
                                      color: Colors.white,
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          )
                        ],
                      ),
                    ),
                  ]);
                }),
          ),
        ),
      ),
    );
  }

  void _addToSearchIndex(String name, String v4) {
    List<String> splitList = name.split(" ");

    List<String> indexList = [];

    for (int i = 0; i < splitList.length; i++) {
      for (int y = 1; y < splitList[i].length + 1; y++) {
        indexList.add(splitList[i].substring(0, y).toLowerCase());
      }
    }
    print(indexList);
    Firestore.instance.runTransaction((Transaction transaction) async {
      Firestore.instance.collection("recipe").document().setData({
        "calorie": _calorie,
        "category": _valOccassion,
        "directions": _dataDirection,
        "id": v4,
        "searchIndex": indexList,
        "image": PicUrl.toString(),
        "ingredients": _dataIngredients,
        "rating": num.parse(rating.text),
        "time": _timeCooking,
        "title": _nameRecipes,
        "type": "popular"
      });
    });
  }
}
