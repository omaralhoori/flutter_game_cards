import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/models/base_response_model.dart';
import 'package:bookkart_flutter/network/network_utils.dart';
import 'package:bookkart_flutter/screens/auth/model/customer_response_model.dart';
import 'package:bookkart_flutter/screens/auth/model/login_model.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

import 'model/register_response_model.dart';
import 'services/auth_services.dart';

Future<RegisterResponse> getRegisterUserRestApi(Map<String, dynamic> request) async {
  log('REGISTER-API');
  return RegisterResponse.fromJson(await responseHandler(await APICall().postMethod("iqonic-api/api/v1/woocommerce/customer/registration", request)));
}

Future<LoginResponse> getLoginUserRestApi(Map<String, dynamic> request) async {
  log('LOGIN-API');

  appStore.setLoading(true);
  return await responseHandler(await APICall().postMethod("erpnext.api.auth.login", request)).then((value) async {
    appStore.setLoading(false);
    if (value['message'] != null && value['message']['success_key'] == 1){
      LoginResponse loginResponse = LoginResponse.fromJson(value['message']);
    appStore.setUserProfile(loginResponse.profileImage.validate());
    await setUserInfo(loginResponse, isRemember: false, password: '', username: '');
    await appStore.setToken(loginResponse.token.validate());
    await appStore.setLoggedIn(true);
    await appStore.setUserId(loginResponse.userId.validate());
    await appStore.setTokenExpired(true);

    return loginResponse;
    }
    throw 'Login failed';
  }).catchError((e, s) {
    appStore.setLoading(false);
    debugPrint('ERROR - $e - STACK-TRACE - $s');
    throw e;
  });
}

Future<LoginResponse> socialLoginApi(Map request) async {
  log('SOCIAL-LOGIN-API');
  log("LOGIN JSON - $request");

  appStore.setLoading(true);
  return await responseHandler(await APICall().postMethod('iqonic-api/api/v1/customer/social_login', request)).then((value) {
    appStore.setLoading(false);
    return LoginResponse.fromJson(value);
  }).catchError((e, s) {
    appStore.setLoading(false);
    debugPrint('ERROR - $e - STACK-TRACE - $s');
    throw e;
  });
}

Future<BaseResponseModel> changePassword(Map<String, dynamic> request) async {
  log('CHANGE-PASSWORD-API');
  return BaseResponseModel.fromJson(await responseHandler(await APICall().postMethod('erpnext.api.auth.change_password', request,)));
}

Future<Customer> getCustomer(int? id) async {
  log('GET-CUSTOMER-API');
  return Customer.fromJson(await responseHandler(await APICall().getMethod('wc/v3/customers/$id')));
}

Future<BaseResponseModel> saveProfileImage(Map<String, dynamic> request) async {
  log('SAVE-PROFILE-IMAGE-API');
  return BaseResponseModel.fromJson(await responseHandler(await APICall().postMethod('iqonic-api/api/v1/customer/save-profile-image', request, requireToken: true)));
}

Future<Customer> updateCustomer(Map<String, dynamic> request) async {
  log('UPDATE-CUSTOMER-API');

  appStore.setLoading(true);
  return responseHandler(await APICall().postMethod('wc/v3/customers/${appStore.userId}', request)).then((value) {
    appStore.setLoading(false);

    Customer customer = Customer.fromJson(value);
    appStore.setUserProfile(customer.avatarUrl.validate());
    appStore.setFirstName(customer.firstName.validate());
    appStore.setLastName(customer.lastName.validate());

    customer.metaData.forEachIndexed(
      (customerData, index) {
        if (customerData.key == IQONIC_PROFILE_IMAGE) {
          if (customerData.value.validate().isEmpty) {
            appStore.setUserProfile(customer.avatarUrl.validate());
          } else {
            appStore.setUserProfile(customerData.value.validate());
          }
        }
      },
    );

    toast(locale.lblProfileSaved);
    return customer;
  }).catchError((e) {
    appStore.setLoading(false);
    throw e;
  });
}

Future<BaseResponseModel> forgetPassword({required Map<String, dynamic> request}) async {
  log("FORGOT-PASSWORD-API");
  appStore.setLoading(true);
  Response res = await APICall().postMethod('iqonic-api/api/v1/customer/forget-password', request).then((value) {
    appStore.setLoading(false);
    return value;
  }).catchError((e) {
    appStore.setLoading(false);
    throw e;
  });

  return responseHandler(res).then((value) {
    appStore.setLoading(false);
    BaseResponseModel baseResponse = BaseResponseModel.fromJson(value);
    toast(baseResponse.message.validate());
    return baseResponse;
  }).catchError((e) {
    appStore.setLoading(false);
    toast('forget password request failed');
    throw e;
  });
}

Future deleteAccount() async {
  log('DELETE-ACCOUNT-API');
  return responseHandler(await APICall().getMethod('iqonic-api/api/v1/customer/delete-account', requireToken: true));
}
