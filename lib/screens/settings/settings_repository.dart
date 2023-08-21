import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/network/network_utils.dart';

Future<bool> getShareRecommendationRestApi(Map<String, dynamic> request) async {

  appStore.setLoading(true);
  return await responseHandler(await APICall().postMethod("erpnext.api.data.share_recommendation", request)).then((value) async {
    appStore.setLoading(false);
    if (value['message'] != null && value['message']['success_key'] == 1){
    return true;
    }
    throw 'Login failed';
  }).catchError((e, s) {
    appStore.setLoading(false);
    throw e;
  });
}
