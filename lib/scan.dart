import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:Roomap/main.dart';
import 'package:Roomap/roomDetails.dart';
import 'package:Roomap/roomPaths.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MaterialApp(home: QRViewExample()));

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  getCurrentRoom(room_details) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var url =
        Uri.parse(baseUrl + '/functions/customer/rooms/getCurrentRoom.php');
    var response = await http.post(url, body: {"room_details": room_details});
    final details = json.decode(response.body);
    setState(() {
      if (details['id'].isEmpty ||
          details['room_name'].isEmpty ||
          details['building_id'].isEmpty) {
        print('Could not determine room');
        print(details);
      } else {
        preferences.setString('room_id', details['id']);
        preferences.setString('room_name', details['room_name']);
        preferences.setString('building_id', details['building_id']);

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RoomDetails()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(flex: 4, child: _buildQrView(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Color.fromARGB(255, 0, 149, 255),
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        var room_details = result!.code.toString();
        EasyDebounce.debounce(
            'my-debouncer', // <-- An ID for this particular debouncer
            Duration(milliseconds: 1000), // <-- The debounce duration
            () => getCurrentRoom(room_details) // <-- The target method
            );
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
