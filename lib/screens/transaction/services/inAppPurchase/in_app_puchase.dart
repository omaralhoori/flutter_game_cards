import 'dart:io';

import 'package:bookkart_flutter/configs.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/utils/common_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:purchases_flutter/purchases_flutter.dart' hide Store;

part 'in_app_purchase.g.dart';

class InAppPurchaseService = InAppPurchaseServiceBase with _$InAppPurchaseService;

abstract class InAppPurchaseServiceBase with Store {
  late final PurchasesConfiguration configuration;

  @observable
  bool isPaymentConfigured = false;

  @observable
  bool isPurchased = false;

  @observable
  List<Package> listOfOffer = [];

  InAppPurchaseServiceBase() {
    initializeInAppPurchase();
  }

  Future<void> initializeInAppPurchase({bool isBuildingForAmazonPlatForm = false}) async {
    if (!appStore.isLoggedIn || !appStore.isNetworkAvailable) return;

    if (revenueCatKey.isEmpty) {
      log("REVENUE CAT KEY IS EMPTY");
    }

    if (Platform.isAndroid) {
      if (publicGoogleApiKey.isEmpty) {
        log("PUBLIC GOOGLE API KEY IS EMPTY PLEASE CONFIGURE YOUR KEY AND THEN TRY");
        return;
      }

      configuration = PurchasesConfiguration(publicGoogleApiKey);
      isPaymentConfigured = true;
    }

    if (Platform.isIOS) {
      if (publicAppleApiKey.isEmpty) {
        log("PUBLIC APPLE API KEY IS EMPTY PLEASE CONFIGURE YOUR KEY AND THEN TRY");
        return;
      }

      configuration = PurchasesConfiguration(publicAppleApiKey);
      isPaymentConfigured = true;
    }

    if (isBuildingForAmazonPlatForm) {
      if (publicAmazonApiKey.isEmpty) {
        log("PUBLIC AMAZON API KEY IS EMPTY PLEASE CONFIGURE YOUR KEY AND THEN TRY");
        return;
      }

      configuration = AmazonConfiguration(publicAmazonApiKey);
      isPaymentConfigured = true;
    }

    // TODO : FOR DEVELOPER ONLY  => await Purchases.setLogLevel(LogLevel.verbose);

    await Purchases.configure(configuration);
    await retrieveUserDetail();
  }

  @action
  Future<bool> retrieveUserDetail() async {
    if (!appStore.isLoggedIn || !appStore.isNetworkAvailable) return isPurchased;

    if (!isPaymentConfigured) await initializeInAppPurchase();

    if (appStore.userEmail.validate().isEmpty) return isPurchased;

    return await Purchases.logIn(appStore.userEmail).then((value) {
      if (value.customerInfo.allPurchasedProductIdentifiers.validate().isNotEmpty) isPurchased = true;
      return isPurchased;
    }).catchError((e, s) {
      debugPrint('ERROR - $e - STACK-TRACE - $s');
      return isPurchased;
    });
  }

  @action
  Future<void> getOfferingsUsingPurchaseID(BuildContext context, {String purchaseID = 'pro'}) async {
    if (!appStore.isNetworkAvailable) {
      appStore.setLoading(false);
      toast("Internet Is Not Available");
      return;
    }

    if (appStore.userEmail.validate().isEmpty) {
      toast("Not Valid Email Found");
      return;
    }

    appStore.setLoading(true);
    if (await retrieveUserDetail()) {
      toast(locale.productIsAlreadyPurchased);
      appStore.setLoading(false);
      return;
    }

    await Purchases.getOfferings().then((Offerings offerings) async {
      if ((offerings.getOffering(purchaseID) == null) || (offerings.getOffering(purchaseID)?.availablePackages ?? []).isEmpty) return;
      listOfOffer = offerings.getOffering(purchaseID)?.availablePackages.validate() ?? listOfOffer;
      await showDialog(context: context, builder: (context) => PurchaseProduct().center());
    }).catchError((e, s) {
      appStore.setLoading(false);
      debugPrint('ERROR - $e - STACK-TRACE - $s');
      return;
    });
  }

  @action
  Future<void> makePayment(BuildContext context, Package packageToPurchase) async {
    if (await retrieveUserDetail()) {
      finish(context);
      return;
    }

    try {
      await Purchases.purchasePackage(packageToPurchase);
      toast(locale.purchasedDone);
      finish(context);
    } on PlatformException catch (e, s) {
      debugPrint('ERROR - $e - STACK-TRACE - $s');
      if (e.code == '20') {
        toast(locale.paymentIsPendingAndWillTakeUpToFiveDaysToProcess);
      } else if (e.code == '4') {
        toast(locale.unableToVerifyPurchase);
      } else {
        toast("${e.message}", print: true);
      }
    }

    await retrieveUserDetail();
  }

  @action
  Future<void> dispose() async {
    isPurchased = false;
    listOfOffer = [];

    await Purchases.logOut().catchError((e) {
      appStore.setLoading(false);
    });
  }
}
