// import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:project/ui/appbar_widget.dart';
import 'package:project/bloc/ShoppingCartBloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class ShowCartPage extends StatefulWidget {
  @override
  _ShowCartPageState createState() => _ShowCartPageState();
}

class _ShowCartPageState extends State<ShowCartPage>
    with SingleTickerProviderStateMixin {
  TabController controller;
  final formKey = GlobalKey<FormState>();
  String role = '';
  int quantity = 0;
  @override
  void initState() {
    super.initState();
    shoppingBloc.getListActor();
    shoppingBloc.getListEquipmentToDestitny();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: setAppbarWithTab(context, 'Cart Page', true),
      body: getBody(context),
    );
  }

  Widget setAppbarWithTab(BuildContext context, String title, bool isBack) {
    return AppBar(
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
      bottom: TabBar(
        controller: controller,
        tabs: <Widget>[
          Tab(
            icon: Icon(
              Icons.recent_actors,
              size: 40,
              color: Colors.white,
            ),
          ),
          Tab(
            icon: Icon(
              Icons.video_call,
              size: 40,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Widget getBody(context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        Container(
          height: size.height * .7,
          child: TabBarView(
            controller: controller,
            children: <Widget>[
              getListActor(context),
              getListEquipment(context)
            ],
          ),
        ),
        Container(
          width: size.width * .9,
          height: size.height * .08,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(colors: [
                Color(0xFFF37335),
                Color(0xFFFDC830),
              ])),
          child: SizedBox.expand(
              child: FlatButton(
            onPressed: () {
              checkout();
            },
            child: Text(
              "Checkout",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
          )),
        )
      ],
    );
  }

  Widget getListEquipment(context) {
    return StreamBuilder(
        // important -> if don't have initData : the stream can not load data for the first call
        initialData: shoppingBloc.listEquipmentToDestitny,
        stream: shoppingBloc.listEquipmentStream,
        builder: (context, snapshot) {
          List list = snapshot.data;
          return list.length == 0
              ? emptyMention()
              : listCartEquipment(list, snapshot, context);
        });
  }

  Widget getListActor(context) {
    // debugger();
    return StreamBuilder(
        // important -> if don't have initData : the stream can not load data for the first call
        initialData: shoppingBloc.listActorToDestiny,
        stream: shoppingBloc.listActorInDestinyStream,
        builder: (context, snapshot) {
          List list = snapshot.data;
          return list.length == 0
              ? emptyMention()
              : listCartActor(list, snapshot, context);
        });
  }

  Container emptyMention() {
    return Container(
      child: Text('There is no item!'),
    );
  }

  ListView listCartActor(List list, AsyncSnapshot snapshot, context) {
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext context, index) {
          final actorList = snapshot.data;
          return listItemActor(actorList, index, context);
        });
  }

  ListView listCartEquipment(List list, AsyncSnapshot snapshot, context) {
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext context, index) {
          final equipmentList = snapshot.data;
          return listItemEquipment(equipmentList, index, context);
        });
  }

  Widget listItemEquipment(equipmentList, int index, context) {
    var size = MediaQuery.of(context).size;
    int count = index + 1;
    return Card(
      color: Colors.transparent,
      margin: EdgeInsets.all(15),
      shadowColor: Colors.grey[100],
      elevation: 50,
      child: Slidable(
        closeOnScroll: true,
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: Container(
            alignment: Alignment.center,
            height: size.height * .15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey, blurRadius: 10, offset: Offset(0, 5))
              ],
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                  horizontal: size.width * .09, vertical: size.height * .01),
              leading: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.red,
                child: ClipOval(
                  child: Center(
                    child: Text(count.toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                  ),
                ),
              ),
              title: Container(
                padding: EdgeInsets.only(left: size.width * .03),
                child: Text(
                  equipmentList[index].destinyName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              subtitle: Container(
                  padding: EdgeInsets.only(
                      top: size.height * .01, left: size.width * .03),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            'Equipment :',
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                          Expanded(
                            child: Text(
                              equipmentList[index].equipName,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            'Quantity :',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          Expanded(
                            child: Text(
                              equipmentList[index].equipmentQuantity.toString(),
                              style: TextStyle(
                                  fontSize: 16, color: Colors.redAccent),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
              trailing: Icon(
                Icons.arrow_back,
                size: 20,
              ),
            )),
        secondaryActions: <Widget>[
          Container(
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
            child: IconSlideAction(
              color: Colors.transparent,
              caption: 'Edit',
              icon: Icons.edit,
              onTap: () {
                // editModelBottomShee(context, actorList[index]);
              },
            ),
          ),
          Container(
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.redAccent),
            child: IconSlideAction(
              caption: 'Delete',
              color: Colors.transparent,
              icon: Icons.delete,
              onTap: () {
                // shoppingBloc.deleteActor(actorList[index].idDestiny,
                //     actorList[index].username, actorList[index].roleInDestiny);
                // shoppingBloc.getListActor();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget listItemActor(actorList, int index, context) {
    var size = MediaQuery.of(context).size;
    int count = index + 1;
    return Card(
      color: Colors.transparent,
      margin: EdgeInsets.all(15),
      shadowColor: Colors.grey[100],
      elevation: 50,
      child: Slidable(
        closeOnScroll: true,
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: Container(
            alignment: Alignment.center,
            height: size.height * .15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey, blurRadius: 10, offset: Offset(0, 5))
              ],
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                  horizontal: size.width * .09, vertical: size.height * .01),
              leading: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.red,
                child: ClipOval(
                  child: Center(
                    child: Text(count.toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                  ),
                ),
              ),
              title: Container(
                padding: EdgeInsets.only(left: size.width * .03),
                child: Text(
                  actorList[index].destinyName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              subtitle: Container(
                  padding: EdgeInsets.only(
                      top: size.height * .01, left: size.width * .03),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            'Fullname :',
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                          Expanded(
                            child: Text(
                              actorList[index].fullname,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            'Role :',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          Expanded(
                            child: Text(
                              actorList[index].roleInDestiny,
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 16, color: Colors.redAccent),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
              trailing: Icon(
                Icons.arrow_back,
                size: 20,
              ),
            )),
        secondaryActions: <Widget>[
          Container(
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
            child: IconSlideAction(
              color: Colors.transparent,
              caption: 'Edit',
              icon: Icons.edit,
              onTap: () {
                editModelBottomShee(context, actorList[index]);
              },
            ),
          ),
          Container(
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.redAccent),
            child: IconSlideAction(
              caption: 'Delete',
              color: Colors.transparent,
              icon: Icons.delete,
              onTap: () {
                shoppingBloc.deleteActor(actorList[index].idDestiny,
                    actorList[index].username, actorList[index].roleInDestiny);
                shoppingBloc.getListActor();
              },
            ),
          ),
        ],
      ),
    );
  }

  editModelBottomShee(context, item) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
        ),
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: StatefulBuilder(
                builder: ((BuildContext context, StateSetter setModelState) {
                  var size = MediaQuery.of(context).size;
                  return Padding(
                    padding: EdgeInsets.all(5),
                    child: Container(
                        height: size.height * .6,
                        child: contentBottomSheet(context, size, item)),
                  );
                }),
              ),
            ),
          );
        });
  }

  Widget contentBottomSheet(context, Size size, item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              'Action',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.cancel, color: Colors.orange),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        Container(
          padding:
              EdgeInsets.only(left: size.width * .08, top: size.height * .02),
          margin: EdgeInsets.all(5),
          child: Row(
            children: <Widget>[
              Text(
                'Destiny :',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                width: size.width * .1,
              ),
              Text(
                item.destinyName,
                style: TextStyle(fontSize: 20),
              )
            ],
          ),
        ),
        Divider(
          height: 10,
          color: Colors.black,
        ),
        Container(
          padding:
              EdgeInsets.only(left: size.width * .08, top: size.height * .02),
          margin: EdgeInsets.all(5),
          child: Row(
            children: <Widget>[
              Text(
                'Actor    :',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                width: size.width * .1,
              ),
              Text(
                item.fullname,
                style: TextStyle(fontSize: 20),
              )
            ],
          ),
        ),
        Divider(
          height: 15,
          color: Colors.black,
        ),
        SizedBox(
          height: size.height * .25,
          child: Container(
              padding: EdgeInsets.only(top: size.height * .05),
              width: size.width * .8,
              child: Form(
                key: formKey,
                child: TextFormField(
                  initialValue: role,
                  decoration: InputDecoration(
                    hintText: "Role",
                    hintStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  validator: (input) =>
                      input.length <= 0 ? 'Role is required' : null,
                  onSaved: (input) => role = input,
                ),
              )),
        ),
        Container(
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(colors: [
                Color(0xFFFDC830),
                Color(0xFFF37335),
              ])),
          child: SizedBox.expand(
              child: FlatButton(
            onPressed: () {
              updateActorToCart(item);
            },
            child: Text(
              "Update",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
          )),
        )
      ],
    );
  }

  updateActorToCart(item) {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      shoppingBloc.updateActor(
          item.idDestiny, item.username, item.roleInDestiny, role);
      setState(() {
        role = '';
      });
      Navigator.of(context).pop();
    }
  }

  checkout() {
    shoppingBloc.insertListActorToDestiny();
    shoppingBloc.insertListEquipmentToDestiny();
  }
}
