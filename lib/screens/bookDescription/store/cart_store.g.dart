// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CartStore on _CartStore, Store {
  late final _$cartListAtom =
      Atom(name: '_CartStore.cartList', context: context);

  @override
  List<CardModel> get cartList {
    _$cartListAtom.reportRead();
    return super.cartList;
  }

  @override
  set cartList(List<CardModel> value) {
    _$cartListAtom.reportWrite(value, super.cartList, () {
      super.cartList = value;
    });
  }

  late final _$totalAmountAtom =
      Atom(name: '_CartStore.totalAmount', context: context);

  @override
  double get totalAmount {
    _$totalAmountAtom.reportRead();
    return super.totalAmount;
  }

  @override
  set totalAmount(double value) {
    _$totalAmountAtom.reportWrite(value, super.totalAmount, () {
      super.totalAmount = value;
    });
  }

  late final _$isAddToCartAtom =
      Atom(name: '_CartStore.isAddToCart', context: context);

  @override
  bool get isAddToCart {
    _$isAddToCartAtom.reportRead();
    return super.isAddToCart;
  }

  @override
  set isAddToCart(bool value) {
    _$isAddToCartAtom.reportWrite(value, super.isAddToCart, () {
      super.isAddToCart = value;
    });
  }

  late final _$bookIdAtom = Atom(name: '_CartStore.bookId', context: context);

  @override
  String get bookId {
    _$bookIdAtom.reportRead();
    return super.bookId;
  }

  @override
  set bookId(String value) {
    _$bookIdAtom.reportWrite(value, super.bookId, () {
      super.bookId = value;
    });
  }

  late final _$initAsyncAction =
      AsyncAction('_CartStore.init', context: context);

  @override
  Future<void> init() {
    return _$initAsyncAction.run(() => super.init());
  }

  late final _$removeCartAsyncAction =
      AsyncAction('_CartStore.removeCart', context: context);

  @override
  Future<void> removeCart() {
    return _$removeCartAsyncAction.run(() => super.removeCart());
  }

  late final _$removeItemFromCartAsyncAction =
      AsyncAction('_CartStore.removeItemFromCart', context: context);

  @override
  Future<void> removeItemFromCart({required String bookId}) {
    return _$removeItemFromCartAsyncAction
        .run(() => super.removeItemFromCart(bookId: bookId));
  }

  late final _$addItemFromCartAsyncAction =
      AsyncAction('_CartStore.addItemFromCart', context: context);

  @override
  Future<void> addItemFromCart({required String bookId}) {
    return _$addItemFromCartAsyncAction
        .run(() => super.addItemFromCart(bookId: bookId));
  }

  late final _$_CartStoreActionController =
      ActionController(name: '_CartStore', context: context);

  @override
  double calculateTotal() {
    final _$actionInfo = _$_CartStoreActionController.startAction(
        name: '_CartStore.calculateTotal');
    try {
      return super.calculateTotal();
    } finally {
      _$_CartStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool isCartItemPreExist({required int bookId}) {
    final _$actionInfo = _$_CartStoreActionController.startAction(
        name: '_CartStore.isCartItemPreExist');
    try {
      return super.isCartItemPreExist(bookId: bookId);
    } finally {
      _$_CartStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
cartList: ${cartList},
totalAmount: ${totalAmount},
isAddToCart: ${isAddToCart},
bookId: ${bookId}
    ''';
  }
}
