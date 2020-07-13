import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:project/utils/api_base.dart';

class AccountRepository {
  Future<String> login(String username, String password) async {
    http.Response response =
        await http.get(BASE_API + '/actor/login/$username?password=$password');
    if (response.statusCode == 200) {
      print('login success');
      return response.body;
    } else {
      throw Exception('Exception in login');
    }
  }

  Future<List<dynamic>> getAllActor() async {
    List<dynamic> listData;
    http.Response response = await http.get(BASE_API + '/actor');
    if (response.statusCode == 200) {
      print('Get all actor sucess');
      listData = json.decode(response.body);
      return listData;
    } else {
      throw Exception('Exception in getAllActor');
    }
  }

  Future<dynamic> getAccoutByUsername(String username) async {
    dynamic data;
    http.Response response = await http.get(BASE_API + '/actor/$username');
    if (response.statusCode == 200) {
      print('Get actor sucess');
      data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Exception in getAllActor');
    }
  }

  Future<int> updateActor(String updateAccount, String body) async {
    http.Response response = await http.put(BASE_API + '/actor/$updateAccount',
        headers: {"Content-Type": "application/json"}, body: body);
    if (response.statusCode == 200) {
      print(response.body);
      print('Update actor success');
      return int.parse(response.body);
    } else {
      throw Exception('Exception in updateActor');
    }
  }

  Future<int> deleteActor(String username) async {
    http.Response response = await http.delete(BASE_API + '/actor/$username');
    if (response.statusCode == 200) {
      try {
        if (int.parse(response.body) == -1) {
          return -1;
        }
      } catch (e) {
        throw Exception('Exception in parse int in deleteActor()');
      }
      print('Delete Actor success');
      return int.parse(response.body);
    } else {
      throw Exception('Exception in deleteActor');
    }
  }

  insertActor(String body) async {
    http.Response response = await http.post(BASE_API + '/actor',
        headers: {"Content-Type": "application/json"}, body: body);
    if (response.statusCode == 200) {
      try {
        if (int.parse(response.body) == -1) {
          return -1;
        }
      } catch (e) {
        throw Exception('Exception in parse int in insertActor()');
      }
      print('Insert actor success');
      return int.parse(response.body);
    } else {
      throw Exception('Exception in deleteActor');
    }
  }

  Future<List<dynamic>> getHistoryDestiny(String username) async {
    List<dynamic> listData;
    http.Response response =
        await http.get(BASE_API + '/actor/history/$username');
    if (response.statusCode == 200) {
      print('Get all history success');
      listData = json.decode(response.body);
      return listData;
    } else {
      throw Exception('Exception in getHistoryDestiny');
    }
  }

  Future<List<dynamic>> getIncomingDestiny(String username) async {
    List<dynamic> listData;
    http.Response response =
        await http.get(BASE_API + '/actor/incoming/$username');
    if (response.statusCode == 200) {
      print('Get all Incoming Destiny success');
      listData = json.decode(response.body);
      return listData;
    } else {
      throw Exception('Exception in getIncomingDestiny');
    }
  }
}
