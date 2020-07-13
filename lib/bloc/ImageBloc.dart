import 'dart:async';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:project/repository/ImageRepository.dart';

class ImageBloc {
  ImageRepository imageRepository = ImageRepository();
  StreamController listImageController = StreamController();

  Stream get listImageStream => listImageController.stream;
  // StorageReference photoRef = FirebaseStorage.instance.ref().child('photos');
  List<dynamic> listUrl;

  Future<void> getAllPhoto() async {
    listUrl = await imageRepository.getAllImage();

    listImageController.sink.add('loading');

    // for (var i = 1; i < 7; i++) {
    //   await photoRef.child('image-$i.jpg').getDownloadURL().then((value) {
    //     listUrl.add(value);
    //   }).catchError((error) {
    //     print(error);
    //   });
    // }
    if (listUrl.length != 0) {
      listImageController.sink.add(listUrl);
    } else {
      listImageController.sink.addError('Something went wrong!');
    }
  }

  void dispose() {
    listImageController.close();
  }
}
