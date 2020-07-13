import 'package:flutter/material.dart';
import 'package:project/bloc/ImageBloc.dart';
import 'package:project/ui/appbar_widget.dart';

class ImageGalloryPage extends StatefulWidget {
  @override
  _ImageGalloryPageState createState() => _ImageGalloryPageState();
}

class _ImageGalloryPageState extends State<ImageGalloryPage> {
  ImageBloc bloc = ImageBloc();
  @override
  void initState() {
    super.initState();
    bloc.getAllPhoto();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarCustomize().setAppbar(context, 'Image Gallory', true),
        body: getListImage());
  }

  StreamBuilder getListImage() {
    return StreamBuilder(
      stream: bloc.listImageStream,
      builder: (context, snapshot) {
        if (snapshot.data == 'loading') {
          return Center(
              child: CircularProgressIndicator(
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(Color(0xffb744b8))));
        } else {
          return Container(
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              children: snapshot.data.map<Widget>((item) {
                print(item['image']);
                return InkWell(
                  onTap: () {
                    Navigator.pop(context, item['image']);
                  },
                  child: Image.network(
                    item['image'],
                    fit: BoxFit.fill,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                Color(0xffb744b8))),
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          );
        }
        return Text(
          snapshot.hasError ? snapshot.error : 'Loading..',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        );
      },
    );
  }
}
