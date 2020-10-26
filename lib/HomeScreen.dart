import 'package:fakahany/Cart.dart';
import 'package:fakahany/Categories.dart';
import 'package:fakahany/Category.dart';
import 'package:fakahany/Offers.dart';
import 'package:fakahany/login/signup.dart';
import 'package:fakahany/more.dart';
import 'package:fakahany/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:fakahany/global/Colors.dart' as myColors;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  var Owners = '01156460761';

  static List<Widget> _widgetOptions = <Widget>[
    Category(),
    Categories(
      Owner: '01156460761',
    ),
    Cart(
      Owner: '01156460761',
    ),
    Offers(),
    MorePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: FFNavigationBar(
        theme: FFNavigationBarTheme(
          barBackgroundColor: Colors.white,
          // selectedItemBorderColor: Colors.yellow,
          selectedItemBackgroundColor: myColors.Primary,
          selectedItemIconColor: Colors.white,
          selectedItemLabelColor: Colors.black,
        ),
        selectedIndex: _selectedIndex,
        onSelectTab: _onItemTapped,
        items: [
          FFNavigationBarItem(
            iconData: Icons.home,
            label: 'الرئيسيه',
          ),
          FFNavigationBarItem(
            iconData: Icons.dashboard,
            label: 'الأقسام',
          ),
          FFNavigationBarItem(
            iconData: Icons.shopping_basket,
            label: 'الشنطه',
          ),
          FFNavigationBarItem(
            iconData: Icons.local_offer,
            label: 'العروض',
          ),
          FFNavigationBarItem(
            iconData: Icons.more_vert,
            label: 'المزيد',
          ),
        ],
      ),
    );
  }
}
