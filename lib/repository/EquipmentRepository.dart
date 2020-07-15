import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:project/utils/api_base.dart';

class EquipmentRepository {
  Future<List<dynamic>> getAllEquipment() async {
    List<dynamic> listData;
    http.Response response = await http.get(BASE_API + '/equipment');
    if (response.statusCode == 200) {
      print('Get all equipment sucess');
      // convert UTF-8
      String source = Utf8Decoder().convert(response.bodyBytes);
      listData = json.decode(source);
      return listData;
    } else {
      throw Exception('Exception in getAllEquipment');
    }
  }

  Future<int> updateEquipment(int id, String body) async {
    http.Response response = await http.put(BASE_API + '/equipment/$id',
        headers: {"Content-Type": "application/json"}, body: body);
    if (response.statusCode == 200) {
      print('Update equipment success');
      return 1;
    } else {
      throw Exception('Exception in updateEquipment');
    }
  }

  Future<int> deleteEquipment(int id) async {
    http.Response response = await http.delete(BASE_API + '/equipment/$id');
    if (response.statusCode == 200) {
      try {
        if (int.parse(response.body) < 0) {
          return -1;
        }
      } catch (e) {
        throw Exception('Exception in parse int in deleteEquipment()');
      }
      print('Delete Equipment success');
      return int.parse(response.body);
    } else {
      throw Exception('Exception in deleteEquipment()');
    }
  }

  insertEquipment(String body) async {
    http.Response response = await http.post(BASE_API + '/equipment',
        headers: {"Content-Type": "application/json"}, body: body);
    if (response.statusCode == 200) {
      try {
        if (int.parse(response.body) == -1) {
          return -1;
        }
      } catch (e) {
        throw Exception('Exception in parse int in insertEquipment()');
      }
      print('Insert equipment success');
      return int.parse(response.body);
    } else {
      throw Exception('Exception in insertEquipment');
    }
  }
}
