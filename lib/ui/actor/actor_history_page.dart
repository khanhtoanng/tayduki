import 'package:flutter/material.dart';
import 'package:project/ui/appbar_widget.dart';

class ActorHistoryPage extends StatefulWidget {
  @override
  _ActorHistoryPageState createState() => _ActorHistoryPageState();
}

class _ActorHistoryPageState extends State<ActorHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustomize().setAppbar(context,'Actor History Page',true),
      body: Container(
        child: Text('The time will come boi!'),
      ),
    );
  }
}
