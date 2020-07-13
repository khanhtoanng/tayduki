import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project/bloc/AccountBloc.dart';
import 'package:project/ui/appbar_widget.dart';
import 'package:project/ui/image_gallory_page.dart';
import 'package:project/utils/dialog_customize.dart';
import 'package:toast/toast.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class EquipmentCreatePage extends StatefulWidget {
  String username, password, email, fullname, phone, description, image;
  bool isUpdate;
  EquipmentCreatePage(
      {Key key,
      this.username,
      this.password,
      this.email,
      this.fullname,
      this.phone,
      this.description,
      this.image,
      this.isUpdate = false})
      : super(key: key);
  @override
  _EquipmentCreatePageState createState() => _EquipmentCreatePageState();
}

class _EquipmentCreatePageState extends State<EquipmentCreatePage> {
  final formKey = GlobalKey<FormState>();
  AccountBloc bloc = AccountBloc();
  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Scaffold(
          appBar: AppBarCustomize().setAppbar(context, 'Actor Page', true),
          body: SingleChildScrollView(child: getBody(context))),
    );
  }

  Widget getBody(context) {
    var sizeW = MediaQuery.of(context).size.width;
    var sizeH = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.all(10),
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            getImage(context, sizeH, sizeW),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                readOnly: widget.isUpdate,
                initialValue: widget.username,
                decoration: borderTextField('Username: '),
                validator: (input) => input.length < 3
                    ? 'Username is required more than 3 words'
                    : null,
                onSaved: (input) => widget.username = input,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                initialValue: widget.password,
                decoration: borderTextField('Password: '),
                validator: (input) => input.length < 3
                    ? 'Password is required more than 3 words'
                    : null,
                onSaved: (input) => widget.password = input,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                initialValue: widget.email,
                decoration: borderTextField('Email: '),
                validator: (input) =>
                    !input.contains('@') ? 'Email is invalid' : null,
                onSaved: (input) => widget.email = input,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                initialValue: widget.fullname,
                decoration: borderTextField('Full name: '),
                validator: (input) =>
                    input.length <= 0 ? 'Full Name is required' : null,
                onSaved: (input) => widget.fullname = input,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                initialValue: widget.description,
                decoration: borderTextField('Description: '),
                validator: (input) =>
                    input.length <= 0 ? 'Description is required' : null,
                onSaved: (input) => widget.description = input,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                initialValue: widget.phone,
                decoration: borderTextField('Phone: '),
                validator: (input) =>
                    input.length < 10 ? 'Phone is required 11 numbers' : null,
                onSaved: (input) => widget.phone = input,
                inputFormatters: [LengthLimitingTextInputFormatter(11)],
                keyboardType: TextInputType.phone,
              ),
            ),
            submitButton(context)
          ],
        ),
      ),
    );
  }

  InputDecoration borderTextField(String text) {
    return InputDecoration(
      labelText: text,
      labelStyle: TextStyle(fontSize: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: Colors.grey),
      ),
    );
  }

  Container getImage(context, double sizeH, double sizeW) {
    return Container(
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () async {
              var result = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ImageGalloryPage()));
              if (result != null) {
                setState(() {
                  widget.image = result;
                });
              }
            },
            child: loadImage(sizeH, sizeW),
          ),
        ],
      ),
    );
  }

  Container loadImage(double sizeH, double sizeW) {
    return widget.image == null || widget.image.length == 0
        ? Container(
            margin: EdgeInsets.only(bottom: sizeH * .04),
            height: sizeW * .4,
            width: sizeH * .35,
            color: Colors.black12,
            child: Icon(
              Icons.add,
              size: sizeW * .15,
            ),
          )
        : Container(
            margin: EdgeInsets.only(bottom: sizeH * .04),
            height: sizeW * .4,
            width: sizeH * .35,
            color: Colors.black12,
            child: Image.network(
              widget.image,
              fit: BoxFit.cover,
            ));
  }

  Widget submitButton(context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30),
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
          submit(context);
        },
        child: actionButton(),
      )),
    );
  }

  Text actionButton() {
    return widget.isUpdate
        ? Text(
            "Update",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
          )
        : Text(
            "Insert",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
          );
  }

  submit(context) {
    if (formKey.currentState.validate()) {
      if (widget.image == null) {
        Toast.show("Add Image!!", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

        return;
      }
      formKey.currentState.save();
      if (widget.isUpdate) {
        updateActor(context);
      } else {
        insertActor(context);
      }
    }
  }

  insertActor(context) async {
    int result = await bloc.insertActor(widget.username, widget.password,
        widget.phone, widget.email, widget.fullname, widget.image);
    if (result == -1) {
      await Dialogs.showMessageDialog(context,
          'Some error is just happened!!. Make sure your username is not duplicated');
    } else {
      await Dialogs.showMessageDialog(context, 'Insert success');
      Navigator.of(context).pop(true);
    }
  }

  updateActor(context) async {
    //   int result = await bloc.updatetActor(widget.username, widget.password,
    //       widget.phone, widget.email, widget.fullname, widget.image,
    //       descriptionAccount: widget.description);
    //   if (result == -1) {
    //     await Dialogs.showMessageDialog(context, 'Some error is just happened!!');
    //   } else {
    //     await Dialogs.showMessageDialog(context, 'Update success');
    //     Navigator.of(context).pop(true);
    //   }
  }
}
