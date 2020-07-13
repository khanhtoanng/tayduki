import 'package:flutter/material.dart';
import 'package:project/ui/appbar_widget.dart';

class ActorOncomingMoviePage extends StatefulWidget {
  @override
  _ActorOncomingMoviePageState createState() => _ActorOncomingMoviePageState();
}

class _ActorOncomingMoviePageState extends State<ActorOncomingMoviePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustomize().setAppbar(context,'Oncoming Movie Calender Page',true),
      body: Container(
        child: Text('The time will come boi!'),
      ),
    );
  }
}
