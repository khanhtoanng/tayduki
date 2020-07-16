import 'package:flutter/material.dart';
import 'package:project/bloc/ActorBloc.dart';
import 'package:project/ui/appbar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';

class ActorHistoryPage extends StatefulWidget {
  @override
  _ActorHistoryPageState createState() => _ActorHistoryPageState();
}

class _ActorHistoryPageState extends State<ActorHistoryPage> {
  ActorBloc bloc = ActorBloc();
  @override
  void initState() {
    getUsername().then((username) => bloc.getHistoryDestiny(username));
    super.initState();
  }

  Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username');
    return username;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustomize().setAppbar(context, 'Actor History Page', true),
      body: Container(child: getListHistory(context)),
    );
  }

  StreamBuilder getListHistory(context) {
    return StreamBuilder(
      stream: bloc.listHistoryStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == 'loading') {
            return Container(
              margin: EdgeInsets.all(15),
              child: Center(
                  child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          Color(0xffb744b8)))),
            );
          } else {
            List list = snapshot.data;
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return cardItem(list[index], context);
              },
            );
          }
        }
        return Text(
          snapshot.hasError
              ? snapshot.error
              : 'Some thing went wrong! Please ry again',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        );
      },
    );
  }

  Widget cardItem(item, context) {
    var size = MediaQuery.of(context).size;
    return Card(
      color: Colors.transparent,
      margin: EdgeInsets.all(15),
      shadowColor: Colors.grey[100],
      elevation: 50,
      child: Container(
          alignment: Alignment.center,
          height: size.height * .17,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey, blurRadius: 10, offset: Offset(0, 5))
            ],
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(
                horizontal: size.width * .09, vertical: size.height * .01),
            title: Container(
              padding: EdgeInsets.only(left: size.width * .03),
              child: Text(
                item['name'],
                style: TextStyle(fontSize: 17),
              ),
            ),
            subtitle: Container(
                padding: EdgeInsets.only(
                    top: size.height * .01, left: size.width * .03),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          'Description :',
                          style: TextStyle(fontSize: 13),
                        ),
                        Text(
                          item['description'],
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          'Location :',
                          style: TextStyle(fontSize: 13),
                        ),
                        Text(
                          item['location'],
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          'Role :',
                          style: TextStyle(fontSize: 13, color: Colors.red),
                        ),
                        Text(
                          item['roleInDestiny'],
                          style: TextStyle(fontSize: 13, color: Colors.red),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          item['createTime'],
                          style: TextStyle(fontSize: 13),
                        ),
                        Icon(Icons.arrow_forward),
                        Text(
                          item['endTime'] == null
                              ? 'End date'
                              : item['endTime'],
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    )
                  ],
                )),
            trailing: InkWell(
              onTap: () {
                download(item['detail']);
              },
              child: Icon(
                Icons.file_download,
                size: 30,
              ),
            ),
          )),
    );
  }

  download(url) async {
    if (url != null) {
      final status = await Permission.storage.request();

      if (status.isGranted) {
        final downloadsDirectory =
            await DownloadsPathProvider.downloadsDirectory;
        await FlutterDownloader.enqueue(
          url: url,
          savedDir: downloadsDirectory.path,
          fileName: "download",
          showNotification: true,
          openFileFromNotification: true,
        );
        Toast.show("Download file ...", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        print("Permission deined");
      }
    } else {
      Toast.show("No file for download ", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }
}
