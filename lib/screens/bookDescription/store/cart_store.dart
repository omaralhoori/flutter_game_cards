import 'dart:async';

import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/auth/view/sign_in_screen.dart';
import 'package:bookkart_flutter/screens/bookDescription/book_description_repository.dart';
import 'package:bookkart_flutter/screens/bookDescription/model/my_cart_model.dart';
import 'package:bookkart_flutter/screens/transaction/transaction_repository.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';

part 'cart_store.g.dart';

class CartStore = _CartStore with _$CartStore;

abstract class _CartStore with Store {
  @observable
  List<MyCartResponse> cartList = ObservableList();

  List<int> productId = ObservableList();

  @observable
  double totalAmount = 0;

  @observable
  bool isAddToCart = false;

  @observable
  String bookId = '';

  @action
  Future<void> init() async {
    if (appStore.isLoggedIn) {
      appStore.setLoading(true);

      await getCartBook().then((value) {
        if (value.validate().length != cartList.length) {
          cartList.clear();
          productId.clear();
          cartList.addAll(value);
          productId.addAll(cartList.map((e) => e.proId.validate()));
        }

        appStore.setLoading(false);
      }).catchError((e) {
        appStore.setLoading(false);
      });

      calculateTotal();
    }
  }

  @action
  Future<void> removeCart() async {
    appStore.setLoading(true);

    clearCart().then((response) {
      cartList.clear();
      productId.clear();
      totalAmount = 0;
      appStore.setLoading(false);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  @action
  double calculateTotal() {
    totalAmount = cartList.sumByDouble((p0) => p0.price.validate().toDouble());
    return totalAmount;
  }

  @action
  bool isCartItemPreExist({required int bookId}) {
    return productId.any((element) => (element == bookId.toInt()));
  }

  @action
  Future<void> removeItemFromCart({required int bookId}) async {
    productId.removeWhere((element) => (element == bookId.toInt()));
    init();
  }

  Future<void> removeFromCart(context, {required int removeProductId}) async {
    appStore.setLoading(true);

    Map<String, String> request = {'pro_id': removeProductId.toString()};

    await deleteFromCart(request).then((res) async {
      cartStore.cartList.removeWhere((element) {
        return element.proId == removeProductId;
      });

      removeItemFromCart(bookId: removeProductId);

      init();
      appStore.setLoading(false);
    }).catchError((onError) {
      init();
      appStore.setLoading(false);
      toast("Error removing cart");
    });
  }

  @action
  Future<void> addItemFromCart({required int bookId}) async {
    productId.add(bookId);
  }

  Future<void> addToCart(BuildContext context, {required String bookId}) async {
    if (!appStore.isLoggedIn) SignInScreen().launch(context);

    Map<String, String> request = {'pro_id': bookId, "quantity": "1"};

    appStore.setLoading(true);
    await addToCartBook(request).then((res) async {
      toast(res.message);

      calculateTotal();
      addItemFromCart(bookId: bookId.toInt());
      appStore.setLoading(false);
    }).catchError((onError) {
      appStore.setLoading(false);
      calculateTotal();
    }).whenComplete(() {
      init();
    });
  }
}
