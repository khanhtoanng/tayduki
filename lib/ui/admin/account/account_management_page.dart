import 'package:flutter/material.dart';
import 'package:project/bloc/AccountBloc.dart';
import 'package:project/ui/admin/account/account_create_page.dart';
import 'package:project/ui/appbar_widget.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:project/ui/show_cart_page.dart';
import 'package:project/utils/dialog_customize.dart';
import 'package:project/bloc/ShoppingCartBloc.dart';
import 'package:project/utils/filter_text.dart';
import 'package:toast/toast.dart';

class AccountManagementPage extends StatefulWidget {
  bool isShopping;
  int idDestiny;
  String nameDestiny;
  AccountManagementPage(
      {Key key, this.isShopping = false, this.idDestiny, this.nameDestiny})
      : super(key: key);
  @override
  _AccountManagementPageState createState() => _AccountManagementPageState();
}

class _AccountManagementPageState extends State<AccountManagementPage> {
  AccountBloc bloc = AccountBloc();
  final formKey = GlobalKey<FormState>();
  String role = '';
  int quantity = 0;

  @override
  void initState() {
    bloc.getAllActor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isShopping ? getPageWithShopping(context) : getPage(context);
  }

  Scaffold getPage(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarCustomize().setAppbar(context, 'Account Management', true),
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
                    builder: (context) => AccountCreatePage())).then((value) {
              if (value != null) {
                bloc.getAllActor();
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
      appBar: AppBarCustomize().setAppbar(context, 'Account Management', true),
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
                      width: size.width * .3,
                      height: size.height * .2,
                      child: Image.asset('assets/images/actorIcon.png',
                          fit: BoxFit.fill),
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
          height: size.height * .7,
          child: Column(
            children: <Widget>[
              getListActor(context),
            ],
          ),
        ),
      ],
    );
  }

  StreamBuilder getListActor(context) {
    return StreamBuilder(
      stream: bloc.listActorStream,
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
            List listActor = snapshot.data;
            return Expanded(
              child: ListView.builder(
                  itemCount: listActor.length,
                  itemBuilder: (context, index) {
                    return cardItem(listActor[index], context);
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
                  item['fullname'],
                  style: TextStyle(fontSize: 15),
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
                            'Username :',
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            item['username'],
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            'Email :',
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            item['email'],
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            'Phone :',
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            item['phone'],
                            style: TextStyle(fontSize: 12),
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
        secondaryActions: <Widget>[
          Container(
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
            child: IconSlideAction(
              color: Colors.transparent,
              caption: 'Edit',
              icon: Icons.edit,
              onTap: () {
                updateActor(item);
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
                deleteActor(item['username']);
              },
            ),
          ),
        ],
      ),
    );
  }

  deleteActor(username) async {
    final action =
        await Dialogs.yesAbortDialog(context, 'Do you want to Delete');
    if (action == DialogAction.yes) {
      int result = await bloc.deleteActor(username);
      if (result == -1) {
        await Dialogs.showMessageDialog(context,
            'Some error is just happened.\nMake sure that actor is not in any Scenario!!');
      } else if (result == 1) {
        await Dialogs.showMessageDialog(context, 'Delete success');
        bloc.getAllActor();
      }
    }
  }

  updateActor(item) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AccountCreatePage(
                  username: item['username'],
                  password: item['password'],
                  fullname: item['fullname'],
                  description: item['descriptionAccount'],
                  email: item['email'],
                  image: item['image'],
                  phone: item['phone'],
                  isUpdate: true,
                ))).then((value) {
      if (value != null) {
        bloc.getAllActor();
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
                        child: contentBottomSheet(context, size, item)),
                  );
                }),
              ),
            ),
          );
        });
  }

  Widget contentBottomSheet(context, Size size, item) {
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
                'Destiny :',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                width: size.width * .1,
              ),
              Text(
                widget.nameDestiny,
                style: TextStyle(fontSize: 20),
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
                'Actor    :',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                width: size.width * .1,
              ),
              Text(
                item['fullname'],
                style: TextStyle(fontSize: 20),
              )
            ],
          ),
        ),
        Divider(
          height: 15,
          color: Colors.black,
        ),
        SizedBox(
          height: size.height * .25,
          child: Container(
              padding: EdgeInsets.only(top: size.height * .05),
              width: size.width * .8,
              child: Form(
                key: formKey,
                child: TextFormField(
                  initialValue: role,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person_add),
                    hintText: "Role",
                    hintStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  validator: (input) =>
                      input.length <= 0 ? 'Role is required' : null,
                  onSaved: (input) => role = input,
                ),
              )),
        ),
        Container(
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

  Widget contentBottomSheet2(
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
                'Destiny :',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                width: size.width * .1,
              ),
              Text(
                widget.nameDestiny,
                style: TextStyle(fontSize: 20),
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
                'Destiny :',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                width: size.width * .1,
              ),
              Text(
                widget.nameDestiny,
                style: TextStyle(fontSize: 20),
              )
            ],
          ),
        ),
        Divider(
          height: 15,
          color: Colors.black,
        ),
        Container(
          height: size.height * .25,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Icon(
                  Icons.indeterminate_check_box,
                  color: Colors.orangeAccent,
                  size: 60,
                ),
                onPressed: () {
                  setModelState(() {
                    if (quantity == 0) {
                      return;
                    }
                    quantity -= 1;
                  });
                },
              ),
              Text(
                quantity.toString(),
                style: TextStyle(fontSize: 30),
              ),
              FlatButton(
                child: Icon(
                  Icons.add_box,
                  color: Colors.orangeAccent,
                  size: 60,
                ),
                onPressed: () {
                  setModelState(() {
                    quantity += 1;
                  });
                },
              )
            ],
          ),
        ),
        Container(
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
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      shoppingBloc.addActor(widget.idDestiny, item['username'], role,
          item['fullname'], widget.nameDestiny);
      Toast.show("Add Success", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      setState(() {
        role = '';
      });
      Navigator.of(context).pop();
    }
  }
}
