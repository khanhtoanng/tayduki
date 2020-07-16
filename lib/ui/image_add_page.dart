import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:project/bloc/ImageBloc.dart';
import 'package:project/ui/appbar_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';

class ImageAddPage extends StatefulWidget {
  @override
  _ImageAddPageState createState() => _ImageAddPageState();
}

class _ImageAddPageState extends State<ImageAddPage> {
  File image;
  int group = 1;
  ImageBloc bloc = ImageBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustomize().setAppbar(context, 'Image Action', true),
      body: Container(
        child: Column(
          children: <Widget>[
            Center(
              child: image == null ? Text('Select image') : enableUploadFile(),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        mini: true,
        backgroundColor: Colors.orangeAccent,
        onPressed: () {
          chooseFile();
        },
        child: Icon(Icons.image),
      ),
    );
  }

  Widget enableUploadFile() {
    return Column(
      children: <Widget>[
        Image.file(
          image,
          height: 300,
          width: 300,
        ),
        Text(
          'Actor : ',
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
          'Equipment : ',
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
        ),
        RaisedButton(
          child: Text('Upload'),
          onPressed: () async {
            String type = group == 1 ? 'actor' : 'equipment';
            int result = await bloc.upImagetoFB(image, type);
            if (result == -1) {
              Toast.show("Insert fail", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            } else {
              Toast.show("Success", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              setState(() {
                image = null;
              });
            }
          },
        )
      ],
    );
  }

  Future chooseFile() async {
    var temp = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = temp;
    });
  }
}
