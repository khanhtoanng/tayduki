import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:project/repository/EquipmentRepository.dart';

class EquipmentBloc {
  EquipmentRepository equipmentRepository = EquipmentRepository();

  StreamController listEquipmentController = StreamController();

  Stream get listEquipmentStream => listEquipmentController.stream;

  List<dynamic> listEquipment;

  // get all destiny
  Future<void> getAllEquipment() async {
    try {
      listEquipmentController.sink.add('loading');
      listEquipment = await equipmentRepository.getAllEquipment();
      // check if list is not empty
      if (listEquipment.length != 0) {
        listEquipmentController.sink.add(listEquipment);
      } else {
        listEquipmentController.sink.addError('There is not data!!');
      }
    } catch (e) {
      print(e);
    }
  }

  // filter by name
  filter(value) {
    List filterList = [];
    if (listEquipment.length != 0) {
      if (value.toString().length != 0) {
        filterList = listEquipment.where((item) {
          return item['name']
              .toLowerCase()
              .contains(value.trim().toLowerCase());
        }).toList();
        listEquipmentController.sink.add(filterList);
      } else {
        listEquipmentController.sink.add(listEquipment);
      }
    }
  }

  // filter by date
  filterByDate({start, end}) {
    try {
      List filterList = [];
      if (listEquipment.length != 0) {
        if (start == null && end == null) {
          listEquipmentController.sink.add(listEquipment);
        } else if (start != null && end != null) {
          filterList = listEquipment.where((item) {
            return (DateTime.parse(item['createTime']).compareTo(start) >= 0 &&
                DateTime.parse(item['createTime']).compareTo(end) <= 0);
          }).toList();
          listEquipmentController.sink.add(filterList);
        } else if (end == null) {
          filterList = listEquipment.where((item) {
            return DateTime.parse(item['createTime']).compareTo(start) >= 0;
          }).toList();
          listEquipmentController.sink.add(filterList);
        } else if (start == null) {
          filterList = listEquipment.where((item) {
            return DateTime.parse(item['createTime']).compareTo(end) <= 0;
          }).toList();
          listEquipmentController.sink.add(filterList);
        }
      } else {
        listEquipmentController.sink.add(listEquipment);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<int> deleteEquipment(int id) async {
    int result;
    if (id.toString().length != 0) {
      result = await equipmentRepository.deleteEquipment(id);
    }
    return result;
  }

  insertEquipment(String name, String description, int quantity, String image,
      int status) async {
    int result;
    Map body = {
      "name": name,
      "description": description,
      "quantity": quantity,
      "image": image,
      "status": status == 1 ? 'available' : 'non-available'
    };
    result = await equipmentRepository.insertEquipment(json.encode(body));
    return result;
  }

  updatetEquipment(int id, String name, String description, int quantity,
      String image, int status) async {
    int result;
    Map body = {
      "name": name,
      "description": description,
      "quantity": quantity,
      "image": image,
      "status": status == 1 ? 'available' : 'non-available'
    };
    try {
      result = await equipmentRepository.updateEquipment(id, json.encode(body));
    } catch (e) {
      result = -1;
    }

    return result;
  }

  void dispose() {
    listEquipmentController.close();
  }
}
