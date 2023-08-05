import 'dart:async';

import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/auth/view/sign_in_screen.dart';
import 'package:bookkart_flutter/screens/bookDescription/book_description_repository.dart';
import 'package:bookkart_flutter/screens/bookDescription/model/my_cart_model.dart';
import 'package:bookkart_flutter/screens/dashboard/model/card_model.dart';
import 'package:bookkart_flutter/screens/transaction/transaction_repository.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';

part 'cart_store.g.dart';

class CartStore = _CartStore with _$CartStore;

abstract class _CartStore with Store {
  @observable
  List<CardModel> cartList = ObservableList();

  List<String> productId = ObservableList();

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
      await dbHelper.getCards().then((value){

        // if (value.validate().length != cartList.length) {
          cartList.clear();
          productId.clear();
          cartList.addAll(value);
          productId.addAll(cartList.map((e) => e.id.validate()));
        // }

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
    totalAmount = cartList.sumByDouble((p0) => p0.price.validate().toDouble() * p0.qty.validate().toDouble());
    return totalAmount;
  }

  @action
  bool isCartItemPreExist({required int bookId}) {
    return productId.any((element) => (element == bookId.toInt()));
  }

  @action
  Future<void> removeItemFromCart({required String bookId}) async {
    productId.removeWhere((element) => (element == bookId));
    print(productId);
    init();
  }

  Future<void> removeFromCart(context, {required String removeProductId}) async {
    appStore.setLoading(true);

    Map<String, String> request = {'pro_id': removeProductId.toString()};

    await dbHelper.removeCard(removeProductId).then((res) async {
      // cartStore.cartList.removeWhere((element) {
      //   return element.proId == removeProductId;
      // });
  
      removeItemFromCart(bookId: removeProductId);

      init();
      appStore.setLoading(false);
    }).catchError((onError) {
      init();
      appStore.setLoading(false);
      toast("Error removing cart");
    });
  }
  Future<void> removeAll(context, {required String removeProductId}) async {
    await dbHelper.removeAllCard(removeProductId);
     init();
  }

  @action
  Future<void> addItemFromCart({required String bookId}) async {
    productId.add(bookId);
  }

  Future<void> increaseCard(CardModel card) async{
    // productId.add(card.id);
    // card.qty += 1;
    await dbHelper.insertCard(card);
    init();
  }

  Future<void> addToCart(BuildContext context, {required String bookId, required CardModel card}) async {
    if (!appStore.isLoggedIn) SignInScreen().launch(context);


    appStore.setLoading(true);
    try{
      await dbHelper.insertCard(card);
      calculateTotal();
      addItemFromCart(bookId: bookId);
      appStore.setLoading(false);
    }catch(e){
      appStore.setLoading(false);
      calculateTotal();
    }
    // await addToCartBook(request).then((res) async {
    //   toast(res.message);

    //   calculateTotal();
    //   addItemFromCart(bookId: bookId.toInt());
    //   appStore.setLoading(false);
    // }).catchError((onError) {
    //   appStore.setLoading(false);
    //   calculateTotal();
    // }).whenComplete(() {
    //   init();
    // });
  }
}
