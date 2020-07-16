import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../repository/AccountRepository.dart';

class AccountBloc {
  AccountRepository accountRepository = AccountRepository();

  StreamController usernameController = StreamController();
  StreamController passwordController = StreamController();
  StreamController listActorController = StreamController();
  StreamController accountController = StreamController();

  Stream get usernameStream => usernameController.stream;
  Stream get passwordStream => passwordController.stream;
  Stream get listActorStream => listActorController.stream;
  Stream get accountStream => accountController.stream;

  List<dynamic> listActor;

  // return Role
  Future<String> login(String username, String password, token) async {
    var role;

    if (username.length == 0) {
      usernameController.sink.addError('Username is required');
    } else {
      usernameController.sink.add('ok');
    }
    if (password.length == 0) {
      passwordController.sink.addError('Password is required');
    } else {
      passwordController.sink.add('ok');
    }
    if (username.length == 0 || password.length == 0) {
      return role;
    }

    // check login
    try {
      role = await accountRepository.login(username.trim(), password.trim());
      print(role + '     in bloc');
      await accountRepository.insertFcm(username, token);
      if (role.toString().length > 0) {
        usernameController.sink.add('ok');
        passwordController.sink.add('ok');
      } else {
        passwordController.sink.addError('Username or Password is not right!');
      }
    } catch (e) {
      print(e);
    }
    return role;
  }

  Future<void> getAllActor() async {
    try {
      listActorController.sink.add('loading');
      listActor = await accountRepository.getAllActor();
      // check if list is not empty
      if (listActor.length != 0) {
        listActorController.sink.add(listActor);
      } else {
        listActorController.sink.addError('There is not data!!');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getAccountDetail(String username) async {
    try {
      listActorController.sink.add('loading');
      final data = await accountRepository.getAccoutByUsername(username);
      // check if list is not empty
      if (data != null) {
        accountController.sink.add(data);
      } else {
        accountController.sink.addError('There is not data!!');
      }
    } catch (e) {
      print(e);
    }
  }

  filter(value) {
    List filterList = [];
    if (listActor.length != 0) {
      if (value.toString().length != 0) {
        filterList = listActor.where((item) {
          return item['fullname']
              .toLowerCase()
              .contains(value.trim().toLowerCase());
        }).toList();
        print(filterList);
        listActorController.sink.add(filterList);
      } else {
        listActorController.sink.add(listActor);
      }
    }
  }

  Future<int> deleteActor(String username) async {
    int result;
    if (username.length != 0) {
      try {
        result = await accountRepository.deleteActor(username);
      } catch (e) {
        print(e);
      }
    }
    return result;
  }

  insertActor(String username, String password, String phone, String email,
      String fullname, String image,
      {String descriptionAccount = ''}) async {
    int result;
    Map body = {
      'username': username.trim(),
      'password': password.trim(),
      'phone': phone.trim(),
      'email': email.trim(),
      'fullname': fullname.trim(),
      'descriptionAccount': descriptionAccount.trim(),
      'image': image.trim()
    };
    try {
      result = await accountRepository.insertActor(json.encode(body));
    } catch (e) {
      print(e);
    }
    return result;
  }

  updatetActor(String username, String password, String phone, String email,
      String fullname, String image, int gender,
      {String descriptionAccount = ''}) async {
    final prefs = await SharedPreferences.getInstance();
    String updateAccount = prefs.getString('username');
    int result;
    Map body = {
      'username': username.trim(),
      'password': password.trim(),
      'phone': phone.trim(),
      'email': email.trim(),
      'fullname': fullname.trim(),
      'descriptionAccount': descriptionAccount,
      'image': image,
      'gender': gender
    };
    try {
      result =
          await accountRepository.updateActor(updateAccount, json.encode(body));
    } catch (e) {
      result = -1;
    }

    return result;
  }

  void dispose() {
    usernameController.close();
    passwordController.close();
    listActorController.close();
    accountController.close();
  }
}
