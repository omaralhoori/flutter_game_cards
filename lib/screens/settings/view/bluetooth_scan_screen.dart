import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/bookDescription/model/invoice_model.dart';
import 'package:bookkart_flutter/utils/colors.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
import 'package:image/image.dart' as img;

class BluetoothScanScreen extends StatefulWidget {
  const BluetoothScanScreen({super.key});

  @override
  State<BluetoothScanScreen> createState() => _BluetoothScanScreenState();
}

class _BluetoothScanScreenState extends State<BluetoothScanScreen> {
  List<String> _options = ["permission bluetooth granted", "bluetooth enabled", "connection status", "update info"];

  String _selectSize = "2";
  final _txtText = TextEditingController(text: "Hello developer");
  bool _progress = false;
  String _msjprogress = "";


  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('Connect Bluetooth Printer', style: primaryTextStyle(size: 20),),
            actions: [
              PopupMenuButton(
                elevation: 3.2,
                //initialValue: _options[1],
                onCanceled: () {
                  print('You have not chossed anything');
                },
                tooltip: 'Menu',
                onSelected: (Object select) async {
                  String sel = select as String;
                  if (sel == "permission bluetooth granted") {
                    bool status = await PrintBluetoothThermal.isPermissionBluetoothGranted;
                    setState(() {
                     bluetoothStore.setInfo( "permission bluetooth granted: $status");
                    });
                    //open setting permision if not granted permision
                  } else if (sel == "bluetooth enabled") {
                    bool state = await PrintBluetoothThermal.bluetoothEnabled;
                    setState(() {
                     bluetoothStore.setInfo( "Bluetooth enabled: $state");
                    });
                  } else if (sel == "update info") {
                    initPlatformState();
                  } else if (sel == "connection status") {
                    final bool result = await PrintBluetoothThermal.connectionStatus;
                    setState(() {
                      bluetoothStore.setInfo( "connection status: $result");
                    });
                  }
                },
                itemBuilder: (BuildContext context) {
                  return _options.map((String option) {
                    return PopupMenuItem(
                      value: option,
                      child: Text(option),
                    );
                  }).toList();
                },
              )
            ],
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('info: ${bluetoothStore.info}\n '),
                  Text(bluetoothStore.msg),
                  Row(
                    children: [
                      Text("Type print"),
                      SizedBox(width: 10),
                      DropdownButton<String>(
                        value: bluetoothStore.selectedPrintOption,
                        items: bluetoothStore.printOptionTypes.map((String option) {
                          return DropdownMenuItem<String>(
                            value: option,
                            child: Text(option),
                          );
                        }).toList(),
                        onChanged: (String? newValue)async {
                          await bluetoothStore.changeSelectedPrintOption(newValue);
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => primaryColor)),
                        onPressed: () {
                          this.getBluetoots();
                        },
                        child: Row(
                          children: [
                            Visibility(
                              visible: _progress,
                              child: SizedBox(
                                width: 25,
                                height: 25,
                                child: CircularProgressIndicator.adaptive(strokeWidth: 1, backgroundColor: Colors.white),
                              ),
                            ),
                            SizedBox(width: 5),
                            Text(_progress ? _msjprogress : "Search"),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: bluetoothStore.connected ? this.disconnect : null,
                        child: Text("Disconnect"),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => primaryColor)),
                        onPressed: bluetoothStore.connected ? this.testPrinter : null,
                        child: Text("Print Test"),
                      ),
                    ],
                  ),
                  Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.grey.withOpacity(0.3),
                      ),
                      child: ListView.builder(
                        itemCount: bluetoothStore.items.length > 0 ? bluetoothStore.items.length : 0,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              String mac = bluetoothStore.items[index].macAdress;
                              this.connect(mac);
                            },
                            title: Text('Name: ${bluetoothStore.items[index].name}'),
                            subtitle: Text("macAddress: ${bluetoothStore.items[index].macAdress}"),
                          );
                        },
                      )),
                 
                ],
              ),
            ),
          ),
        
      ),
    );
  }

  Future<void> initPlatformState() async {
    await bluetoothStore.initPlatformState();
  }

  Future<void> getBluetoots() async {
    setState(() {
      _progress = true;
      _msjprogress = "Wait";
    });
    await bluetoothStore.getBluetoothDevices();
    setState(() {
      _progress = false;
    });

  }

  Future<void> connect(String mac) async {
    setState(() {
      _progress = true;
      _msjprogress = "Connecting...";
    });
    await bluetoothStore.connect(mac);
    await bluetoothStore.saveBluetoothDevice(mac);
    setState(() {
      _progress = false;
    });
  }

  Future<void> disconnect() async {
    await bluetoothStore.disconnect();
  }

  Future<void> testPrinter() async {
    List<InvoiceModel> invoices = [];
    invoices.add(InvoiceModel(
        invoiceId: "ACC-SINV-2023-00030",
        grandTotal: 12,
        image: "",
        itemCode: "PSN-10USD",
        itemRate: 12,
        postingDate: "2023-08-19",
        postingTime: "11:02:37",
        qty: 1,
        serialNo: "12cc-66qq"
    ));
    await bluetoothStore.printInvoices(invoices);
  }

  // Future<void> printTest() async {
  //   bool conexionStatus = await PrintBluetoothThermal.connectionStatus;
  //   //print("connection status: $conexionStatus");
  //   if (conexionStatus) {
  //     List<int> ticket = await testTicket();
  //     final result = await PrintBluetoothThermal.writeBytes(ticket);
  //     print("print test result:  $result");
  //   } else {
  //     //no conectado, reconecte
  //   }
  // }

  // Future<void> printString() async {
  //   bool conexionStatus = await PrintBluetoothThermal.connectionStatus;
  //   if (conexionStatus) {
  //     String enter = '\n';
  //     await PrintBluetoothThermal.writeBytes(enter.codeUnits);
  //     //size of 1-5
  //     String text = "Hello";
  //     await PrintBluetoothThermal.writeString(printText: PrintTextSize(size: 1, text: text));
  //     await PrintBluetoothThermal.writeString(printText: PrintTextSize(size: 2, text: text + " size 2"));
  //     await PrintBluetoothThermal.writeString(printText: PrintTextSize(size: 3, text: text + " size 3"));
  //   } else {
  //     //desconectado
  //     print("desconectado bluetooth $conexionStatus");
  //   }
  // }

  // Future<List<int>> testTicket() async {
  //   List<int> bytes = [];
  //   // Using default profile
  //   final profile = await CapabilityProfile.load();
  //   final generator = Generator(optionprinttype == "58 mm" ? PaperSize.mm58 : PaperSize.mm80, profile);
  //   //bytes += generator.setGlobalFont(PosFontType.fontA);
  //   bytes += generator.reset();

  //   final ByteData data = await rootBundle.load('assets/mylogo.jpg');
  //   final Uint8List bytesImg = data.buffer.asUint8List();
  //   img.Image? image = img.decodeImage(bytesImg);

  //   if (Platform.isIOS) {
  //     // Resizes the image to half its original size and reduces the quality to 80%
  //     final resizedImage = img.copyResize(image!, width: image.width ~/ 1.3, height: image.height ~/ 1.3, interpolation: img.Interpolation.nearest);
  //     final bytesimg = Uint8List.fromList(img.encodeJpg(resizedImage));
  //     //image = img.decodeImage(bytesimg);
  //   }

  //   //Using `ESC *`
  //   bytes += generator.image(image!);

  //   bytes += generator.text('Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
  //   bytes += generator.text('Special 1: ñÑ àÀ èÈ éÉ üÜ çÇ ôÔ', styles: PosStyles(codeTable: 'CP1252'));
  //   bytes += generator.text('Special 2: blåbærgrød', styles: PosStyles(codeTable: 'CP1252'));

  //   bytes += generator.text('Bold text', styles: PosStyles(bold: true));
  //   bytes += generator.text('Reverse text', styles: PosStyles(reverse: true));
  //   bytes += generator.text('Underlined text', styles: PosStyles(underline: true), linesAfter: 1);
  //   bytes += generator.text('Align left', styles: PosStyles(align: PosAlign.left));
  //   bytes += generator.text('Align center', styles: PosStyles(align: PosAlign.center));
  //   bytes += generator.text('Align right', styles: PosStyles(align: PosAlign.right), linesAfter: 1);

  //   bytes += generator.row([
  //     PosColumn(
  //       text: 'col3',
  //       width: 3,
  //       styles: PosStyles(align: PosAlign.center, underline: true),
  //     ),
  //     PosColumn(
  //       text: 'col6',
  //       width: 6,
  //       styles: PosStyles(align: PosAlign.center, underline: true),
  //     ),
  //     PosColumn(
  //       text: 'col3',
  //       width: 3,
  //       styles: PosStyles(align: PosAlign.center, underline: true),
  //     ),
  //   ]);

  //   //barcode

  //   final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
  //   bytes += generator.barcode(Barcode.upcA(barData));

  //   //QR code
  //   bytes += generator.qrcode('example.com');

  //   bytes += generator.text(
  //     'Text size 50%',
  //     styles: PosStyles(
  //       fontType: PosFontType.fontB,
  //     ),
  //   );
  //   bytes += generator.text(
  //     'Text size 100%',
  //     styles: PosStyles(
  //       fontType: PosFontType.fontA,
  //     ),
  //   );
  //   bytes += generator.text(
  //     'Text size 200%',
  //     styles: PosStyles(
  //       height: PosTextSize.size2,
  //       width: PosTextSize.size2,
  //     ),
  //   );

  //   bytes += generator.feed(2);
  //   //bytes += generator.cut();
  //   return bytes;
  // }

  // Future<void> printWithoutPackage() async {
  //   //impresion sin paquete solo de PrintBluetoothTermal
  //   bool connectionStatus = await PrintBluetoothThermal.connectionStatus;
  //   if (connectionStatus) {
  //     String text = _txtText.text.toString() + "\n";
  //     bool result = await PrintBluetoothThermal.writeString(printText: PrintTextSize(size: int.parse(_selectSize), text: text));
  //     print("status print result: $result");
  //       bluetoothStore.setMsg("printed status: $result");
  //   } else {
  //     //no conectado, reconecte
  
  //       bluetoothStore.setMsg("no connected device");
  //     print("no conectado");
  //   }
  // }
}