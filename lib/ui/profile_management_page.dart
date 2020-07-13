import 'package:flutter/material.dart';
import 'package:project/bloc/AccountBloc.dart';
import 'package:project/ui/admin/account/account_create_page.dart';
import 'package:project/ui/appbar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileManagementPage extends StatefulWidget {
  dynamic account;
  ProfileManagementPage({Key key, this.account});
  @override
  _ProfileManagementPageState createState() => _ProfileManagementPageState();
}

class _ProfileManagementPageState extends State<ProfileManagementPage> {
  AccountBloc bloc = AccountBloc();
  bool isShowPass = false;
  @override
  void initState() {
    getUsername().then((username) => bloc.getAccountDetail(username));
    super.initState();
  }

  Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username');
    return username;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBarCustomize().setAppbar(context, 'Profile Page', true),
        body: getBody());
  }

  Widget getBody() {
    return SingleChildScrollView(
      child: StreamBuilder(
        stream: bloc.accountStream,
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
              dynamic item = snapshot.data;
              return getDetail(context, item);
            }
          }
          return Text(
            snapshot.hasError ? snapshot.error : 'Loading..',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          );
        },
      ),
    );
  }

  Widget getDetail(context, item) {
    var size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        imageHeader(size, item),
        detailItem(size, item['username'], Icon(Icons.account_box)),
        divider(),
        detailItem(size, '**********', Icon(Icons.lock)),
        divider(),
        detailItem(size, item['fullname'], Icon(Icons.people)),
        divider(),
        detailItem(size, item['phone'], Icon(Icons.phone_android)),
        divider(),
        detailItem(size, item['email'], Icon(Icons.email)),
        divider(),
        detailItem(size, (item['gender'].toString() == '1') ? 'Male' : 'Female',
            Icon(Icons.wc)),
        submitButton(context, size, item)
      ],
    );
  }

  Widget submitButton(context, size, item) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.height * .1),
      height: size.height * .07,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(colors: [
            Color(0xFFFDC830),
            Color(0xFFF37335),
          ])),
      child: SizedBox.expand(
          child: FlatButton(
              onPressed: () {
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
                              gender: int.parse(item['gender']),
                              isUpdate: true,
                            ))).then((value) {
                  if (value != null) {
                    bloc.getAccountDetail(item['username']);
                  }
                });
              },
              child: Text(
                "Edit",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ))),
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

  Container detailItem(Size size, text, Icon icon) {
    return Container(
      padding: EdgeInsets.only(left: 50, top: 10),
      child: Row(
        children: <Widget>[
          icon,
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

  Container imageHeader(Size size, item) {
    return Container(
        height: size.height * .26,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Color(0xFFFDC830),
          Color(0xFFF37335),
        ])),
        child: Stack(children: [
          Positioned(
              top: size.height * .09,
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(45.0),
                        topRight: Radius.circular(45.0),
                      ),
                      color: Colors.white),
                  height: size.height - size.height * .1,
                  width: size.width)),
          Positioned(
            top: size.height * .01,
            left: size.width / 4,
            right: size.width / 4,
            // child: Hero(
            //     tag: widget.heroTag,
            //     child: Container(
            //         decoration: BoxDecoration(
            //             image: DecorationImage(
            //                 image: AssetImage(widget.heroTag),
            //                 fit: BoxFit.cover)),
            //         height: 200.0,
            //         width: 200.0))),
            child: CircleAvatar(
              radius: 80,
              backgroundColor: Colors.transparent,
              child: ClipOval(
                child: SizedBox(
                  width: size.width * .35,
                  height: size.height * .2,
                  child: Image.network(item['image'], fit: BoxFit.fill),
                ),
              ),
            ),
          ),
        ]));
  }
}
