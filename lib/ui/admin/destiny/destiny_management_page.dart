import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:project/bloc/DestinyBloc.dart';
import 'package:project/ui/admin/Equipment/equipment_management_page.dart';
import 'package:project/ui/admin/account/account_management_page.dart';
import 'package:project/ui/admin/detail_destiny_page.dart';
import 'package:project/ui/admin/destiny/destiny_create_page.dart';
import 'package:project/ui/appbar_widget.dart';
import 'package:project/utils/dialog_customize.dart';
import 'package:project/utils/filter_text.dart';

class DestinyManagementPage extends StatefulWidget {
  bool isAddActor;
  bool isAddEquip;
  DestinyManagementPage({
    Key key,
    this.isAddActor = false,
    this.isAddEquip = false,
  }) : super(key: key);
  @override
  _DestinyManagementPageState createState() => _DestinyManagementPageState();
}

class _DestinyManagementPageState extends State<DestinyManagementPage> {
  // bool isLoading = false;
  DestinyBloc bloc = DestinyBloc();

  @override
  void initState() {
    bloc.getAllDestiny();
    super.initState();
  }

  @override
  void dispose() {
    widget.isAddActor = false;
    widget.isAddEquip = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustomize().setAppbar(context, 'Destiny Management', true),
      body: Container(child: getBody(context)),
      floatingActionButton: FloatingActionButton(
        mini: true,
        backgroundColor: Colors.orangeAccent,
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DestinyCreatePage()))
              .then((value) {
            if (value != null) {
              bloc.getAllDestiny();
            }
          });
          ;
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget getBody(context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        Container(
          height: size.height * .2,
          child: Stack(
            children: <Widget>[
              Container(
                height: size.height * .2 - 27,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(36),
                    bottomRight: Radius.circular(36),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFFDC830),
                      Color(0xFFF37335),
                    ],
                  ),
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                    child: SizedBox(
                      width: size.width * .3,
                      height: size.height * .2,
                      child: Image.asset('assets/images/destinyIcon2.jpg',
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: FilterText(
                  bloc: bloc,
                  height: 40,
                ),
              )
            ],
          ),
        ),
        widget.isAddActor == true || widget.isAddEquip == true
            ? Container(
                padding: EdgeInsets.only(left: 20, bottom: 5, top: 5),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Choose Destiny',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Colors.redAccent),
                ),
              )
            : Container(
                padding: EdgeInsets.only(left: 20, bottom: 5, top: 5),
                alignment: Alignment.centerLeft,
                child: Text(
                  'List Destiny',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
        SingleChildScrollView(
          child: Container(
            height: size.height * .625,
            child: Column(
              children: <Widget>[
                getListDestiny(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  StreamBuilder getListDestiny(context) {
    return StreamBuilder(
      stream: bloc.listDestinyStream,
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
            List listDestiny = snapshot.data;
            return Expanded(
              child: ListView.builder(
                  itemCount: listDestiny.length,
                  itemBuilder: (context, index) {
                    return cardItem(listDestiny[index], context);
                  }),
            );
          }
        }
        return Text(
          snapshot.hasError
              ? snapshot.error
              : 'Some thing went wrong! Please ry again',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        );
      },
    );
  }

  Widget cardItem(item, context) {
    var size = MediaQuery.of(context).size;
    return Card(
      color: Colors.transparent,
      margin: EdgeInsets.all(15),
      shadowColor: Colors.grey[100],
      elevation: 50,
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: InkWell(
          onTap: () {
            if (widget.isAddActor) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AccountManagementPage(
                            isShopping: true,
                            idDestiny: item['id'],
                            nameDestiny: item['name'],
                          )));
            } else if (widget.isAddEquip) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EquipmentManagementPage(
                            isShopping: true,
                            idDestiny: item['id'],
                            nameDestiny: item['name'],
                          )));
            } else {
              showDetail(item['id']);
            }
          },
          child: Container(
              alignment: Alignment.center,
              height: size.height * .17,
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
                title: Container(
                  padding: EdgeInsets.only(left: size.width * .03),
                  child: Text(
                    item['name'],
                    style: TextStyle(fontSize: 17),
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
                              'Description :',
                              style: TextStyle(fontSize: 13),
                            ),
                            Text(
                              item['description'],
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              'Location :',
                              style: TextStyle(fontSize: 13),
                            ),
                            Text(
                              item['location'],
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              'Number of shot :',
                              style: TextStyle(fontSize: 13),
                            ),
                            Text(
                              item['numberOfScreen'].toString(),
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        )
                      ],
                    )),
                trailing: Icon(
                  Icons.arrow_back,
                  size: 20,
                ),
              )),
        ),
        secondaryActions: <Widget>[
          Container(
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
            child: IconSlideAction(
              color: Colors.transparent,
              caption: 'Edit',
              icon: Icons.edit,
              onTap: () {
                updateDestiny(item);
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
                deleteDestiny(item['id']);
              },
            ),
          ),
        ],
      ),
    );
  }

  showDetail(id) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailDestinyPage(
                  id: id,
                )));
  }

  updateDestiny(item) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DestinyCreatePage(
                  id: item['id'],
                  isDone: item['isDone'],
                  name: item['name'],
                  description: item['description'],
                  createTime: DateTime.parse(item['createTime']),
                  endTime: DateTime.parse(item['endTime']),
                  location: item['location'],
                  detail: item['detail'],
                  numberOfScreen: item['numberOfScreen'].toString(),
                  isUpdate: true,
                ))).then((value) {
      if (value != null) {
        bloc.getAllDestiny();
      }
    });
  }

  deleteDestiny(id) async {
    final action =
        await Dialogs.yesAbortDialog(context, 'Do you want to Delete');
    if (action == DialogAction.yes) {
      var result = await bloc.deleteDestiny(id.toString());
      if (result == -1) {
        await Dialogs.showMessageDialog(context,
            'Some error is just happened.\nMake sure that destiny is not in any Scenario!!');
      } else if (result == 1) {
        await Dialogs.showMessageDialog(context, 'Delete success');
        bloc.getAllDestiny();
      }
    }
  }
}
