import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project/bloc/AccountBloc.dart';
import 'package:project/bloc/EquipmentBloc.dart';
import 'package:project/ui/appbar_widget.dart';
import 'package:project/ui/image_gallory_page.dart';
import 'package:project/utils/dialog_customize.dart';
import 'package:toast/toast.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class EquipmentCreatePage extends StatefulWidget {
  String name, description, image;
  int id, quantity, status;
  bool isUpdate;
  EquipmentCreatePage(
      {Key key,
      this.name,
      this.status,
      this.id,
      this.quantity,
      this.description,
      this.image,
      this.isUpdate = false})
      : super(key: key);
  @override
  _EquipmentCreatePageState createState() => _EquipmentCreatePageState();
}

class _EquipmentCreatePageState extends State<EquipmentCreatePage> {
  final formKey = GlobalKey<FormState>();
  EquipmentBloc bloc = EquipmentBloc();
  int group = 1;
  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Scaffold(
          appBar: AppBarCustomize().setAppbar(context, 'Equipment Page', true),
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
                initialValue: widget.name,
                decoration: borderTextField('Name: '),
                validator: (input) =>
                    input.length <= 0 ? 'Name is required' : null,
                onSaved: (input) => widget.name = input,
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
                initialValue:
                    widget.quantity == null ? '' : widget.quantity.toString(),
                decoration: borderTextField('Quantity: '),
                validator: (input) =>
                    (input.length == 0 ? true : int.parse(input) <= 0)
                        ? 'Quantity is required greatter than 0'
                        : null,
                onSaved: (input) => widget.quantity = int.parse(input),
                keyboardType: TextInputType.number,
              ),
            ),
            Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1, color: Colors.black45)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Available : ',
                      style: TextStyle(fontSize: 16, color: Colors.black45),
                    ),
                    Radio(
                      onChanged: (value) {
                        setState(() {
                          group = value;
                        });
                      },
                      groupValue: group,
                      value: 1,
                    ),
                    Text(
                      'Non-available : ',
                      style: TextStyle(fontSize: 16, color: Colors.black45),
                    ),
                    Radio(
                      onChanged: (value) {
                        setState(() {
                          group = value;
                        });
                      },
                      groupValue: group,
                      value: 2,
                    )
                  ],
                )),
            submitButton(context)
          ],
        ),
      ),
    );
  }

  InputDecoration borderTextField(String text) {
    return InputDecoration(
      labelText: text,
      labelStyle: TextStyle(fontSize: 16),
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
              Icons.image,
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
        updateEquipment(context);
      } else {
        insertEquipment(context);
      }
    }
  }

  insertEquipment(context) async {
    int result = await bloc.insertEquipment(widget.name, widget.description,
        widget.quantity, widget.image, widget.status);
    if (result == -1) {
      await Dialogs.showMessageDialog(context, 'Some error is just happened!!');
    } else {
      await Dialogs.showMessageDialog(context, 'Insert success');
      Navigator.of(context).pop(true);
    }
  }

  updateEquipment(context) async {
    print(widget.id);
    int result = await bloc.updatetEquipment(widget.id, widget.name,
        widget.description, widget.quantity, widget.image, widget.status);
    if (result == -1) {
      await Dialogs.showMessageDialog(context, 'Some error is just happened!!');
    } else {
      await Dialogs.showMessageDialog(context, 'Update success');
      Navigator.of(context).pop(true);
    }
  }
}
