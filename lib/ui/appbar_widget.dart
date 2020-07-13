import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppBarCustomize {
  Widget setAppbar(BuildContext context, String title, bool isBack) {
    return AppBar(
      elevation: 0,
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Color(0xFFFDC830),
          Color(0xFFF37335),
        ])),
      ),
      automaticallyImplyLeading: isBack,
      actions: <Widget>[
        PopupMenuButton(
            onSelected: (choice) async {
              switch (choice) {
                case 'Sign out':
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/LoginPage', (Route<dynamic> route) => false);
                  break;
                case 'Home':
                  final prefs = await SharedPreferences.getInstance();
                  String role = prefs.getString('role');
                  role == 'admin'
                      ? Navigator.of(context).pushNamedAndRemoveUntil(
                          '/AdminHomePage', (Route<dynamic> route) => false)
                      : Navigator.of(context).pushNamedAndRemoveUntil(
                          '/ActorHomePage', (Route<dynamic> route) => false);
                  break;
                default:
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  const PopupMenuItem(
                      value: 'Sign out', child: Text('Sign out')),
                  const PopupMenuItem(value: 'Home', child: Text('Home Page'))
                ])
      ],
    );
  }
}
