import 'package:flutter/material.dart';
import 'package:project/model/MenuContentItem.dart';
import 'package:project/ui/actor/actor_content_cast_page.dart';
import 'package:project/ui/actor/actor_history_page.dart';
import 'package:project/ui/actor/actor_oncoming_movie_page.dart';
import 'package:project/ui/appbar_widget.dart';
import 'package:project/ui/profile_management_page.dart';

class ActorHomePage extends StatefulWidget {
  @override
  _ActorHomePageState createState() => _ActorHomePageState();
}

class _ActorHomePageState extends State<ActorHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBarCustomize().setAppbar(context,'Actor Home Page',false),
        body: listMenuItem(context));
  }

  Container listMenuItem(BuildContext context) {
    return Container(
      child: GridView.count(
        crossAxisCount: 2,
        children: getListMenuItem().map((item) {
          return menuItem(
              context, item.image, item.description1, item.description2);
        }).toList(),
      ),
    );
  }

  /**
   * Menu Item
   */
  Container menuItem(BuildContext context, String image, String description1,
      String description2) {
    return Container(
      child: FlatButton(
        padding: EdgeInsets.all(5),
        onPressed: () {
          navigator(description1);
        },
        child: Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(143, 148, 251, 2),
                      blurRadius: 20,
                      offset: Offset(0, 10))
                ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  image,
                  width: 65,
                ),
                SizedBox(height: 14),
                Text(
                  description1,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 14),
                Text(
                  description2,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey[600]),
                )
              ],
            )),
      ),
    );
  }

  void navigator(String des1) {
    switch (des1) {
      case 'History':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ActorHistoryPage()));
        break;
      case 'Oncoming Calendar':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ActorOncomingMoviePage()));
        break;
      case 'Content Cast':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ActorContentCastPage()));
        break;
      case 'Profile Management':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ProfileManagementPage()));
        break;
      default:
        break;
    }
  }

  List<MenuContentItem> getListMenuItem() {
    MenuContentItem menuItemHistory = MenuContentItem(
        image: 'assets/images/previous.png',
        description1: 'History',
        description2: 'See history movie');
    MenuContentItem menuItemNextMovie = MenuContentItem(
        image: 'assets/images/next.png',
        description1: 'Oncoming Calendar',
        description2: 'Canlender on taking movie');
    MenuContentItem menuItemContent = MenuContentItem(
        image: 'assets/images/contentActor.png',
        description1: 'Content Cast',
        description2: 'Content the cast in movie ');
    MenuContentItem menuItemProfile = MenuContentItem(
        image: 'assets/images/profileIcon.png',
        description1: 'Profile Management',
        description2: 'Manipulate Profile');

    List<MenuContentItem> list = [
      menuItemContent,
      menuItemHistory,
      menuItemNextMovie,
      menuItemProfile
    ];
    return list;
  }
}
