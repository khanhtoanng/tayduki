import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:project/bloc/DestinyBloc.dart';
import 'package:project/ui/appbar_widget.dart';
import 'package:project/utils/dialog_customize.dart';
import 'package:toast/toast.dart';

class DestinyCreatePage extends StatefulWidget {
  int id;
  DateTime createTime, endTime;
  String name, location, description, detail, numberOfScreen;
  bool isUpdate;
  DestinyCreatePage(
      {Key key,
      this.id,
      this.name,
      this.location,
      this.createTime,
      this.description,
      this.detail,
      this.endTime,
      this.numberOfScreen,
      this.isUpdate = false})
      : super(key: key);
  @override
  _DestinyCreatePageState createState() => _DestinyCreatePageState();
}

class _DestinyCreatePageState extends State<DestinyCreatePage> {
  final formKeyDestiny = GlobalKey<FormState>();
  DestinyBloc bloc = DestinyBloc();

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Scaffold(
          appBar: AppBarCustomize().setAppbar(context, 'Destiny Page', true),
          body: SingleChildScrollView(child: getBody(context))),
    );
  }

  Widget getBody(context) {
    var sizeW = MediaQuery.of(context).size.width;
    var sizeH = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.all(10),
      child: Form(
        key: formKeyDestiny,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                initialValue: widget.name,
                decoration: borderTextField('Name: '),
                validator: (input) =>
                    input.length < 3 ? 'Name is required' : null,
                onSaved: (input) => widget.name = input,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                initialValue: widget.location,
                decoration: borderTextField('Location: '),
                validator: (input) =>
                    input.length < 3 ? 'Location is required' : null,
                onSaved: (input) => widget.location = input,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                initialValue: widget.description,
                decoration: borderTextField('Description: '),
                validator: (input) =>
                    input.length < 3 ? 'Description is invalid' : null,
                onSaved: (input) => widget.description = input,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  datepickerStart(context),
                  Spacer(),
                  datepickerEnd(context),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                  initialValue: widget.numberOfScreen,
                  decoration: borderTextField('Number of shot: '),
                  validator: (input) =>
                      input.length <= 0 ? 'Number of shot is required' : null,
                  onSaved: (input) => widget.numberOfScreen = input,
                  keyboardType: TextInputType.number),
            ),
            SizedBox(
              height: sizeH * .1,
            ),
            // getImage(context, sizeH, sizeW),
            submitButton(context)
          ],
        ),
      ),
    );
  }

  Widget datepickerStart(context) {
    return InkWell(
      onTap: () async {
        await showDatePicker(
          context: context,
          initialDate:
              widget.createTime == null ? DateTime.now() : widget.createTime,
          firstDate: DateTime.now().subtract(Duration(days: 0)),
          lastDate: DateTime(2090),
        ).then((value) {
          if (value != null) {
            setState(() {
              widget.createTime = value;
            });
          }
        });
      },
      child: Container(
          padding: EdgeInsets.only(top: 15, bottom: 15, left: 30, right: 30),
          decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(10)),
          child: Text(
            widget.createTime == null
                ? 'Start date :'
                : widget.createTime.toString().split(' ')[0],
            style: TextStyle(fontSize: 15, color: Colors.black54),
          )),
    );
  }

  Widget datepickerEnd(context) {
    return InkWell(
      onTap: () async {
        await showDatePicker(
          context: context,
          initialDate: widget.endTime == null ? DateTime.now() : widget.endTime,
          firstDate: DateTime.now().subtract(Duration(days: 0)),
          lastDate: DateTime(2090),
        ).then((value) {
          if (value != null) {
            setState(() {
              widget.endTime = value;
            });
          }
        });
      },
      child: Container(
          padding: EdgeInsets.only(top: 15, bottom: 15, left: 30, right: 30),
          decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(10)),
          child: Text(
            widget.endTime == null
                ? 'End date :'
                : widget.endTime.toString().split(' ')[0],
            style: TextStyle(fontSize: 15, color: Colors.black54),
          )),
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

  int validDatePicker() {
    int result = -1;
    if (widget.createTime == null) {
      Toast.show("Add start date", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return result;
    } else if (widget.endTime == null) {
      Toast.show("Add end date", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return result;
    } else if (widget.createTime.compareTo(widget.endTime) >= 1) {
      Toast.show("Start must smaller than End", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return result;
    }
    return 1;
  }

  submit(context) {
    if (formKeyDestiny.currentState.validate()) {
      if (validDatePicker() == 1) {
        formKeyDestiny.currentState.save();
        if (widget.isUpdate) {
          updateDestiny(context);
        } else {
          insertDestiny(context);
        }
      }
    }
  }

  insertDestiny(context) async {
    int result = await bloc.insertDestiny(widget.name, widget.location,
        widget.description, widget.createTime.toString().split(' ')[0],
        detail: widget.detail,
        endTime: widget.endTime.toString().split(' ')[0],
        numberOfScreen: widget.numberOfScreen);
    if (result == -1) {
      await Dialogs.showMessageDialog(context, 'Some error is just happened!!');
    } else {
      await Dialogs.showMessageDialog(context, 'Insert success');
      Navigator.of(context).pop(true);
    }
  }

  updateDestiny(context) async {
    int result = await bloc.updatetDestiny(
        widget.id,
        widget.name,
        widget.location,
        widget.description,
        widget.createTime.toString().split(' ')[0],
        detail: widget.detail,
        endTime: widget.endTime.toString().split(' ')[0],
        numberOfScreen: widget.numberOfScreen);
    if (result == -1) {
      await Dialogs.showMessageDialog(context, 'Some error is just happened!!');
    } else {
      await Dialogs.showMessageDialog(context, 'Update success');
      Navigator.of(context).pop(true);
    }
  }
}
