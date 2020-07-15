import 'package:flutter/material.dart';
import 'package:project/ui/appbar_widget.dart';

class DetailDestinyPage extends StatefulWidget {
  int id;
  DetailDestinyPage({Key key, this.id}) : super(key: key);
  @override
  _DetailDestinyPageState createState() => _DetailDestinyPageState();
}

class _DetailDestinyPageState extends State<DetailDestinyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustomize().setAppbar(context, 'Deatail Destiny', true),
      body: Container(
        child: Text('It act time !!!'),
      ),
    );
  }
}
