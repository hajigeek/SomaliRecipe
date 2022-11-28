import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:Somali_Yurecipe/Style/Style.dart';
import 'package:shimmer/shimmer.dart';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'PlayYoutube.dart';

class B2Playlist extends StatefulWidget {
  String idUser;
  B2Playlist({this.idUser});

  @override
  _B2PlaylistState createState() => _B2PlaylistState();
}

class _B2PlaylistState extends State<B2Playlist> {
  Future<List> getData() async {
    final respone = await http.get("https://flutterlistrecipe.herokuapp.com/");
    return json.decode(respone.body);
  }

  @override
  bool loadImage = true;
  bool colorIconCard = false;
  bool chosseCard = false;
  bool colorIconCard2 = true;

  var loadImageAnimation = Container(
      color: Colors.white,
      child: ListView.builder(
        itemBuilder: (ctx, index) => cardLoading(),
        itemCount: 30,
      ));

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

  @override
  Widget build(BuildContext context) {
    double mediaQueryData = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            chosseCard
                ? Padding(
                    padding: const EdgeInsets.only(top: 75.0),
                    child: Container(
                      color: Colors.white,
                      child: FutureBuilder<List>(
                          future: getData(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) print(snapshot.error);
                            return snapshot.hasData
                                ? new gridVideo(
                                    list: snapshot.data,
                                    mediaQueryData: mediaQueryData,
                                  )
                                : new Container(
                                    color: Colors.white,
                                    child: ListView.builder(
                                      itemBuilder: (ctx, index) =>
                                          cardLoading(),
                                      itemCount: 20,
                                    ));
                          }),
                    ))
                : Padding(
                    padding: const EdgeInsets.only(top: 75.0),
                    child: Container(
                      color: Colors.white,
                      child: FutureBuilder<List>(
                          future: getData(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) print(snapshot.error);
                            return snapshot.hasData
                                ? new ListVideo(
                                    list: snapshot.data,
                                  )
                                : new Container(
                                    color: Colors.white,
                                    child: ListView.builder(
                                      itemBuilder: (ctx, index) =>
                                          cardLoading(),
                                      itemCount: 20,
                                    ));
                          }),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                height: 100.0,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 43.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Video Recipe",
                            style: TextStyle(
                                fontFamily: "Sofia",
                                fontSize: 29.0,
                                fontWeight: FontWeight.w800,
                                color: Colors.black),
                          ),
                          Row(
                            children: <Widget>[
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (colorIconCard == true) {
                                        colorIconCard = false;
                                        colorIconCard2 = true;
                                        chosseCard = false;
                                      } else {
                                        colorIconCard = true;
                                        colorIconCard2 = false;
                                        chosseCard = true;
                                      }
                                    });
                                  },
                                  child: Icon(
                                    Icons.calendar_view_day,
                                    color: colorIconCard
                                        ? Colors.black12
                                        : colorStyle.primaryColor,
                                  )),
                              SizedBox(
                                width: 14.0,
                              ),
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (colorIconCard2 == true) {
                                        colorIconCard2 = false;
                                        colorIconCard = true;
                                        chosseCard = true;
                                      } else {
                                        colorIconCard2 = true;
                                        colorIconCard = false;
                                        chosseCard = false;
                                      }
                                    });
                                  },
                                  child: Icon(
                                    Icons.dashboard,
                                    color: colorIconCard2
                                        ? Colors.black12
                                        : colorStyle.primaryColor,
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

class gridVideo extends StatelessWidget {
  List list;
  double mediaQueryData;
  gridVideo({this.list, this.mediaQueryData});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 5.0),
      childAspectRatio: mediaQueryData / 1250,
      crossAxisSpacing: 0.0,
      mainAxisSpacing: 0.0,
      primary: false,
      children: List.generate(
        /// Get data in flashSaleItem.dart (ListItem folder)
        list == null ? 0 : list.length,
        (i) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 30.0,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (_, __, ___) => new videoPlay(
                          url:
                              "https://www.youtube.com/embed/${list[i]['contentDetails']['videoId']}",
                          title: list[i]['snippet']['title'],
                          desc: list[i]['snippet']['description'],
                        )));
              },
              child: Container(
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Colors.black12.withOpacity(0.1),
                      spreadRadius: 0.2,
                      blurRadius: 0.5)
                ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Stack(
                    //   children: <Widget>[

                    //   ],
                    // ),
                    Container(
                      height: 140.0,
                      color: Colors.yellow,
                      child: Container(
                        height: 140.0,
                        width: MediaQuery.of(context).size.width / 2.1,
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          image: DecorationImage(
                              image: NetworkImage(list[i]['snippet']
                                  ['thumbnails']["high"]["url"]),
                              fit: BoxFit.cover),
                        ),
                        child: Container(
                          height: 140.0,
                          color: Colors.black12.withOpacity(0.3),
                          child: Center(
                            child: Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 50.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 8.0, right: 3.0, top: 15.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2.7,
                        child: Text(
                          list[i]['snippet']['title'],
                          style: TextStyle(
                              fontFamily: "Sofia",
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 17.5),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, top: 5.0, bottom: 15.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2.7,
                        child: Text(
                          list[i]['snippet']['description'],
                          style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w300,
                              fontFamily: "Sofia",
                              color: Colors.black38),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ListVideo extends StatelessWidget {
  List list;
  ListVideo({this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        return InkWell(
          onTap: () {
            // Navigator.of(context).push(PageRouteBuilder(pageBuilder: (_,__,___)=> new detailVideo(videoId: list[i]['contentDetails']['videoId'],)));
            Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (_, __, ___) => new videoPlay(
                      url:
                          "https://www.youtube.com/embed/${list[i]['contentDetails']['videoId']}",
                      title: list[i]['snippet']['title'],
                      desc: list[i]['snippet']['description'],
                    )));
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
            child: Container(
              height: 300.0,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12.withOpacity(0.1),
                        blurRadius: 3.0,
                        spreadRadius: 1.0)
                  ]),
              child: Column(children: [
                Container(
                  height: 165.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10.0),
                        topLeft: Radius.circular(10.0)),
                    image: DecorationImage(
                        image: NetworkImage(
                            list[i]['snippet']['thumbnails']["high"]["url"]),
                        fit: BoxFit.cover),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black12.withOpacity(0.4),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10.0),
                          topLeft: Radius.circular(10.0)),
                    ),
                    child: Center(
                      child: CircleAvatar(
                          radius: 30.0,
                          backgroundColor: Colors.white24,
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 30.0,
                          )),
                    ),
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
                                width: 290.0,
                                child: Text(
                                  list[i]['snippet']['title'],
                                  style: TextStyle(
                                      fontFamily: "Sofia",
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17.5),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                )),
                            Padding(padding: EdgeInsets.only(top: 5.0)),
                            Container(
                              width: 290.0,
                              child: Text(
                                list[i]['snippet']['description'],
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: "Sofia",
                                    color: Colors.black38),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                              ),
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
//        return new Text(list[i]['snippet']['title'],style: TextStyle(fontFamily: "Sofia",color: Colors.black),);
      },
    );
  }
}

class cardLoading extends StatelessWidget {
  @override
  cardLoading();
  final color = Colors.black38;
  Widget build(BuildContext context) {
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
          baseColor: color,
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
              child: CircleAvatar(
                  radius: 30.0,
                  backgroundColor: Colors.black12,
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 30.0,
                  )),
              alignment: Alignment.center,
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
}
