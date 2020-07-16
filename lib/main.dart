import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:project/ui/actor/actor_home_page.dart';
import 'package:project/ui/admin/account/account_management_page.dart';
import 'package:project/ui/admin/admin_home_page.dart';
import 'package:project/ui/login_1st_page.dart';
import 'ui/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      initialRoute: '/LoginPage',
      routes: <String, WidgetBuilder>{
        '/LoginPage': (BuildContext context) => new LoginPage(),
        '/AdminHomePage': (BuildContext context) => new AdminHomePage(),
        '/ActorHomePage': (BuildContext context) => new ActorHomePage(),
        '/AnimationFirstPage': (BuildContext context) =>
            new AnimationFirstPage(),
        '/AccountManagementPage': (BuildContext context) =>
            new AccountManagementPage(),
      },
      title: 'App',
    );
  }
}
