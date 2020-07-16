import 'dart:async';
import 'dart:convert';
import 'package:project/repository/DestinyRepository.dart';

class DestinyBloc {
  DestinyRepository destinyRepository = DestinyRepository();

  StreamController listDestinyController = StreamController();
  StreamController destinyController = StreamController();

  Stream get listDestinyStream => listDestinyController.stream;
  Stream get destinyStream => destinyController.stream;

  List<dynamic> listDestiny;

  // get all destiny
  Future<void> getAllDestiny() async {
    try {
      listDestinyController.sink.add('loading');
      listDestiny = await destinyRepository.getAllDestiny();
      // check if list is not empty
      if (listDestiny.length != 0) {
        listDestinyController.sink.add(listDestiny);
      } else {
        listDestinyController.sink.addError('There is not data!!');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getDestinyById(int id) async {
    try {
      destinyController.sink.add('loading');
      var data = await destinyRepository.getDestinyById(id);
      // check if list is not empty
      if (data != null) {
        destinyController.sink.add(data);
      } else {
        destinyController.sink.addError('There is not data!!');
      }
    } catch (e) {
      print(e);
    }
  }

  // filter by name
  filter(value) {
    List filterList = [];
    if (listDestiny.length != 0) {
      if (value.toString().length != 0) {
        filterList = listDestiny.where((item) {
          return item['name']
              .toLowerCase()
              .contains(value.trim().toLowerCase());
        }).toList();
        print(filterList);
        listDestinyController.sink.add(filterList);
      } else {
        listDestinyController.sink.add(listDestiny);
      }
    }
  }

  Future<int> deleteDestiny(String id) async {
    int result;
    if (id.length != 0) {
      result = await destinyRepository.deleteDestiny(id);
    }
    return result;
  }

  insertDestiny(String name, String location, String description,
      String createTime, int isDone,
      {String detail, String endTime, String numberOfScreen}) async {
    int result;
    Map body = {
      'name': name.trim(),
      'location': location.trim(),
      'description': description.trim(),
      'createTime': createTime.trim(),
      'endTime': endTime,
      'numberOfScreen': numberOfScreen,
      'detail': detail,
      'isDone': isDone
    };
    result = await destinyRepository.insertDestiny(json.encode(body));
    return result;
  }

  updatetDestiny(int id, String name, String location, String description,
      String createTime, int isDone,
      {String detail, String endTime, String numberOfScreen}) async {
    int result;
    Map body = {
      'id': id,
      'name': name.trim(),
      'location': location.trim(),
      'description': description.trim(),
      'createTime': createTime.trim(),
      'endTime': endTime,
      'numberOfScreen': numberOfScreen,
      'detail': detail,
      'isDone': isDone
    };
    try {
      result = await destinyRepository.updateDestiny(id, json.encode(body));
    } catch (e) {
      result = -1;
    }

    return result;
  }

  void dispose() {
    listDestinyController.close();
    destinyController.close();
  }
}
