import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:project/bloc/AccountBloc.dart';
import 'package:project/bloc/EquipmentBloc.dart';
import 'package:project/ui/admin/Equipment/equipment_create_page.dart';
import 'package:project/ui/admin/account/account_create_page.dart';
import 'package:project/ui/appbar_widget.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:project/ui/show_cart_page.dart';
import 'package:project/utils/dialog_customize.dart';
import 'package:project/bloc/ShoppingCartBloc.dart';
import 'package:project/utils/filter_text.dart';
import 'package:toast/toast.dart';

class EquipmentManagementPage extends StatefulWidget {
  bool isShopping;
  int idDestiny;
  String nameDestiny;
  EquipmentManagementPage(
      {Key key, this.isShopping = false, this.idDestiny, this.nameDestiny})
      : super(key: key);
  @override
  _EquipmentManagementPageState createState() =>
      _EquipmentManagementPageState();
}

class _EquipmentManagementPageState extends State<EquipmentManagementPage> {
  EquipmentBloc bloc = EquipmentBloc();
  int quantity = 0;
  DateTime createTime, endTime;

  @override
  void initState() {
    bloc.getAllEquipment();
    super.initState();
  }

  @override
  void dispose() {
    createTime = null;
    endTime = null;
    super.dispose();
    print('dispose');
  }

  @override
  Widget build(BuildContext context) {
    return widget.isShopping ? getPageWithShopping(context) : getPage(context);
  }

  Scaffold getPage(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:
          AppBarCustomize().setAppbar(context, 'Equipment Management', true),
      body: SingleChildScrollView(child: Container(child: getBody(context))),
      floatingActionButton: Container(
        padding: EdgeInsets.only(top: 10),
        child: FloatingActionButton(
          mini: true,
          backgroundColor: Colors.orangeAccent,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EquipmentCreatePage())).then((value) {
              if (value != null) {
                bloc.getAllEquipment();
              }
            });
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Scaffold getPageWithShopping(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:
          AppBarCustomize().setAppbar(context, 'Equipment Management', true),
      body: SingleChildScrollView(child: Container(child: getBody(context))),
      floatingActionButton: FloatingActionButton(
        mini: true,
        backgroundColor: Colors.orangeAccent,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ShowCartPage()));
        },
        child: Icon(Icons.shopping_basket),
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
                      width: size.width * .5,
                      height: size.height * .25,
                      child: Image.asset('assets/images/equimentIcon.png',
                          fit: BoxFit.contain),
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
        Container(
          height: size.height * .1,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              datepickerStart(context),
              Icon(Icons.arrow_forward),
              datepickerEnd(context),
            ],
          ),
        ),
        widget.isShopping == true
            ? Container(
                padding: EdgeInsets.only(left: 20, bottom: 5, top: 5),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Choose Equipment',
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
                  'List Equipment',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Colors.redAccent),
                ),
              ),
        SingleChildScrollView(
          child: Container(
            height: size.height * .525,
            child: Column(
              children: <Widget>[
                getListEquipment(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget datepickerStart(context) {
    return InkWell(
      onTap: () async {
        await showDatePicker(
          context: context,
          initialDate: createTime == null ? DateTime.now() : createTime,
          firstDate: DateTime(2018),
          lastDate: DateTime(2090),
        ).then((value) {
          if (value != null) {
            setState(() {
              createTime = value;
            });
            bloc.filterByDate(start: createTime, end: endTime);
          } else {
            setState(() {
              createTime = null;
            });
            bloc.filterByDate(start: createTime, end: endTime);
          }
        });
      },
      child: Container(
          margin: EdgeInsets.only(left: 40),
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
          decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(10)),
          child: Text(
            createTime == null
                ? 'Start date'
                : createTime.toString().split(' ')[0],
            style: TextStyle(fontSize: 15, color: Colors.black54),
          )),
    );
  }

  Widget datepickerEnd(context) {
    return InkWell(
      onTap: () async {
        await showDatePicker(
          context: context,
          initialDate: endTime == null ? DateTime.now() : endTime,
          firstDate: DateTime(2018),
          lastDate: DateTime(2090),
        ).then((value) {
          if (value != null) {
            setState(() {
              endTime = value;
            });
            bloc.filterByDate(start: createTime, end: endTime);
          } else {
            setState(() {
              endTime = null;
            });
            bloc.filterByDate(start: createTime, end: endTime);
          }
        });
      },
      child: Container(
          margin: EdgeInsets.only(right: 40),
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
          decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(10)),
          child: Text(
            endTime == null ? 'End date' : endTime.toString().split(' ')[0],
            style: TextStyle(fontSize: 15, color: Colors.black54),
          )),
    );
  }

  StreamBuilder getListEquipment(context) {
    return StreamBuilder(
      stream: bloc.listEquipmentStream,
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
            List listEquipment = snapshot.data;
            return Expanded(
              child: ListView.builder(
                  itemCount: listEquipment.length,
                  itemBuilder: (context, index) {
                    return cardItem(listEquipment[index], context);
                  }),
            );
          }
        }
        return Text(
          snapshot.hasError
              ? snapshot.error
              : 'Some thing went wrong! Please try again',
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
              onTap: () {
                if (widget.isShopping) {
                  editModelBottomShee(context, item);
                }
              },
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.transparent,
                child: ClipOval(
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: Image.network(item['image'], fit: BoxFit.fill),
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
                  padding: EdgeInsets.only(
                      top: size.height * .01, left: size.width * .03),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: size.height * .05,
                        width: double.infinity,
                        child: Text(
                          'Description :${item['description']}',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            'Quantity :',
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            item['quantity'].toString(),
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            'Create Time :',
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            item['createTime'],
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  )),
              trailing: Icon(
                Icons.arrow_back,
                size: 20,
              ),
            )),
        secondaryActions: <Widget>[
          Container(
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
            child: IconSlideAction(
              color: Colors.transparent,
              caption: 'Edit',
              icon: Icons.edit,
              onTap: () {
                updateEquipment(item);
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
                deleteEquipment(item['id']);
              },
            ),
          ),
        ],
      ),
    );
  }

  deleteEquipment(id) async {
    final action =
        await Dialogs.yesAbortDialog(context, 'Do you want to Delete');
    if (action == DialogAction.yes) {
      int result = await bloc.deleteEquipment(id);
      if (result == -1) {
        await Dialogs.showMessageDialog(context,
            'Some error is just happened.\nMake sure that equipment is not in any Scenario!!');
      } else if (result == 1) {
        await Dialogs.showMessageDialog(context, 'Delete success');
        bloc.getAllEquipment();
      }
    }
  }

  updateEquipment(item) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EquipmentCreatePage(
                  id: item['id'],
                  name: item['name'],
                  quantity: item['quantity'],
                  status: item['status'] == 'available' ? 1 : 2,
                  description: item['description'],
                  image: item['image'],
                  isUpdate: true,
                ))).then((value) {
      if (value != null) {
        bloc.getAllEquipment();
      }
    });
  }

  editModelBottomShee(context, item) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
        ),
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: StatefulBuilder(
                builder: ((BuildContext context, StateSetter setModelState) {
                  var size = MediaQuery.of(context).size;
                  return Padding(
                    padding: EdgeInsets.all(5),
                    child: Container(
                        height: size.height * .6,
                        child: contentBottomSheet(
                            context, size, item, setModelState)),
                  );
                }),
              ),
            ),
          );
        });
  }

  Widget contentBottomSheet(
      context, Size size, item, StateSetter setModelState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              'Action',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.cancel, color: Colors.orange),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        Container(
          padding:
              EdgeInsets.only(left: size.width * .08, top: size.height * .02),
          margin: EdgeInsets.all(5),
          child: Row(
            children: <Widget>[
              Text(
                'Destiny      :',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                width: size.width * .1,
              ),
              Text(
                widget.nameDestiny,
                style: TextStyle(fontSize: 16),
              )
            ],
          ),
        ),
        Divider(
          height: 10,
          color: Colors.black,
        ),
        Container(
          padding:
              EdgeInsets.only(left: size.width * .08, top: size.height * .02),
          margin: EdgeInsets.all(5),
          child: Row(
            children: <Widget>[
              Text(
                'Equipment :',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                width: size.width * .1,
              ),
              Text(
                item['name'],
                style: TextStyle(fontSize: 16),
              )
            ],
          ),
        ),
        Divider(
          height: 15,
          color: Colors.black,
        ),
        Container(
          padding:
              EdgeInsets.only(left: size.width * .08, top: size.height * .02),
          margin: EdgeInsets.all(5),
          child: Row(
            children: <Widget>[
              Text(
                'Quantity     :',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                width: size.width * .1,
              ),
              Text(
                item['quantity'].toString(),
                style: TextStyle(fontSize: 16),
              )
            ],
          ),
        ),
        Divider(
          height: 15,
          color: Colors.black,
        ),
        Container(
          width: size.width * .4,
          height: size.height * .15,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  setModelState(() {
                    if (quantity == 0) {
                      return;
                    }
                    quantity -= 1;
                  });
                },
                child: Container(
                  child: Icon(
                    Icons.indeterminate_check_box,
                    color: Colors.orangeAccent,
                    size: 40,
                  ),
                ),
              ),
              Text(
                quantity.toString(),
                style: TextStyle(fontSize: 28),
              ),
              InkWell(
                onTap: () {
                  setModelState(() {
                    quantity += 1;
                  });
                },
                child: Container(
                  child: Icon(
                    Icons.add_box,
                    color: Colors.orangeAccent,
                    size: 40,
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 20),
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(colors: [
                Color(0xFFFDC830),
                Color(0xFFF37335),
              ])),
          child: SizedBox.expand(
              child: FlatButton(
            onPressed: () {
              addToCart(item);
            },
            child: Text(
              "Add To Cart",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
          )),
        )
      ],
    );
  }

  addToCart(item) {
    int result = shoppingBloc.addEquipment(widget.idDestiny, item['id'],
        quantity, item['name'], widget.nameDestiny, item['quantity']);
    if (result == 1) {
      Toast.show("Add Success", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else {
      Toast.show("Please add quantity lower", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }

    setState(() {
      quantity = 0;
    });
    Navigator.of(context).pop();
  }
}
