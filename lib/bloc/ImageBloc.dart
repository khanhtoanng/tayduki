import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:project/repository/ImageRepository.dart';
import 'package:rxdart/rxdart.dart';

class ImageBloc {
  ImageRepository imageRepository = ImageRepository();
  StreamController listActorImageController = BehaviorSubject();
  StreamController listEquipmentImageController = BehaviorSubject();

  Stream get listActorImageStream => listActorImageController.stream;
  Stream get listEquipmentImageStream => listEquipmentImageController.stream;

  List<dynamic> listActor;
  List<dynamic> listEquipment;

  Future<void> getAllActorImage() async {
    try {
      listActorImageController.sink.add('loading');
      listActor = await imageRepository.getAllImage('actor');
      if (listActor.length != 0) {
        listActorImageController.sink.add(listActor);
      } else {
        listActorImageController.sink.addError('Something went wrong!');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getAllEquipmentImage() async {
    try {
      listEquipmentImageController.sink.add('loading');
      listEquipment = await imageRepository.getAllImage('equipment');
      if (listEquipment.length != 0) {
        listEquipmentImageController.sink.add(listEquipment);
      } else {
        listEquipmentImageController.sink.addError('Something went wrong!');
      }
    } catch (e) {
      print(e);
    }
  }

  insertImage(String image, String type) async {
    int result;
    Map body = {'type': type, 'image': image};
    try {
      result = await imageRepository.insertImage(json.encode(body));
    } catch (e) {
      print(e);
    }
    return result;
  }

  Future<int> upfiletoFB(File image) async {
    int result = -1;
    final StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('/photos/actor/${image.path.split('/').last}');
    StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      insertImage(fileURL, 'actor');
      result = 1;
    });
    return result;
  }

  void dispose() {
    listActorImageController.close();
    listEquipmentImageController.close();
  }
}
