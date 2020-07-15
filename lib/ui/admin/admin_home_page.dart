import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project/model/MenuContentItem.dart';
import 'package:project/ui/admin/account/account_management_page.dart';
import 'package:project/ui/admin/actor_management_page.dart';
import 'package:project/ui/admin/destiny/destiny_management_page.dart';
import 'package:project/ui/admin/equipment_adding_page.dart';
import 'package:project/ui/admin/Equipment/equipment_management_page.dart';
import 'package:project/ui/appbar_widget.dart';
import 'package:project/ui/custom_drawer.dart';
import 'package:project/ui/profile_management_page.dart';
import 'package:foldable_sidebar/foldable_sidebar.dart';
import 'package:project/ui/show_cart_page.dart';
import 'package:project/utils/dialog_customize.dart';

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  FSBStatus drawerStatus;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBarCustomize().setAppbar(context, 'Admin Home Page', false),
        body: FoldableSidebarBuilder(
            status: drawerStatus,
            drawer: CustomDrawer(
              closeDrawer: () {
                setState(() {
                  drawerStatus = FSBStatus.FSB_CLOSE;
                });
              },
            ),
            screenContents: getBody(context)),
        // body: listMenuItem(context),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            setState(() {
              drawerStatus = drawerStatus == FSBStatus.FSB_OPEN
                  ? FSBStatus.FSB_CLOSE
                  : FSBStatus.FSB_OPEN;
            });
          },
          child: Icon(
            Icons.menu,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget getBody(context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 20, bottom: 5, top: 2),
          alignment: Alignment.centerLeft,
          child: Text(
            'Destiny item',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ),
        listMenuItem2(context),
        Divider(
          color: Colors.black45,
          height: 15,
        ),
        Container(
          padding: EdgeInsets.only(left: 20, bottom: 5, top: 5),
          alignment: Alignment.centerLeft,
          child: Text(
            'App Service',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ),
        listMenuItem(context),
      ],
    );
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

  Widget listMenuItem2(context) {
    return Container(
      height: MediaQuery.of(context).size.height * .18,
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 2),
      child: GridView.count(
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        crossAxisCount: 3,
        children: getListMenuItem2().map((item) {
          return menuItem2(context, item.image, item.description1);
        }).toList(),
      ),
    );
  }

  /**
   * Handle event back to login page
   */
  // ignore: missing_return
  Future<bool> onBackPressed() async {
    final action =
        await Dialogs.yesAbortDialog(context, 'Do you want to Exist App ?');
    if (action == DialogAction.yes) {
      SystemNavigator.pop();
    }
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

  Container menuItem2(context, String image, String description1) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height * .1,
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
                width: size.width * .14,
              ),
              SizedBox(height: size.height * .02),
              Text(
                description1,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navigator(String des1) {
    switch (des1) {
      case 'Account Manage':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => AccountManagementPage()));
        break;
      case 'Add Actor':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DestinyManagementPage(
                      isAddActor: true,
                    )));
        break;
      case 'Destiny Management':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => DestinyManagementPage()));
        break;
      case 'Equipment Manage':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => EquipmentManagementPage()));
        break;
      case 'Add Equiment':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DestinyManagementPage(
                      isAddEquip: true,
                    )));
        break;
      case 'Profile Management':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ProfileManagementPage()));
        break;
      case 'Cart':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ShowCartPage()));
        break;
      default:
        break;
    }
  }

  List<MenuContentItem> getListMenuItem2() {
    MenuContentItem menuItemActorIcon = MenuContentItem(
        image: 'assets/images/actorIcon.png',
        description1: 'Add Actor',
        description2: 'Add actor to movie script');
    MenuContentItem menuItemShoppingEquipment = MenuContentItem(
        image: 'assets/images/equipIcon.png',
        description1: 'Add Equiment',
        description2: 'Add equipment to movie script');
    MenuContentItem menuItemShoppingCart = MenuContentItem(
      image: 'assets/images/equipmentIconShopping.png',
      description1: "Cart",
    );
    List<MenuContentItem> list = [
      menuItemActorIcon,
      menuItemShoppingEquipment,
      menuItemShoppingCart,
    ];
    return list;
  }

  List<MenuContentItem> getListMenuItem() {
    MenuContentItem menuItemAccount = MenuContentItem(
        image: 'assets/images/accountIcon.jpg',
        description1: 'Account Manage',
        description2: 'Create account for actor');

    MenuContentItem menuItemDestiny = MenuContentItem(
        image: 'assets/images/destinyIcon.png',
        description1: 'Destiny Management',
        description2: 'Create Destiny');
    MenuContentItem menuItemEquipment = MenuContentItem(
        image: 'assets/images/equimentIcon.png',
        description1: 'Equipment Manage',
        description2: 'Create Equipment');

    MenuContentItem menuItemProfile = MenuContentItem(
        image: 'assets/images/profileIcon.png',
        description1: 'Profile Management',
        description2: 'Manipulate Profile');
    List<MenuContentItem> list = [
      menuItemAccount,
      menuItemDestiny,
      menuItemEquipment,
      menuItemProfile
    ];
    return list;
  }
}
