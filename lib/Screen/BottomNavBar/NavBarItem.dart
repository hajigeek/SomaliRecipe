import 'dart:async';

enum NavBarItem { HOME, VIDEO, DISCOVER, FAVORITE, USERS }

class BottomNavBarBloc {
  final StreamController<NavBarItem> _navBarController =
      StreamController<NavBarItem>.broadcast();

  NavBarItem defaultItem = NavBarItem.HOME;

  Stream<NavBarItem> get itemStream => _navBarController.stream;

  void pickItem(int i) {
    switch (i) {
      case 0:
        _navBarController.sink.add(NavBarItem.HOME);
        break;
      case 1:
        _navBarController.sink.add(NavBarItem.VIDEO);
        break;
      case 2:
        _navBarController.sink.add(NavBarItem.DISCOVER);
        break;
      case 3:
        _navBarController.sink.add(NavBarItem.USERS);
      //  _navBarController.sink.add(NavBarItem.FAVORITE);
        break;
      case 4:
        _navBarController.sink.add(NavBarItem.USERS);
        break;
    }
  }

  close() {
    _navBarController?.close();
  }
}
