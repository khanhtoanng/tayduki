import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:project/utils/api_base.dart';

class ImageRepository {
  Future<List<dynamic>> getAllImage(String type) async {
    List<dynamic> listData;
    http.Response response = await http.get(BASE_API + '/image/$type');
    if (response.statusCode == 200) {
      print('Get all image sucess');
      listData = json.decode(response.body);
      return listData;
    } else {
      throw Exception('Exception in getAllImage');
    }
  }

  insertImage(String body) async {
    http.Response response = await http.post(BASE_API + '/image',
        headers: {"Content-Type": "application/json"}, body: body);
    if (response.statusCode == 200) {
      try {
        if (int.parse(response.body) == -1) {
          return -1;
        }
      } catch (e) {
        throw Exception('Exception in parse int in insertImage()');
      }
      print('Insert image success');
      return int.parse(response.body);
    } else {
      throw Exception('Exception in insertImage');
    }
  }
}
