import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:project/model/EquipmentDestiny.dart';
import 'package:project/model/RoleActor.dart';
import 'package:project/repository/AccountRepository.dart';
import 'package:project/repository/DestinyRepository.dart';

class ShoppingCartBloc {
  DestinyRepository destinyRepository = DestinyRepository();
  AccountRepository accountRepository = AccountRepository();
  final listActorInDestinyController = StreamController.broadcast();
  final listEquipmentController = StreamController.broadcast();

  Stream get listActorInDestinyStream => listActorInDestinyController.stream;
  Stream get listEquipmentStream => listEquipmentController.stream;

  List<RoleActor> listActorToDestiny = new List();

  List<EquipmentDestiny> listEquipmentToDestitny = new List();

  // ShoppingCartBloc() {
  //   if (listActorToDestiny == null) {
  //     listActorToDestiny = new List();
  //   }
  //   if (listEquipmentToDestitny == null) {
  //     listEquipmentToDestitny = new List();
  //   }
  // }

  updateActor(
      int idDestiny, String username, String oldRole, String updateRole) {
    listActorToDestiny.forEach((item) {
      if (item.idDestiny == idDestiny &&
          item.username == username &&
          item.roleInDestiny == oldRole) {
        item.roleInDestiny = updateRole;
      }
    });
  }

  deleteActor(int idDestiny, String username, String role) {
    listActorToDestiny.removeWhere((item) =>
        item.idDestiny == idDestiny &&
        item.username == username &&
        item.roleInDestiny == role);
    print(listActorToDestiny);
  }

  addActor(int idDestiny, String username, String roleInDestiny,
      String fullname, String destinyName) {
    RoleActor roleActor = RoleActor(
        username: username,
        idDestiny: idDestiny,
        roleInDestiny: roleInDestiny,
        fullname: fullname,
        destinyName: destinyName);
    listActorToDestiny.add(roleActor);
  }

  int addEquipment(int idDestiny, int idEquipment, int equipmentQuantity,
      String equipmentName, String destinyName, int quantityInStore) {
    if (quantityInStore < equipmentQuantity) {
      return -1;
    }
    EquipmentDestiny item = listEquipmentToDestitny.firstWhere(
        (item) =>
            item.idDestiny == idDestiny && item.idEquipment == idEquipment,
        orElse: () => null);
    if (item == null) {
      EquipmentDestiny equipmentDestiny = EquipmentDestiny(
          idDestiny: idDestiny,
          idEquipment: idEquipment,
          equipmentQuantity: equipmentQuantity,
          equipName: equipmentName,
          destinyName: destinyName);
      listEquipmentToDestitny.add(equipmentDestiny);
      return 1;
    } else {
      int quan = item.equipmentQuantity + equipmentQuantity;
      if (quan < quantityInStore) {
        item.equipmentQuantity += equipmentQuantity;
        return 1;
      }
    }
    return -1;
  }

  updateEquipment(int idDestiny, int idEquipment, int newQuantity) {
    listEquipmentToDestitny.forEach((item) {
      if (item.idDestiny == idDestiny && item.idEquipment == idEquipment) {
        item.equipmentQuantity = newQuantity;
      }
    });
  }

  deleteEquipment(int idDestiny, int idEquipment) {
    listEquipmentToDestitny.removeWhere((item) =>
        item.idDestiny == idDestiny && item.idEquipment == idEquipment);
  }

  getListActor() {
    listActorInDestinyController.sink.add(listActorToDestiny);
  }

  getListEquipmentToDestitny() {
    listEquipmentController.sink.add(listEquipmentToDestitny);
  }

  Future<int> insertListActorToDestiny() async {
    var result = -1;
    if (listActorToDestiny.length != 0) {
      try {
        var data = json.encode(listActorToDestiny);
        result = await destinyRepository.insertListActorToDestiny(data);
        var list = await getTokens();
        accountRepository.sendMessage(
            'You got new role in destiny', 'New destiny', list);
        listActorToDestiny = new List();
        listActorInDestinyController.sink.add(listActorToDestiny);
      } catch (e) {
        print(e);
      }
    }
    return result;
  }

  Future<List<String>> getTokens() async {
    List<String> fcmTokens = new List();
    for (var item in listActorToDestiny) {
      String token = await accountRepository.getFcm(item.username);
      fcmTokens.add(token);
    }
    return fcmTokens;
  }

  Future<int> insertListEquipmentToDestiny() async {
    var result = -1;
    if (listEquipmentToDestitny.length != 0) {
      try {
        var data = json.encode(listEquipmentToDestitny);
        result = await destinyRepository.insertListEquipemtToDestiny(data);
        listEquipmentToDestitny = new List();
        listEquipmentController.sink.add(listEquipmentToDestitny);
      } catch (e) {
        print(e);
      }
    }
    return result;
  }

  void dispose() {
    listActorInDestinyController.close();
    listEquipmentController.close();
  }
}

ShoppingCartBloc shoppingBloc = ShoppingCartBloc();
