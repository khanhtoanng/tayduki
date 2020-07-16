import 'package:flutter/material.dart';
import 'package:project/bloc/AccountBloc.dart';
import 'package:project/bloc/DestinyBloc.dart';
import 'package:project/ui/appbar_widget.dart';

class DetailDestinyPage extends StatefulWidget {
  int id;
  DetailDestinyPage({Key key, this.id}) : super(key: key);
  @override
  _DetailDestinyPageState createState() => _DetailDestinyPageState();
}

class _DetailDestinyPageState extends State<DetailDestinyPage> {
  DestinyBloc bloc = DestinyBloc();

  @override
  void initState() {
    bloc.getDestinyById(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarCustomize().setAppbar(context, 'Deatail Destiny', true),
        body: getBody());
  }

  Widget getBody() {
    return SingleChildScrollView(
      child: StreamBuilder(
        stream: bloc.destinyStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == 'loading') {
              return Container(
                margin: EdgeInsets.all(15),
                child: Center(
                    child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            Color(0xffb744b8)))),
              );
            } else {
              var item = snapshot.data;
              return getDetail(context, item);
            }
          }
          return Text(
            snapshot.hasError ? snapshot.error : '.',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          );
        },
      ),
    );
  }

  Widget getDetail(context, item) {
    var size = MediaQuery.of(context).size;
    List<dynamic> listActor = item['listActor'];
    List<dynamic> listEquipment = item['listEquipment'];
    return Column(
      children: <Widget>[
        Text(
          'Information Destiny',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              decoration: TextDecoration.underline),
        ),
        detailItem(size, item['name'], 'Destiny Name       :'),
        divider(),
        detailItem(size, item['location'], 'Location                :'),
        divider(),
        detailItem(size, item['description'], 'Descritption          :'),
        divider(),
        detailItem(size, item['createTime'], 'Start time              :'),
        divider(),
        detailItem(size, item['endTime'], 'End time                :'),
        divider(),
        detailItem(
            size, item['numberOfScreen'].toString(), 'Number of screen:'),
        divider(),
        Text(
          'List Actor In Destiny',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              decoration: TextDecoration.underline),
        ),
        listActor.length != 0
            ? Container(
                height: size.height * .4,
                child: ListView.builder(
                    itemCount: listActor.length,
                    itemBuilder: (context, index) {
                      return cardActorItem(listActor[index], context, index);
                    }),
              )
            : Container(
                margin: EdgeInsets.all(10),
                alignment: Alignment.centerLeft,
                child: Text('Empty!'),
              ),
        Text(
          'List Equipment In Destiny',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              decoration: TextDecoration.underline),
        ),
        listEquipment.length != 0
            ? Container(
                height: size.height * .4,
                child: ListView.builder(
                    itemCount: listEquipment.length,
                    itemBuilder: (context, index) {
                      return cardEquipmentItem(
                          listEquipment[index], context, index);
                    }),
              )
            : Container(
                margin: EdgeInsets.all(10),
                alignment: Alignment.centerLeft,
                child: Text('Empty!'),
              ),
      ],
    );
  }

  Widget cardEquipmentItem(item, context, index) {
    var size = MediaQuery.of(context).size;
    int count = index + 1;

    return Card(
      color: Colors.blue[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.redAccent,
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
            item['name'],
            style: TextStyle(fontSize: 15),
          ),
        ),
        subtitle: Container(
            padding:
                EdgeInsets.only(top: size.height * .01, left: size.width * .03),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      'Quantity :',
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      item['equipmentQuantity'].toString(),
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }

  Widget cardActorItem(item, context, index) {
    var size = MediaQuery.of(context).size;
    int count = index + 1;

    return Card(
      color: Colors.green[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.redAccent,
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
            item['username'],
            style: TextStyle(fontSize: 15),
          ),
        ),
        subtitle: Container(
            padding:
                EdgeInsets.only(top: size.height * .01, left: size.width * .03),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      'Full Name :',
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      item['fullname'],
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      'Role :',
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      item['roleInDestiny'],
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }

  Widget divider() {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Divider(
        height: 15,
        color: Colors.black45,
      ),
    );
  }

  Container detailItem(Size size, text, text2) {
    return Container(
      padding: EdgeInsets.only(left: 50, top: 10),
      child: Row(
        children: <Widget>[
          Text(
            text2,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            width: size.width * .1,
          ),
          Text(
            text,
            style: TextStyle(fontSize: 16),
          )
        ],
      ),
    );
  }
}
