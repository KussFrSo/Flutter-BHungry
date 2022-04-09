import 'package:bhungry/utilities/array_screens.dart';
import 'package:bhungry/widgets/gradienticon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayout();
}

class _MobileScreenLayout extends State<MobileScreenLayout> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  int _page = 2;
  late PageController pageController;
  bool isLoading = false;
  String tipoUser = "";

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 2);
    getData();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      tipoUser = userSnap.data()!['tipoUser'];

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: SizedBox(
          height: 80.0,
          width: 80.0,
          child: FittedBox(
            child: Theme(
              data: Theme.of(context)
                  .copyWith(highlightColor: Colors.transparent),
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                elevation: 0,
                child: Image.asset("assets/img/logo.png"),
                onPressed: () => tipoUser != "Restaurante"
                    ? navigationTapped(2)
                    : navigationTapped(1),
              ),
            ),
          ),
        ),
        body: isLoading
            ? const Center(
                child: SizedBox(
                    height: 100,
                    width: 100,
                    child: CircularProgressIndicator()),
              )
            : PageView(
                children: tipoUser != "Restaurante"
                    ? ScreensItemsUser
                    : ScreensItemRest,
                physics: const NeverScrollableScrollPhysics(),
                controller: pageController,
                onPageChanged: onPageChanged,
              ),
        bottomNavigationBar: tipoUser != "Restaurante"
            ? BottomNavigationBar(
                currentIndex: _page,
                backgroundColor: Colors.white,
                onTap: navigationTapped,
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                items: [
                    BottomNavigationBarItem(
                        icon: RadiantGradientMask(
                          child: Icon(
                            Icons.star,
                            color: _page == 0 ? Colors.orange : Colors.yellow,
                          ),
                        ),
                        label: '',
                        backgroundColor: Colors.white),
                    BottomNavigationBarItem(
                        icon: RadiantGradientMask(
                          child: Icon(Icons.calendar_month,
                              color:
                                  _page == 1 ? Colors.orange : Colors.yellow),
                        ),
                        label: '',
                        backgroundColor: Colors.white),
                    const BottomNavigationBarItem(
                        icon: RadiantGradientMask(child: Icon(null)),
                        label: '',
                        backgroundColor: Colors.white),
                    BottomNavigationBarItem(
                        icon: RadiantGradientMask(
                          child: Icon(Icons.chat,
                              color:
                                  _page == 3 ? Colors.orange : Colors.yellow),
                        ),
                        label: '',
                        backgroundColor: Colors.white),
                    BottomNavigationBarItem(
                        icon: RadiantGradientMask(
                          child: Icon(Icons.settings,
                              color:
                                  _page == 4 ? Colors.orange : Colors.yellow),
                        ),
                        label: '',
                        backgroundColor: Colors.white),
                  ])
            : BottomNavigationBar(
                currentIndex: _page,
                backgroundColor: Colors.white,
                onTap: navigationTapped,
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                items: [
                    BottomNavigationBarItem(
                        icon: RadiantGradientMask(
                          child: Icon(Icons.chat,
                              color:
                                  _page == 0 ? Colors.orange : Colors.yellow),
                        ),
                        label: '',
                        backgroundColor: Colors.white),
                    const BottomNavigationBarItem(
                        icon: RadiantGradientMask(child: Icon(null)),
                        label: '',
                        backgroundColor: Colors.white),
                    BottomNavigationBarItem(
                        icon: RadiantGradientMask(
                          child: Icon(Icons.settings,
                              color:
                                  _page == 2 ? Colors.orange : Colors.yellow),
                        ),
                        label: '',
                        backgroundColor: Colors.white),
                  ]));
  }
}
