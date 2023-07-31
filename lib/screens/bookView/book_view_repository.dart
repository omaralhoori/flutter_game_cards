import 'package:bookkart_flutter/models/base_response_model.dart';
import 'package:bookkart_flutter/network/network_utils.dart';
import 'package:nb_utils/nb_utils.dart';

Future<BaseResponseModel> updateOrderRestApi(request, orderId) async {
  log('UPDATE-ORDER-REST-API');
  return BaseResponseModel.fromJson(await responseHandler(await APICall().postMethod("wc/v3/orders/$orderId", request, requireToken: true)));
}
