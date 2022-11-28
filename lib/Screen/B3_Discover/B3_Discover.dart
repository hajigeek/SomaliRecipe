import 'package:flutter/material.dart';
import 'package:Somali_Yurecipe/Screen/B3_Discover/Category/dinner.dart';
import 'package:Somali_Yurecipe/Screen/Search/search.dart';
import 'package:Somali_Yurecipe/Style/Style.dart';
import 'package:Somali_Yurecipe/Widget/bubbleTabCustom/bubbleTab.dart';

import 'Category/breakfast.dart';
import 'Category/healty.dart';
import 'Category/lunch.dart';

class discover extends StatefulWidget {
  String userId;
  discover({this.userId});

  @override
  _discoverState createState() => _discoverState();
}

class _discoverState extends State<discover> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 60.0,
                  ),
                  Expanded(
                    child: DefaultTabController(
                      length: 4,
                      child: new Scaffold(
                        backgroundColor: Colors.white,
                        appBar: PreferredSize(
                          preferredSize:
                              Size.fromHeight(40.0), // here the desired height
                          child: new AppBar(
                              backgroundColor: Colors.transparent,
                              elevation: 0.0,
                              centerTitle: true,
                              automaticallyImplyLeading: false,
                              title: new TabBar(
                                indicatorSize: TabBarIndicatorSize.tab,
                                unselectedLabelColor: Colors.black12,
                                labelColor: Colors.white,
                                labelStyle: TextStyle(fontSize: 19.0),
                                indicator: new BubbleTabIndicator(
                                  indicatorHeight: 36.0,
                                  indicatorColor: colorStyle.primaryColor,
                                  tabBarIndicatorSize: TabBarIndicatorSize.tab,
                                ),
                                tabs: <Widget>[
                                  new Tab(
                                    child: Text(
                                      "Dinner",
                                      style: TextStyle(
                                        fontSize: 14.2,
                                        fontFamily: "Sofia",
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  new Tab(
                                    child: Text(
                                      "Lunch",
                                      style: TextStyle(
                                        fontSize: 14.5,
                                        fontFamily: "Sofia",
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  new Tab(
                                    child: Text(
                                      "Breakfast",
                                      style: TextStyle(
                                        fontSize: 11.0,
                                        fontFamily: "Sofia",
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  new Tab(
                                    child: Text(
                                      "Healty",
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontFamily: "Sofia",
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        body: new TabBarView(
                          children: [
                            DinnerDiscover(
                              idUser: widget.userId,
                            ),
                            lunchDiscover(
                              idUser: widget.userId,
                            ),
                            breakfastDiscover(
                              idUser: widget.userId,
                            ),
                            healtyDiscover(
                              idUser: widget.userId,
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
          Padding(
            padding: const EdgeInsets.only(
              top: 40.0,
              left: 20.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Discover",
                  style: TextStyle(
                      fontFamily: "Sofia",
                      fontWeight: FontWeight.w800,
                      fontSize: 32.0,
                      letterSpacing: 1.5,
                      color: Colors.black),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(PageRouteBuilder(
                            pageBuilder: (_, __, ___) => new Search(
                                  userId: widget.userId,
                                )));
                      },
                      child: Icon(
                        Icons.search,
                        size: 28.0,
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
