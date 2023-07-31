import 'package:bookkart_flutter/network/network_utils.dart';
import 'package:bookkart_flutter/screens/bookmark/model/bookmark_response_model.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../models/base_response_model.dart';

Future<List<BookmarkResponse>> getBookmarkRestApi() async {
  log('GET-BOOKMARK-REST-API');
  Iterable res = await responseHandler(await APICall().getMethod("iqonic-api/api/v1/wishlist/get-wishlist", requireToken: true), isBookMarkBook: true);
  return res.map((e) => BookmarkResponse.fromJson(e)).toList();
}

Future<BaseResponseModel> removeFromBookmarkRestApi(request) async {
  log('REMOVE-FROM-BOOKMARK-REST-API');
  return BaseResponseModel.fromJson(await responseHandler(await APICall().postMethod('iqonic-api/api/v1/wishlist/delete-wishlist/', request, requireToken: true)));
}

Future<BaseResponseModel> addToBookmarkRestApi(request) async {
  log('ADD-TO-BOOKMARK-REST-API');
  return BaseResponseModel.fromJson(await responseHandler(await APICall().postMethod('iqonic-api/api/v1/wishlist/add-wishlist', request, requireToken: true)));
}
