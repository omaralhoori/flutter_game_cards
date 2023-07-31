// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'in_app_puchase.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$InAppPurchaseService on InAppPurchaseServiceBase, Store {
  late final _$isPurchasedAtom = Atom(name: 'InAppPurchaseServiceBase.isPurchased', context: context);

  @override
  bool get isPurchased {
    _$isPurchasedAtom.reportRead();
    return super.isPurchased;
  }

  @override
  set isPurchased(bool value) {
    _$isPurchasedAtom.reportWrite(value, super.isPurchased, () {
      super.isPurchased = value;
    });
  }

  late final _$listOfOfferAtom = Atom(name: 'InAppPurchaseServiceBase.listOfOffer', context: context);

  @override
  List<Package> get listOfOffer {
    _$listOfOfferAtom.reportRead();
    return super.listOfOffer;
  }

  @override
  set listOfOffer(List<Package> value) {
    _$listOfOfferAtom.reportWrite(value, super.listOfOffer, () {
      super.listOfOffer = value;
    });
  }

  late final _$retrieveUserDetailAsyncAction = AsyncAction('InAppPurchaseServiceBase.retrieveUserDetail', context: context);

  @override
  Future<bool> retrieveUserDetail() {
    return _$retrieveUserDetailAsyncAction.run(() => super.retrieveUserDetail());
  }

  late final _$getOfferingsUsingPurchaseIDAsyncAction = AsyncAction('InAppPurchaseServiceBase.getOfferingsUsingPurchaseID', context: context);

  @override
  Future<void> getOfferingsUsingPurchaseID(BuildContext context, {String purchaseID = 'pro'}) {
    return _$getOfferingsUsingPurchaseIDAsyncAction.run(() => super.getOfferingsUsingPurchaseID(context, purchaseID: purchaseID));
  }

  late final _$makePaymentAsyncAction = AsyncAction('InAppPurchaseServiceBase.makePayment', context: context);

  @override
  Future<void> makePayment(BuildContext context, Package packageToPurchase) {
    return _$makePaymentAsyncAction.run(() => super.makePayment(context, packageToPurchase));
  }

  late final _$disposeAsyncAction = AsyncAction('InAppPurchaseServiceBase.dispose', context: context);

  @override
  Future<void> dispose() {
    return _$disposeAsyncAction.run(() => super.dispose());
  }

  @override
  String toString() {
    return '''
isPurchased: ${isPurchased},
listOfOffer: ${listOfOffer}
    ''';
  }
}
