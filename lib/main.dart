import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'dart:ui' as ui;
import "package:universal_html/html.dart" show AnchorElement;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Center(
      child: Container(
          child: Column(children: [
            SfSignaturePad(
              key: _signaturePadKey,
              backgroundColor: Colors.grey,
              strokeColor: Colors.white,
              minimumStrokeWidth: 2.0,
              maximumStrokeWidth: 4.0,
            ),
            // ElevatedButton(
            //     onPressed: () async {
            //       _signaturePadKey.currentState!.clear();
            //     },
            //     child: Text('Clear')),
            ElevatedButton(
                child: Text("Save As Image"),
                onPressed: () async {
                  ui.Image data = await _signaturePadKey.currentState!
                      .toImage(pixelRatio: 2.0);

                  final byteData =
                      await data.toByteData(format: ui.ImageByteFormat.png);
                  final Uint8List imageBytes = byteData!.buffer.asUint8List(
                      byteData.offsetInBytes, byteData.lengthInBytes);

                  if (kIsWeb) {
                    AnchorElement(
                        href:
                            'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(imageBytes)}')
                      ..setAttribute('download', 'Output.png')
                      ..click();
                  } else {
                    final String path =
                        (await getApplicationSupportDirectory()).path;
                    final String fileName = Platform.isWindows
                        ? '$path\\Output.png'
                        : '$path/Output.png';
                    final File file = File(fileName);
                    await file.writeAsBytes(imageBytes, flush: true);
                    OpenFile.open(fileName);
                  }
                }),
          ]),
          height: 400,
          width: 300),
    )));
  }
}
