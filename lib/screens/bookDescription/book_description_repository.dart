import 'dart:convert';

import 'package:bookkart_flutter/configs.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/models/base_response_model.dart';
import 'package:bookkart_flutter/network/network_utils.dart';
import 'package:bookkart_flutter/screens/bookDescription/model/all_book_list_response.dart';
import 'package:bookkart_flutter/screens/bookDescription/model/category_model.dart';
import 'package:bookkart_flutter/screens/bookDescription/model/invoice_list_model.dart';
import 'package:bookkart_flutter/screens/bookDescription/model/invoice_model.dart';
import 'package:bookkart_flutter/screens/bookDescription/model/my_cart_model.dart';
import 'package:bookkart_flutter/screens/bookDescription/model/paid_book_response.dart';
import 'package:bookkart_flutter/screens/dashboard/model/card_model.dart';
import 'package:bookkart_flutter/screens/dashboard/model/dashboard_book_info_model.dart';
import 'package:bookkart_flutter/screens/dashboard/model/subcategory_model.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

Future<dynamic> checkoutCartRequest(Map<String, dynamic> request) async {
  log('CHECKOUT');
  return await responseHandler(await APICall().postMethod('erpnext.api.data.checkout_cart', request, requireToken: true));
}
Future<dynamic> getCustomerBalance() async {
  return await responseHandler(await APICall().getMethod('erpnext.api.data.get_balance', requireToken: true));
}
Future<BaseResponseModel> addToCartBook(Map<String, dynamic> request) async {
  log('ADD-TO-CART-BOOK');
  return BaseResponseModel.fromJson(await responseHandler(await APICall().postMethod('iqonic-api/api/v1/cart/add-cart', request, requireToken: true)));
}

Future<PaidBookResponse> getPaidBookFileListRestApi(Map<String, dynamic> request) async {
  log('GET-PAID-BOOK-FILE-LIST-REST-API');
  if (appStore.isLoggedIn) {
    return PaidBookResponse.fromJson(await responseHandler(await APICall().postMethod("iqonic-api/api/v1/woocommerce/get-book-downloads", request, requireToken: true)));
  } else {
    return PaidBookResponse.fromJson(await responseHandler(await APICall().postMethod("iqonic-api/api/v1/woocommerce/get-book-downloads", request, requireToken: false)));
  }
}

Future<CardModel> getBookDetailsRestWithLoading(BuildContext context, {required Map<String, dynamic> request}) async {
  log('GET-BOOK-DETAILS-REST-API');

  appStore.setLoading(true);
  CardModel res = await getBookDescriptionData(context, request).then((value) {
    appStore.setLoading(false);
    return value;
  }).catchError((e) {
    appStore.setLoading(false);
    throw e;
  });

  return res;
}

//
// Future<BookDataModel> getBookDetailsRestApi({required Map<String, dynamic> request}) async {
//   log('GET-BOOK-DETAILS-REST-API');
//   Iterable it = await responseHandler(await APICall().postMethod("iqonic-api/api/v1/woocommerce/get-product-details", request, requireToken: appStore.isLoggedIn), req: request, isBookDetails: true);
//   BookDataModel res = BookDataModel.fromJson(it.first);
//
//   if (res.type == VARIABLE || res.type == GROUPED || res.type == EXTERNAL) {
//     toast(locale.lblBookTypeNotSupported);
//     finish(getContext);
//   }
//   return res;
// }

Future<CardModel> getBookDescriptionData(BuildContext context, Map<String, dynamic> request) async {
  //Iterable it = await responseHandler(await APICall().postMethod("iqonic-api/api/v1/woocommerce/get-product-details", request, requireToken: appStore.isLoggedIn), req: request, isBookDetails: true);
  // final String response = 
  //         await rootBundle.loadString('assets/data/product.json');
  // final resData = await json.decode(response);
  final response = await responseHandler(await APICall().postMethod("erpnext.api.data.get_item", request));

  CardModel res = CardModel.fromJson(response['message'].first);


  return res;
}

Future<List<MyCartResponse>> getCartBook() async {
  log('GET-CART-BOOK-API');
  Iterable it = await responseHandler(await APICall().getMethod('iqonic-api/api/v1/cart/get-cart', requireToken: true));

  return it.map((e) => MyCartResponse.fromJson(e)).toList();
}

Future<List<Reviews>> getProductReviews({required int id}) async {
  log('GET-PRODUCT-REVIEWS-API');
  Iterable reviewList = await responseHandler(await APICall().getMethod('wc/v1/products/$id/reviews'));
  return reviewList.map((model) => Reviews.fromJson(model)).toList();
}

Future<List<SubcategoryModel>> getSubCategories({Map<String, dynamic>? request}) async {
  log('GET-SUBCATEGORIES-API');
  // final String response = 
  //         await rootBundle.loadString('assets/data/sub_categories.json');
  // final resData = await json.decode(response);
  //await buildHttpResponse('wc/v3/products/categories?parent=$parent', method: HttpMethodType.GET)
  final response = await responseHandler(await APICall().postMethod("erpnext.api.data.get_subcategories", request));
  return (response['message'] as List).map((e) {
    return SubcategoryModel.fromJson(e);
  }).toList();
}

Future<Reviews> bookReviewRestApi(Map<String, dynamic> request) async {
  log('BOOK-REVIEW-REST-API');
  return Reviews.fromJson(await responseHandler(await APICall().postMethod("wc/v3/products/reviews", request, requireToken: true)));
}
/// same reviewer can't sent same review multiple time
Future<List<CardModel>> getAllBookRestApi({
  required bool isCategoryBook,
  Map<String, dynamic>? request,
  required requestType,
  required List<CardModel> services,
  required Function(dynamic p0) lastPageCallBack,
  required int page,
}) async {
  log('GET-ALL-BOOK-REST-API');
  // Map<String, dynamic> req = {};

  // Map<String, dynamic> requestCombination = {
  //   "newest": "newest",
  //   "you_may_like": "special_product",
  //   "suggested_for_you": "special_product",
  //   "product_visibility": "featured",
  // };

  // log(requestCombination[requestType]);
  // (isCategoryBook) ? req = request! : req = {requestCombination[requestType]: requestType, 'product_per_page': PER_PAGE_ITEM};
  //Map<String, dynamic> resData = await buildHttpResponse("iqonic-api/api/v1/woocommerce/get-product?parent=0&page=$page&per_page=$PER_PAGE_ITEM", request: req, method: HttpMethodType.POST);
  final response = await responseHandler(await APICall().postMethod("erpnext.api.data.get_items", request));
  // final String response = 
  //         await rootBundle.loadString('assets/data/all_books.json');
  // final resData = await json.decode(response);
  //AllBookListResponse res = AllBookListResponse.fromJson(resData);

  // if (page == 1) services.clear();
  // services.addAll(res.data.validate());
  // lastPageCallBack.call(res.data.validate().length != PER_PAGE_ITEM);
  for (var res in response['message']){
    CardModel card = CardModel.fromJson(res);
    await checkCurrency(card.currency);
    services.add(card);
  }
  return services;
}

Future checkCurrency(String? currency) async{
  String locale;
  if (currency ==null) return ;
  locale = getStringAsync(currency+"locale");
  if (locale == ''){
    final response =   await responseHandler(await APICall().getMethod("erpnext.api.data.get_currency_details?currency="+currency));
       Map res = response['message'];
    await setValue(currency+"locale", res['locale']);
    await setValue(currency+"symbol", res['symbol']);
    
}
}
Future<List<InvoiceListModel>> getAllInvoices( int page, {
  int perPage = PER_PAGE_ITEM,
  required List<InvoiceListModel> invoices,
  Function(bool)? lastPageCallBack,}) async {
  if (page == 1) invoices.clear();
  int start = (page - 1) * perPage;
  print("Start: $start, PerPage: $perPage");
  log('GET-ALL-INVOICES-REST-API');
  final response = await responseHandler(await APICall().getMethod("erpnext.api.data.get_invoices?start=$start&limit=$perPage"));
  //List<InvoiceListModel> invoices = [];
  for (var res in response['message']){
    invoices.add(InvoiceListModel.fromJson(res));  
  }

  lastPageCallBack?.call(response['message'].length != 5);

  return invoices;
}
Future<List<InvoiceModel>> getInvoiceDetails(String invoiceId) async {
  log('GET-ALL-INVOICES-REST-API');
  final response = await responseHandler(await APICall().getMethod("erpnext.api.data.get_invoice_details?invoice=$invoiceId"));
  List<InvoiceModel> invoices = [];
  for (var res in response['message']){

      for (var serial in res['serial_no'].split('\n')){
          invoices.add(InvoiceModel.fromJson(res, serial));
  
    }
    
  }
  return invoices;
}
