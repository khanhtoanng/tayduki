import 'dart:async';
import '../repository/AccountRepository.dart';

class ActorBloc {
  AccountRepository accountRepository = AccountRepository();

  StreamController listHistoryDestinyController = StreamController();
  StreamController listIncomingDestinyController = StreamController();

  Stream get listHistoryStream => listHistoryDestinyController.stream;
  Stream get listIncomingStream => listIncomingDestinyController.stream;

  List<dynamic> listHistory;

  List<dynamic> listIncoming;

  Future<void> getHistoryDestiny(String username) async {
    try {
      listHistoryDestinyController.sink.add('loading');
      listHistory = await accountRepository.getHistoryDestiny(username);
      // check if list is not empty
      if (listHistory.length != 0) {
        listHistoryDestinyController.sink.add(listHistory);
      } else {
        listHistoryDestinyController.sink.addError('There is not data!!');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getAllIncomingDestiny(String username) async {
    try {
      listIncomingDestinyController.sink.add('loading');
      listIncoming = await accountRepository.getIncomingDestiny(username);
      // check if list is not empty
      if (listIncoming.length != 0) {
        listIncomingDestinyController.sink.add(listIncoming);
      } else {
        listIncomingDestinyController.sink.addError('There is not data!!');
      }
    } catch (e) {
      print(e);
    }
  }

  void dispose() {
    listHistoryDestinyController.close();
    listIncomingDestinyController.close();
  }
}
