// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bluetooth_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BluetoothStore on _BluetoothStore, Store {
  late final _$connectedAtom =
      Atom(name: '_BluetoothStore.connected', context: context);

  @override
  bool get connected {
    _$connectedAtom.reportRead();
    return super.connected;
  }

  @override
  set connected(bool value) {
    _$connectedAtom.reportWrite(value, super.connected, () {
      super.connected = value;
    });
  }

  late final _$itemsAtom =
      Atom(name: '_BluetoothStore.items', context: context);

  @override
  List<BluetoothInfo> get items {
    _$itemsAtom.reportRead();
    return super.items;
  }

  @override
  set items(List<BluetoothInfo> value) {
    _$itemsAtom.reportWrite(value, super.items, () {
      super.items = value;
    });
  }

  late final _$msgAtom = Atom(name: '_BluetoothStore.msg', context: context);

  @override
  String get msg {
    _$msgAtom.reportRead();
    return super.msg;
  }

  @override
  set msg(String value) {
    _$msgAtom.reportWrite(value, super.msg, () {
      super.msg = value;
    });
  }

  late final _$infoAtom = Atom(name: '_BluetoothStore.info', context: context);

  @override
  String get info {
    _$infoAtom.reportRead();
    return super.info;
  }

  @override
  set info(String value) {
    _$infoAtom.reportWrite(value, super.info, () {
      super.info = value;
    });
  }

  late final _$selectedPrintOptionAtom =
      Atom(name: '_BluetoothStore.selectedPrintOption', context: context);

  @override
  String get selectedPrintOption {
    _$selectedPrintOptionAtom.reportRead();
    return super.selectedPrintOption;
  }

  @override
  set selectedPrintOption(String value) {
    _$selectedPrintOptionAtom.reportWrite(value, super.selectedPrintOption, () {
      super.selectedPrintOption = value;
    });
  }

  late final _$printOptionTypesAtom =
      Atom(name: '_BluetoothStore.printOptionTypes', context: context);

  @override
  List<String> get printOptionTypes {
    _$printOptionTypesAtom.reportRead();
    return super.printOptionTypes;
  }

  @override
  set printOptionTypes(List<String> value) {
    _$printOptionTypesAtom.reportWrite(value, super.printOptionTypes, () {
      super.printOptionTypes = value;
    });
  }

  late final _$initAsyncAction =
      AsyncAction('_BluetoothStore.init', context: context);

  @override
  Future<void> init() {
    return _$initAsyncAction.run(() => super.init());
  }

  late final _$getConnectionAsyncAction =
      AsyncAction('_BluetoothStore.getConnection', context: context);

  @override
  Future getConnection() {
    return _$getConnectionAsyncAction.run(() => super.getConnection());
  }

  late final _$connectAsyncAction =
      AsyncAction('_BluetoothStore.connect', context: context);

  @override
  Future<void> connect(String mac) {
    return _$connectAsyncAction.run(() => super.connect(mac));
  }

  late final _$disconnectAsyncAction =
      AsyncAction('_BluetoothStore.disconnect', context: context);

  @override
  Future<void> disconnect() {
    return _$disconnectAsyncAction.run(() => super.disconnect());
  }

  late final _$changeSelectedPrintOptionAsyncAction = AsyncAction(
      '_BluetoothStore.changeSelectedPrintOption',
      context: context);

  @override
  Future<void> changeSelectedPrintOption(String? value) {
    return _$changeSelectedPrintOptionAsyncAction
        .run(() => super.changeSelectedPrintOption(value));
  }

  late final _$getBluetoothDevicesAsyncAction =
      AsyncAction('_BluetoothStore.getBluetoothDevices', context: context);

  @override
  Future<void> getBluetoothDevices() {
    return _$getBluetoothDevicesAsyncAction
        .run(() => super.getBluetoothDevices());
  }

  late final _$initPlatformStateAsyncAction =
      AsyncAction('_BluetoothStore.initPlatformState', context: context);

  @override
  Future<void> initPlatformState() {
    return _$initPlatformStateAsyncAction.run(() => super.initPlatformState());
  }

  late final _$_BluetoothStoreActionController =
      ActionController(name: '_BluetoothStore', context: context);

  @override
  void setConnection(bool value) {
    final _$actionInfo = _$_BluetoothStoreActionController.startAction(
        name: '_BluetoothStore.setConnection');
    try {
      return super.setConnection(value);
    } finally {
      _$_BluetoothStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMsg(String value) {
    final _$actionInfo = _$_BluetoothStoreActionController.startAction(
        name: '_BluetoothStore.setMsg');
    try {
      return super.setMsg(value);
    } finally {
      _$_BluetoothStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setInfo(String value) {
    final _$actionInfo = _$_BluetoothStoreActionController.startAction(
        name: '_BluetoothStore.setInfo');
    try {
      return super.setInfo(value);
    } finally {
      _$_BluetoothStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
connected: ${connected},
items: ${items},
msg: ${msg},
info: ${info},
selectedPrintOption: ${selectedPrintOption},
printOptionTypes: ${printOptionTypes}
    ''';
  }
}
