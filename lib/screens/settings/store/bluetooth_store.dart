import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/bookDescription/model/invoice_model.dart';
import 'package:bookkart_flutter/utils/utils.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import 'package:image/image.dart' as img;

part 'bluetooth_store.g.dart';

class BluetoothStore = _BluetoothStore with _$BluetoothStore;

abstract class _BluetoothStore with Store {
  @observable
  bool connected = false;

  @observable
  List<BluetoothInfo> items = [];

  @observable
  String msg = "";

  @observable
  String info = "";

  @observable
  String selectedPrintOption = "";

  @observable
  List<String> printOptionTypes = ["58 mm", "80 mm"];


  @action
  Future<void> init() async {
    if (!(await PrintBluetoothThermal.isPermissionBluetoothGranted))
    {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.bluetooth,
        Permission.nearbyWifiDevices,
        Permission.bluetoothConnect,
        Permission.bluetoothScan,
      ].request();
    }
    String mac = getSelectedBluetoothDevice();
    if (mac != ''){
      await connect(mac);
    }
    await getConnection();
    selectedPrintOption = getSelectedPrintOption();
  }

  String getSelectedBluetoothDevice() {
    return getStringAsync(SELECTED_BLUETOOTH_MAC, defaultValue: '');
  }

  String getSelectedPrintOption() {
    return getStringAsync(SELECTED_PRINT_OPTION, defaultValue: printOptionTypes[0]);
  }

  @action
  void setConnection(bool value) {
    connected = value;
  }

  @action getConnection() async{
    if (connected){
      return connected;
    }
    connected = await PrintBluetoothThermal.connectionStatus;
    return connected;
  }

  @action
  Future<void> connect(String mac) async {
    connected = false;
    final bool result = await PrintBluetoothThermal.connect(macPrinterAddress: mac);
    print("state conected $result");
    if (result) connected = true;
  }

  @action
  Future<void> disconnect() async {
    final bool status = await PrintBluetoothThermal.disconnect;
    connected = false;
    print("status disconnect $status");
  }

  @action
  void setMsg(String value){
    this.msg = value;
  }
  @action
  Future<void> changeSelectedPrintOption(String? value)async{
    if(value != null){
      selectedPrintOption = value;
      await setValue(SELECTED_PRINT_OPTION, value);
    }
  }
  @action
  void setInfo(String value){
    this.info = value;
  }

  @action
  Future<void> getBluetoothDevices() async {
   
    final List<BluetoothInfo> listResult = await PrintBluetoothThermal.pairedBluetooths;

    if (listResult.length == 0) {
      msg = "There are no bluetooths linked, go to settings and link the printer";
    } else {
      msg = "Touch an item in the list to connect";
    }

    items = listResult;

  }

  Future<void> saveBluetoothDevice(String mac) async {
    await setValue(SELECTED_BLUETOOTH_MAC, mac);
  }

  @action
  Future<void> initPlatformState() async {
    String platformVersion;
    int porcentbatery = 0;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await PrintBluetoothThermal.platformVersion;
      porcentbatery = await PrintBluetoothThermal.batteryLevel;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    connected = await PrintBluetoothThermal.connectionStatus;


    final bool result = await PrintBluetoothThermal.bluetoothEnabled;
    print("bluetooth enabled: $result");
    if (result) {
      msg = "Bluetooth enabled, please search and connect";
    } else {
      msg = "Bluetooth not enabled";
    }

    info = platformVersion + " ($porcentbatery% battery)";

  }

   Future<bool> printInvoices(List<InvoiceModel> invoices) async {
    appStore.setLoading(true);
    bool conexionStatus = await PrintBluetoothThermal.connectionStatus;
    if (conexionStatus) {
      List<int> ticket = await getBill(invoices);
      final result = await PrintBluetoothThermal.writeBytes(ticket);
      appStore.setLoading(false);
      return result;
    } else {
      appStore.setLoading(false);
      return false;
    }
  }


   Future<List<int>> getBill(List<InvoiceModel> invoices) async {
    List<int> bytes = [];
    // Using default profile
    final profile = await CapabilityProfile.load();
    final generator = Generator(selectedPrintOption == "58 mm" ? PaperSize.mm58 : PaperSize.mm80, profile);
    //bytes += generator.setGlobalFont(PosFontType.fontA);
    bytes += generator.reset();
    if(appStore.userProfileImage != ''){
      try{
 final Uint8List bytesImg = (await NetworkAssetBundle(Uri.parse(formatImageUrl(appStore.userProfileImage)))
    .load(formatImageUrl(appStore.userProfileImage))).buffer.asUint8List();
    img.Image? image = img.decodeImage(bytesImg);
  //   final ByteData data = await rootBundle.load('assets/images/logo.jpg');
  // final Uint8List imgBytes = data.buffer.asUint8List();
  // final img.Image? image = img.decodeImage(imgBytes)!;
     if(image !=null){
     bytes += generator.imageRaster(image);
     }
      }catch(e){

      }
     
   
    }
       

    bytes += generator.text('Order Number', styles: PosStyles(align: PosAlign.center), linesAfter: 1);
    bytes += generator.text(invoices[0].invoiceId, styles: PosStyles(align: PosAlign.center), linesAfter: 1);
    bytes += generator.text("${invoices[0].postingDate} ${invoices[0].postingTime}" , styles: PosStyles(
      align: PosAlign.center,), linesAfter: 1);
      bytes += generator.text("---------------------------", styles: PosStyles(align: PosAlign.center), linesAfter: 1);
    for (var invoice in invoices){
      bytes += generator.text(invoice.itemCode, styles: PosStyles(align: PosAlign.center), linesAfter: 1);
      bytes += generator.text(invoice.serialNo, styles: PosStyles(align: PosAlign.center), linesAfter: 1);
      bytes += generator.qrcode(invoice.serialNo,align: PosAlign.center);
      bytes += generator.text("---------------------------", styles: PosStyles(align: PosAlign.center), linesAfter: 1);
    }

    bytes += generator.feed(2);
    //bytes += generator.cut();
    return bytes;
  }

}