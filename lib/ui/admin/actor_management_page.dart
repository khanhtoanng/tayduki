import 'package:flutter/material.dart';
import 'package:project/ui/appbar_widget.dart';

class ActorManagementPage extends StatefulWidget {
  @override
  _ActorManagementPageState createState() => _ActorManagementPageState();
}

class _ActorManagementPageState extends State<ActorManagementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBarCustomize().setAppbar(context, 'Actor Management Page', true),
      body: Container(
        child: Text('It act time !!!'),
      ),
    );
  }
}
