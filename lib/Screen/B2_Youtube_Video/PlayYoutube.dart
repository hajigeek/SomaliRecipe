import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Somali_Yurecipe/Screen/B1_Home_Screen/Detail/detail_recipe.dart';
import 'package:Somali_Yurecipe/Style/Style.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class detailVideo extends StatefulWidget {
  String videoId;
  detailVideo({this.videoId});

  @override
  _detailVideoState createState() => _detailVideoState();
}

class _detailVideoState extends State<detailVideo> {
  //static String videoId;
  //_detailVideoState(this.videoId);
  YoutubePlayerController _controller;
  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        forceHD: false,
        enableCaption: false,
        controlsVisibleAtStart: false,
        disableDragSeek: false,
        hideControls: false,
        hideThumbnail: false,
        isLive: false,
        loop: false,
      ),
    );
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                progressColors: ProgressBarColors(
                  playedColor: Colors.orange,
                  handleColor: Colors.orange,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class videoPlay extends StatelessWidget {
  String url, title, desc;

  InAppWebViewController webView;
  videoPlay({this.url, this.title, this.desc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text(
          "Videos",
          style: TextStyle(
            fontFamily: "Sofia",
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            height: 220.0,
            color: Colors.black,
            width: double.infinity,
            //                     child: WebviewScaffold(
            //   url: url,

            // ),

            child: InAppWebView(
              initialUrl: url,
              initialHeaders: {},
              // initialOptions: InAppWebViewWidgetOptions(
              //     inAppWebViewOptions: InAppWebViewOptions(
              //       debuggingEnabled: true,
              //     )
              // ),
              onWebViewCreated: (InAppWebViewController controller) {
                webView = controller;
              },
              onLoadStart: (InAppWebViewController controller, String url) {},
              onLoadStop: (InAppWebViewController controller, String url) {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 240.0, left: 20.0),
            child: Text(
              title,
              style: TextStyle(
                  fontFamily: "Sofia",
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontSize: 20.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 335.0),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    child: StreamBuilder(
                      stream:
                          Firestore.instance.collection("recipe").snapshots(),
                      builder: (BuildContext ctx,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        return new SuggestedRecipe(
                          list: snapshot.data.documents,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SuggestedRecipe extends StatelessWidget {
  final List<DocumentSnapshot> list;
  SuggestedRecipe({this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      shrinkWrap: true,
      primary: false,
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
            Navigator.of(context).pushReplacement(PageRouteBuilder(
                pageBuilder: (_, __, ___) => new RecipeDetailScreen(
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Hero(
                  tag: 'hero-tag-${id}',
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
                              fontSize: 17.0,
                              fontWeight: FontWeight.w500),
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
//        return new Text(list[i]['snippet']['title'],style: TextStyle(fontFamily: "Sofia",color: Colors.black),);
      },
    );
  }
}
