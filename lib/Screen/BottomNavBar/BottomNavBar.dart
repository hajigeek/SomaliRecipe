import 'dart:typed_data';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:Somali_Yurecipe/Screen/B1_Home_Screen/B1_HomeScreen.dart';
import 'package:Somali_Yurecipe/Screen/B2_Youtube_Video/B2_PlaylistVideo.dart';
import 'package:Somali_Yurecipe/Screen/B3_Discover/B3_Discover.dart';
import 'package:Somali_Yurecipe/Screen/B3_Favorite_Screen/B3_Favorite_Screen.dart';
import 'package:Somali_Yurecipe/Screen/B4_Profile_Screen/B4_Profile_Screen.dart';
import 'package:Somali_Yurecipe/Screen/BottomNavBar/NavBarItem.dart';
import 'package:Somali_Yurecipe/Screen/Settings/Bloc.dart';
import 'package:Somali_Yurecipe/Style/Style.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavBar extends StatefulWidget {
  String idUser;
  ThemeBloc themeBloc;
  BottomNavBar({this.idUser, this.themeBloc});
  createState() => _BottomNavBarState(themeBloc);
}

class _BottomNavBarState extends State<BottomNavBar> {
  ThemeBloc themeBloc;
  _BottomNavBarState(this.themeBloc);
  String barcode = '';
  Uint8List bytes = Uint8List(200);
  BottomNavBarBloc _bottomNavBarBloc;
  @override
  void initState() {
    super.initState();
    _bottomNavBarBloc = BottomNavBarBloc();
    barcode = '';
  }

  @override
  void dispose() {
    _bottomNavBarBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 0;
    return Scaffold(
      backgroundColor: colorStyle.whiteBackground,
      body: StreamBuilder<NavBarItem>(
        stream: _bottomNavBarBloc.itemStream,
        initialData: _bottomNavBarBloc.defaultItem,
        builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
          switch (snapshot.data) {
            case NavBarItem.HOME:
              return HomeScreenT1(
                userID: widget.idUser,
              );
            // case NavBarItem.VIDEO:
            //   return B2Playlist(
            //     idUser: widget.idUser,
            //   );
            case NavBarItem.DISCOVER:
              return discover(
                userId: widget.idUser,
              );
            case NavBarItem.FAVORITE:
              return favoriteScreen(
                idUser: widget.idUser,
              );
            case NavBarItem.USERS:
              return B4ProfileScreen(
                idUser: widget.idUser,
              );
          }
          return Container();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: StreamBuilder(
        stream: _bottomNavBarBloc.itemStream,
        initialData: _bottomNavBarBloc.defaultItem,
        builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  color: Colors.black.withOpacity(.1),
                )
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                child: GNav(
                  rippleColor: Colors.grey[300],
                  hoverColor: Colors.grey[00],
                  gap: 8,
                  activeColor: Colors.black,
                  iconSize: 24,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  duration: Duration(milliseconds: 400),
                  tabBackgroundColor: Colors.grey[100],
                  color: Colors.black,
                  tabs: [
                    GButton(
                      icon: Icons.home,
                      text: 'Home',
                    ),
                    GButton(
                      icon: Icons.videocam_sharp,
                      text: 'Video',
                    ),
                    GButton(
                      icon: Icons.search,
                      text: 'Explore',
                    ),
                    GButton(
                      icon: Icons.person,
                      text: 'Profile',
                    ),

                  ],
                  selectedIndex: snapshot.data.index,
                  onTabChange: _bottomNavBarBloc.pickItem,

                ),
              ),
            ),
          );
          // return BottomNavigationBar(
          //   selectedFontSize: 10.0,
          //   unselectedFontSize: 10.0,
          //   selectedItemColor: colorStyle.primaryColor,
          //   unselectedItemColor: colorStyle.iconColorUnselecLight,
          //   backgroundColor: colorStyle.whiteBackground,
          //   type: BottomNavigationBarType.fixed,
          //   iconSize: 25.0,
          //   currentIndex: snapshot.data.index,
          //   onTap: _bottomNavBarBloc.pickItem,
          //   items: [
          //     BottomNavigationBarItem(
          //       label: 'Home',
          //       icon: Icon(
          //         EvaIcons.homeOutline,
          //       ),
          //       activeIcon: Icon(
          //         Icons.home,
          //       ),
          //     ),
          //     BottomNavigationBarItem(
          //       label: 'Video',
          //       icon: Icon(
          //         EvaIcons.videoOutline,
          //       ),
          //       activeIcon: Icon(
          //         EvaIcons.video,
          //       ),
          //     ),
          //     BottomNavigationBarItem(
          //       label: 'Discover',
          //       icon: Icon(
          //         EvaIcons.keypadOutline,
          //       ),
          //       activeIcon: Icon(
          //         EvaIcons.keypad,
          //       ),
          //     ),
          //     BottomNavigationBarItem(
          //       label: 'Favorite',
          //       icon: Icon(
          //         EvaIcons.heartOutline,
          //       ),
          //       activeIcon: Icon(
          //         EvaIcons.heart,
          //       ),
          //     ),
          //     BottomNavigationBarItem(
          //       label: 'Users',
          //       icon: Icon(
          //         EvaIcons.personOutline,
          //       ),
          //       activeIcon: Icon(
          //         EvaIcons.person,
          //       ),
          //     ),
          //   ],
          // );
        },
      ),
    );
  }
}
