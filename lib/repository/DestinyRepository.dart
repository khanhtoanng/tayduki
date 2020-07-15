import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:project/utils/api_base.dart';

class DestinyRepository {
  Future<List<dynamic>> getAllDestiny() async {
    List<dynamic> listData;
    http.Response response = await http.get(BASE_API + '/destiny');
    if (response.statusCode == 200) {
      print('Get all destiny sucess');
      // convert UTF-8
      String source = Utf8Decoder().convert(response.bodyBytes);
      listData = json.decode(source);
      return listData;
    } else {
      throw Exception('Exception in getAllDestiny');
    }
  }

  Future<List<dynamic>> getDestinyById(int id) async {
    List<dynamic> listData;
    http.Response response = await http.get(BASE_API + '/destiny/$id');
    if (response.statusCode == 200) {
      print('Get  destiny sucess');
      String source = Utf8Decoder().convert(response.bodyBytes);
      listData = json.decode(source);
      return listData;
    } else {
      throw Exception('Exception in getDestinyById');
    }
  }

  Future<int> updateDestiny(int id, String body) async {
    http.Response response = await http.put(BASE_API + '/destiny/$id',
        headers: {"Content-Type": "application/json"}, body: body);
    if (response.statusCode == 200) {
      print('Update destiny success');
      return 1;
    } else {
      throw Exception('Exception in updateDestiny');
    }
  }

  Future<int> deleteDestiny(String id) async {
    http.Response response = await http.delete(BASE_API + '/destiny/$id');
    if (response.statusCode == 200) {
      try {
        if (int.parse(response.body) < 0) {
          return -1;
        }
      } catch (e) {
        throw Exception('Exception in parse int in deleteDestiny()');
      }
      print('Delete Destiny success');
      return int.parse(response.body);
    } else {
      throw Exception('Exception in deleteDestiny');
    }
  }

  insertDestiny(String body) async {
    http.Response response = await http.post(BASE_API + '/destiny',
        headers: {"Content-Type": "application/json"}, body: body);
    if (response.statusCode == 200) {
      try {
        if (int.parse(response.body) == -1) {
          return -1;
        }
      } catch (e) {
        throw Exception('Exception in parse int in insertDestiny()');
      }
      print('Insert destiny success');
      return int.parse(response.body);
    } else {
      throw Exception('Exception in insertDestiny');
    }
  }

  Future<int> insertListActorToDestiny(String body) async {
    print(body);
    http.Response response = await http.post(BASE_API + '/destiny/addListActor',
        headers: {"Content-Type": "application/json"}, body: body);
    if (response.statusCode == 200) {
      try {
        if (int.parse(response.body) == -1) {
          return -1;
        }
      } catch (e) {
        throw Exception('Exception in parse int in insertListActorToDestiny()');
      }
      print('Insert actor to destiny success');
      return int.parse(response.body);
    } else {
      throw Exception('Exception in insertListActorToDestiny');
    }
  }

  Future<int> insertListEquipemtToDestiny(String body) async {
    http.Response response = await http.post(
        BASE_API + '/destiny/addListEquiment',
        headers: {"Content-Type": "application/json"},
        body: body);
    if (response.statusCode == 200) {
      try {
        if (int.parse(response.body) < 0) {
          return -1;
        }
      } catch (e) {
        throw Exception(
            'Exception in parse int in insertListEquipemtToDestiny()');
      }
      print('Insert equipment to destiny success');
      return int.parse(response.body);
    } else {
      throw Exception('Exception in insertListEquipemtToDestiny');
    }
  }
}
