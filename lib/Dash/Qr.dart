import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:io' as io;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sample/models/personne.dart';
import 'package:open_file/open_file.dart' as open_file;


class PersonneQr extends StatefulWidget {
  String? personne;
var user;
  PersonneQr({@required this.personne, this.user});

  @override
  State<PersonneQr> createState() => _PersonneQrState();
}

class _PersonneQrState extends State<PersonneQr> {
  var storage = FirebaseStorage.instance;
  var globalKey =  GlobalKey();
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;

    return Scaffold(

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: RepaintBoundary(
              key: globalKey,

                child: Stack(
                  children: [

                    Image.asset("assets/images/bg.jpeg"),
                    Positioned(
                        top: 100,
                        left: w*0.35,
                        child: Text("${widget.user['nom']}", style: TextStyle(fontSize: 13),)),
                    Positioned(
                        top: 113,
                        left: w*0.35,
                        child: Text("${widget.user['postnom']}", style: TextStyle(fontSize: 13),)),
                    Positioned(
                        top: 127,
                        left: w*0.35,
                        child: Text("${widget.user['prenom']}", style: TextStyle(fontSize: 13),)),
                    Positioned(
                        top: 175,
                        left: w*0.159,
                        child: Text("${widget.user['sexe']}", style: TextStyle(fontSize: 13),)),
                    Positioned(
                      bottom: 5,
                      right: 18,
                      child: QrImage(
                        data: widget.personne!,
                        version: QrVersions.auto,
                        size: 80.0,
                      ),
                    ),
                  ],
                )
            ),
          ),
          MaterialButton(onPressed: (){
            _captureAndSharePng();
          }, child: Text("Imprimer"),)
        ],
      ),
    );
  }


  Future<void> _captureAndSharePng() async {
    try {
      String imageName = "qr${currentMillisecondsTimeStamp()}.png";
      var boundary = globalKey.currentContext!.findRenderObject();
      var image = await (boundary as RenderRepaintBoundary).toImage();
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await  File('${tempDir.path}/$imageName').create();
      await file.writeAsBytes(pngBytes);
      saveAndLaunchFile(pngBytes, "existe_${currentMillisecondsTimeStamp()}.png");
     //  await file.writeAsBytes(byteData.buffer
     //      .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
     //  io.Directory directory = io.Directory('/storage/emulated/0/Download');
     // var path = directory.path;
     //  await open_file.OpenFile.open('$path/$fileName');
     //  TaskSnapshot snapshot =
     //  await storage.ref().child("images/$imageName").putFile(file);
     //  print("Status ${snapshot.state}");
     //  final String downloadUrl = await snapshot.ref.getDownloadURL();
     //  print("Url $downloadUrl");
     //  print("Image $imageName");
    } catch (e) {
      print(e.toString());
    }
  }
}



Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
  //Get the storage folder location using path_provider package.
  String? path;
  if (Platform.isAndroid ||
      Platform.isIOS ||
      Platform.isLinux ||
      Platform.isWindows) {
    // final Directory directory =
    // await path_provider.getApplicationSupportDirectory();
    // path= Setting.document.path;
    // path = directory.path;
    io.Directory directory = io.Directory('/storage/emulated/0/Download');
    path = directory.path;
  } 
  final File file =
  File(Platform.isWindows ? '$path\\$fileName' : '$path/$fileName');
  await file.writeAsBytes(bytes, flush: true);
  if (Platform.isAndroid || Platform.isIOS) {
    //Launch the file (used open_file package)
    await open_file.OpenFile.open('$path/$fileName');
  } else if (Platform.isWindows) {
    await Process.run('start', <String>['$path\\$fileName'], runInShell: true);
  } else if (Platform.isMacOS) {
    await Process.run('open', <String>['$path/$fileName'], runInShell: true);
  } else if (Platform.isLinux) {
    await Process.run('xdg-open', <String>['$path/$fileName'],
        runInShell: true);
  }



}  


