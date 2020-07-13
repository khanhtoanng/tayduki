import 'package:flutter/material.dart';

enum DialogAction { yes, abort, ok }

class Dialogs {
  static Future<DialogAction> yesAbortDialog(BuildContext context, String title,
      {String content = ''}) async {
    final action = await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              RaisedButton(
                color: Colors.orangeAccent,
                textColor: Colors.white,
                onPressed: () => Navigator.of(context).pop(DialogAction.yes),
                child: Text(
                  'Yes',
                ),
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(DialogAction.abort),
                child: Text(
                  'No',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            ],
          );
        });
    return (action != null) ? action : DialogAction.abort;
  }

  static Future<void> showMessageDialog(BuildContext context, String title,
      {String content = ''}) async {
    await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              RaisedButton(
                color: Colors.orangeAccent,
                textColor: Colors.white,
                onPressed: () => Navigator.of(context).pop(DialogAction.ok),
                child: Text(
                  'Ok',
                ),
              ),
            ],
          );
        });
  }
}
