import 'package:flutter/material.dart';

class FilterText extends StatelessWidget {
  const FilterText({Key key, @required this.bloc, this.height})
      : super(key: key);

  final dynamic bloc;
  final double height;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: EdgeInsets.only(left: 10, right: 10),
      padding: EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              offset: Offset(0, 10),
              blurRadius: 50,
              color: Colors.black12.withOpacity(.3)),
        ],
      ),
      child: TextField(
          onChanged: (value) {
            bloc.filter(value);
          },
          decoration: InputDecoration(
            hintText: "Search",
            suffixIcon: Icon(Icons.search),
            hintStyle: TextStyle(color: Colors.grey[400]),
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          )),
    );
  }
}
