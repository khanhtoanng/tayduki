import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project/ui/appbar_widget.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';

class EquipmentAddingPage extends StatefulWidget {
  @override
  _EquipmentAddingPageState createState() => _EquipmentAddingPageState();
}

class _EquipmentAddingPageState extends State<EquipmentAddingPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBarCustomize().setAppbar(context, 'Equipment Adding Page', true),
      body: Container(
        child: RaisedButton(
          onPressed: () async {
            final status = await Permission.storage.request();

            if (status.isGranted) {
              final downloadsDirectory =
                  await DownloadsPathProvider.downloadsDirectory;
              print('aaaaaaaaaaa' + downloadsDirectory.path);
              await FlutterDownloader.enqueue(
                url:
                    "https://firebasestorage.googleapis.com/v0/b/projectswd-258f1.appspot.com/o/Fundamental%20Accounting%20Principles%2020th%20ed.%20-%20J.%20Wild%20et.%20al.%20(McGraw-Hill%202011).pdf?alt=media&token=279e257c-295b-45b1-8440-8306d874d291",
                savedDir: downloadsDirectory.path,
                fileName: "download",
                showNotification: true,
                openFileFromNotification: true,
              );
            } else {
              print("Permission deined");
            }
          },
          child: Text('A '),
        ),
      ),
    );
  }
}
