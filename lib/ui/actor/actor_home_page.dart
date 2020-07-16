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
        appBar: AppBarCustomize().setAppbar(context, 'Actor Home Page', false),
        body: listMenuItem(context));
  }

  Widget listMenuItem(context) {
    return Container(
      height: MediaQuery.of(context).size.height * .58,
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
      child: GridView.count(
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
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
  Container menuItem(
      context, String image, String description1, String description2) {
    var size = MediaQuery.of(context).size.width;
    return Container(
      child: InkWell(
        onTap: () {
          navigator(description1);
        },
        child: Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey, blurRadius: 10, offset: Offset(0, 5))
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                image,
                width: size * .17,
              ),
              SizedBox(height: size * .02),
              Text(
                description1,
                style: TextStyle(
                  fontSize: size * .045,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: size * .02),
              Text(
                description2,
                style: TextStyle(
                    fontSize: size * .04,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey[400]),
              )
            ],
          ),
        ),
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
