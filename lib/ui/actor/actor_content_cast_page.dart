import 'package:flutter/material.dart';
import 'package:project/ui/appbar_widget.dart';

class ActorContentCastPage extends StatefulWidget {
  @override
  _ActorContentCastPageState createState() => _ActorContentCastPageState();
}

class _ActorContentCastPageState extends State<ActorContentCastPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustomize().setAppbar(context,'Content Cast Page',true),
      body: Container(
        child: Text('The time will come boi!'),
      ),
    );
  }
}
