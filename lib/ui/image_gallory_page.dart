import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:project/bloc/ImageBloc.dart';
import 'package:project/ui/image_add_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageGalloryPage extends StatefulWidget {
  @override
  _ImageGalloryPageState createState() => _ImageGalloryPageState();
}

class _ImageGalloryPageState extends State<ImageGalloryPage>
    with SingleTickerProviderStateMixin {
  ImageBloc imageBloc = ImageBloc();
  TabController controller;
  @override
  void initState() {
    imageBloc.getAllActorImage();
    imageBloc.getAllEquipmentImage();
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    imageBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: setAppbarWithTab(context, 'Image Gallory', true),
      body: getBody(context),
      floatingActionButton: FloatingActionButton(
        mini: true,
        backgroundColor: Colors.orangeAccent,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ImageAddPage()));
        },
        child: Icon(Icons.add),
      ),
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
    return Container(
        height: size.height * 1,
        child: TabBarView(
          controller: controller,
          children: <Widget>[
            getActorImage(context),
            getEquipmentImage(context)
          ],
        ));
  }

  Widget getActorImage(context) {
    return Container(
      child: StreamBuilder(
        stream: imageBloc.listActorImageStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == 'loading') {
              return Center(
                  child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          Color(0xffb744b8))));
            } else {
              return Container(
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  children: snapshot.data.map<Widget>((item) {
                    print(item['image']);
                    return InkWell(
                      onTap: () {
                        Navigator.pop(context, item['image']);
                      },
                      child: Image.network(
                        item['image'],
                        fit: BoxFit.fill,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Color(0xffb744b8))),
                          );
                        },
                      ),
                    );
                  }).toList(),
                ),
              );
            }
          }
          return Text('loading..');
        },
      ),
    );
  }

  Widget getEquipmentImage(context) {
    return Container(
      child: StreamBuilder(
        stream: imageBloc.listEquipmentImageStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == 'loading') {
              return Center(
                  child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          Color(0xffb744b8))));
            } else {
              return Container(
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  children: snapshot.data.map<Widget>((item) {
                    return InkWell(
                      onTap: () {
                        Navigator.pop(context, item['image']);
                      },
                      child: Image.network(
                        item['image'],
                        fit: BoxFit.fill,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Color(0xffb744b8))),
                          );
                        },
                      ),
                    );
                  }).toList(),
                ),
              );
            }
          }
          return Text('loading.');
        },
      ),
    );
  }
}
