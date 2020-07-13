import 'dart:async';
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
        print(filterList);
        listEquipmentController.sink.add(filterList);
      } else {
        listEquipmentController.sink.add(listEquipment);
      }
    }
  }

  Future<int> deleteEquipment(String id) async {
    int result;
    if (id.length != 0) {
      result = await equipmentRepository.deleteEquipment(id);
    }
    return result;
  }

  // insertActor(String username, String password, String phone, String email,
  //     String fullname,
  //     {String descriptionAccount = ''}) async {
  //   int result;
  //   Map body = {
  //     'username': username.trim(),
  //     'password': password.trim(),
  //     'phone': phone.trim(),
  //     'email': email.trim(),
  //     'fullname': fullname.trim(),
  //     'descriptionAccount': descriptionAccount.trim()
  //   };
  //   result = await equipmentRepository.insertActor(json.encode(body));
  //   return result;
  // }

  void dispose() {
    listEquipmentController.close();
  }
}
