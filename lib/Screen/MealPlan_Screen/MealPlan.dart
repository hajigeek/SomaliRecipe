import 'package:flutter/material.dart';

import 'Planner/Planner_Screen.dart';
import 'Shopping/Shopping_Screen.dart';

class MealPlan extends StatefulWidget {
  String idUser;
  MealPlan({this.idUser});

  @override
  _MealPlanState createState() => _MealPlanState();
}

class _MealPlanState extends State<MealPlan>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  ScrollController _scrollController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScroller) {
          return <Widget>[
            SliverAppBar(
              title: Text(
                'Meal Plan',
                style: TextStyle(
                    fontFamily: "Sofia",
                    fontSize: 22.0,
                    fontWeight: FontWeight.w800),
              ),
              pinned: true,
              floating: true,
              backgroundColor: Colors.white,
              forceElevated: innerBoxIsScroller,
              centerTitle: true,
              bottom: TabBar(
                indicatorColor: Colors.orangeAccent,
                labelColor: Colors.orangeAccent,
                unselectedLabelColor: Colors.black38,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 4,
                tabs: [
                  Tab(
                      icon: Text(
                    "Meal Plan",
                    style: TextStyle(
                        fontFamily: "Sofia",
                        fontWeight: FontWeight.w700,
                        fontSize: 16.0),
                  )),
                  Tab(
                      icon: Text(
                    "Shopping Item",
                    style: TextStyle(
                        fontFamily: "Sofia",
                        fontWeight: FontWeight.w700,
                        fontSize: 16.0),
                  )),
                ],
                controller: _tabController,
              ),
            )
          ];
        },
        body: TabBarView(
          children: [
            Planner(
              userId: widget.idUser,
            ),
            Shopping(
              userId: widget.idUser,
            ),
          ],
          controller: _tabController,
        ),
      ),
    );
  }
}
