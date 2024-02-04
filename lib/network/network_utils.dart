import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:bookkart_flutter/configs.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/auth/auth_repository.dart';
import 'package:bookkart_flutter/screens/auth/view/sign_in_screen.dart';
import 'package:bookkart_flutter/screens/bookDescription/book_description_repository.dart';
import 'package:bookkart_flutter/screens/bookDescription/view/book_description_screen.dart';
import 'package:bookkart_flutter/screens/bookmark/bookmark_repository.dart';
import 'package:bookkart_flutter/screens/dashboard/view/dashboard_screen.dart';
import 'package:bookkart_flutter/utils/utils.dart';
import 'package:bookkart_flutter/utils/widgets/queryString.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

Future<bool> checkConnectivity() async {
  ConnectivityResult connectivityResult = await (Connectivity().checkConnectivity());

  try {
    return (connectivityResult != ConnectivityResult.none);
  } catch (e) {
    throw "Error while checking internet connection \n\n" + e.toString();
  }
}

class APICall {
  bool? isHttps;

  APICall() {
    (BASE_URL.startsWith("https")) ? this.isHttps = true : this.isHttps = false;
  }

  Future<Response> getMethod(String endpoint, {requireToken = false}) async {
    if (!appStore.isNetworkAvailable) {
      return Response("", 500);
    }

    String url = this.getOAuthURL("GET", endpoint);
    log("URL $url");

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      HttpHeaders.cacheControlHeader: 'no-cache',
      'Authorization':'token ${appStore.token}'
    };

    if (requireToken) {
      // TODO: WITH NO AUTHORIZE HEADER

      // headers.putIfAbsent('Authorization', () => 'token ${appStore.token}');
      // headers.putIfAbsent('token', () => appStore.token);
      // headers.putIfAbsent('id', () => appStore.userId.toString());

      // TODO: WITH AUTHORIZE HEADER

      // headers.putIfAbsent(HttpHeaders.authorizationHeader, () => "Bearer ${appStore.token}");
      // headers.putIfAbsent('id', () => appStore.userId.toString());
    }

    headers.addAll(headers);

    final response = await get(Uri.parse(url), headers: headers);

    log('TOKEN: ${headers['token']}\n');
    log('UID: ${headers['id']}\n');
    apiPrint(url: url.toString(), endPoint: endpoint, headers: jsonEncode(headers), request: '', statusCode: response.statusCode, responseBody: response.body, methodtype: "GET");

    return response;
  }

  Future<Response> postMethod(String endPoint, Map? data, {requireToken = false}) async {
    log('REQUEST : $data');

    String url = this.getOAuthURL("POST", endPoint);
    log("URL $url");

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8', 
      HttpHeaders.cacheControlHeader: 'no-cache',
       'Authorization':'token ${appStore.token}'
      };

    if (requireToken) {
      // TODO : WITH AUTHORIZE REQUEST

      // Map<String, String> header = {HttpHeaders.authorizationHeader: "Bearer ${appStore.token}", "id": "${appStore.userId}"};

      // TODO: WITH NO AUTHORIZE HEADER
      Map<String, String> header = {"token": "${appStore.token}", "id": "${appStore.userId}"};

      headers.addAll(header);
    }

    Client client = Client();

    Response response = await client.post(Uri.parse(url), body: jsonEncode(data), headers: headers);

    log('TOKEN: ${headers['token']}\n');
    log('UID: ${headers['id']}\n');

    apiPrint(url: url.toString(), endPoint: jsonEncode(data), headers: jsonEncode(headers), request: '', statusCode: response.statusCode, responseBody: response.body, methodtype: "POST");

    return response;
  }

  String getOAuthURL(String requestMethod, String endpoint) {
    String token = "";
    String tokenSecret = "";
    String url = BASE_URL + endpoint;

    bool containsQueryParams = url.contains("?");

    String finalParameter = getFinalParameter(containsQueryParams);

    if (this.isHttps == true) {
      return url + finalParameter;
    } else {
      Random rand = Random();
      int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      List<int> codeUnits = List.generate(10, (index) => rand.nextInt(26) + 97);

      String httpMethod = requestMethod;
      String nonce = String.fromCharCodes(codeUnits);
      String parameters = "oauth_consumer_key=" + CONSUMER_KEY + "&oauth_nonce=" + nonce + "&oauth_signature_method=HMAC-SHA1&oauth_timestamp=" + timestamp.toString() + "&oauth_token=" + token + "&oauth_version=1.0&";

      (containsQueryParams == true) ? parameters = parameters + url.split("?")[1] : parameters = parameterStringForRequestUrl(parameters);

      Map<dynamic, dynamic> treeMap = treeMapForKeyAndValue(parameters);
      String parameterString = "";

      for (String key in treeMap.keys) {
        parameterString = parameterString + Uri.encodeQueryComponent(key) + "=" + treeMap[key] + "&";
      }

      parameterString = parameterStringForRequestUrl(parameterString);

      String baseString = baseStringForSig(httpMethod, containsQueryParams, url, parameterString);
      String signingKey = CONSUMER_SECRET + "&" + tokenSecret;
      String requestUrl = createRequestUrl(containsQueryParams, "", url, parameterString, finalSignatureReq(signingKey, baseString));

      log("BASE-STRING : " + baseString + '\n');
      log("SIGNING-KEY : " + signingKey + '\n');
      log("REQUEST-URL : " + requestUrl + '\n');

      return requestUrl;
    }
  }

  Map<dynamic, dynamic> treeMapForKeyAndValue(String parameters) {
    Map<dynamic, dynamic> params = QueryString.parse(parameters);
    Map<dynamic, dynamic> treeMap = SplayTreeMap<dynamic, dynamic>();
    treeMap.addAll(params);
    return treeMap;
  }

  String getFinalParameter(bool containsQueryParams) {
    String appendValue = containsQueryParams ? '&' : '?';
    String consumerKey = appendValue + "consumer_key=$CONSUMER_KEY";
    String consumerSecret = "&consumer_secret=$CONSUMER_SECRET";
    String finalParameter = consumerKey + consumerSecret;

    return finalParameter;
  }

  String finalSignatureReq(String signingKey, String baseString) {
    crypto.Hmac hmacSha1 = crypto.Hmac(crypto.sha1, utf8.encode(signingKey)); // HMAC-SHA1
    crypto.Digest signature = hmacSha1.convert(utf8.encode(baseString));
    String finalSignature = base64Encode(signature.bytes);

    return finalSignature;
  }

  String baseStringForSig(String method, bool containsQueryParams, String url, String parameterString) {
    return method + "&" + Uri.encodeQueryComponent(containsQueryParams == true ? url.split("?")[0] : url) + "&" + Uri.encodeQueryComponent(parameterString);
  }

  String parameterStringForRequestUrl(String parameterString) {
    return parameterString.substring(0, parameterString.length - 1);
  }

  String createRequestUrl(bool containsQueryParams, String requestUrl, String url, String parameterString, String finalSignature) {
    return (containsQueryParams == true) ? url.split("?")[0] + "?" + parameterString + "&oauth_signature=" + Uri.encodeQueryComponent(finalSignature) : url + "?" + parameterString + "&oauth_signature=" + Uri.encodeQueryComponent(finalSignature);
  }
}

Future<Map<String, String>> buildTokenHeader({
  bool requireToken = false,
  bool isFlutterWave = false,
  String flutterWaveSecretKey = '',
}) async {
  Map<String, String> multipleHeaders = {HttpHeaders.contentTypeHeader: 'application/json'};

  // add flutter-wave key
  if (appStore.isLoggedIn && isFlutterWave) {
    multipleHeaders.putIfAbsent(HttpHeaders.authorizationHeader, () => "Bearer $flutterWaveSecretKey");
  }

  // add token for login user
  if (appStore.isLoggedIn) {
    multipleHeaders.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer ${appStore.token}');
  }

  if (requireToken) {
    Map<String, String> header = {HttpHeaders.authorizationHeader: "Bearer ${appStore.token}", "id": "${appStore.userId}"};
    multipleHeaders.addAll(header);
  }

  log(jsonEncode(multipleHeaders));

  return multipleHeaders;
}

Future<dynamic> buildHttpResponse(
  String endPoint, {
  HttpMethodType method = HttpMethodType.GET,
  Map? request,
  bool jsonRequest = true,
  HttpResponseType responseType = HttpResponseType.JSON,
  bool isTokenRequired = false,
  bool isFlutterWave = false,
  String flutterWaveSecretKey = '',
}) async {
  log('REQUEST : $request');

  if (await isNetworkAvailable()) {
    Uri url = Uri.parse(APICall().getOAuthURL(method.name, endPoint));

    Map<String, String> headers = {'Authorization':'token ${appStore.token}'};//await buildTokenHeader(requireToken: isTokenRequired);

    Response response;

    if (method == HttpMethodType.POST) {
      log('Request: ${jsonEncode(request)}');
      response = await post(url, body: jsonRequest ? jsonEncode(request) : request, headers: headers);
    } else if (method == HttpMethodType.DELETE) {
      response = await delete(url, headers: headers);
    } else if (method == HttpMethodType.PUT) {
      response = await put(url, body: jsonRequest ? jsonEncode(request) : request, headers: headers);
    } else {
      response = await get(url, headers: headers);
    }

    apiPrint(
      url: url.toString(),
      endPoint: endPoint,
      headers: jsonEncode(headers),
      request: jsonEncode(request),
      statusCode: response.statusCode,
      responseBody: response.body,
      methodtype: method.name,
    );

    return response;//await handleResponse(response, responseType: responseType);
  } else {
    throw errorInternetNotAvailable;
  }
}

Future handleResponse(Response response, {HttpResponseType responseType = HttpResponseType.JSON}) async {
  if (!await isNetworkAvailable()) throw errorInternetNotAvailable;
  if (!(response.statusCode).isSuccessful()) return errorHandle(response);

  if (response.body.isEmpty) return '';
  if (responseType == HttpResponseType.JSON) return jsonDecode(response.body);
  if (responseType == HttpResponseType.FULL_RESPONSE) return response;
  if (responseType == HttpResponseType.STRING) return response.body;
  if (responseType == HttpResponseType.BODY_BYTES) return response.bodyBytes;
}

Future responseHandler(Response response, {Map<String, dynamic>? req, isBookDetails = false, isPurchasedBook = false, isBookMarkBook = false}) async {
  if (!await isNetworkAvailable()) throw errorInternetNotAvailable;

  log('Body : ${response.body}');

  if (!(response.statusCode).isSuccessful()) return errorHandle(response);
  if (!response.body.contains("jwt_auth_invalid_token")) return jsonDecode(response.body);
  if (response.body.contains("jwt_auth_no_auth_header")) throw 'Authorization header not found.';
  if (appStore.userEmail.isEmpty && appStore.password.isEmpty || !await isNetworkAvailable()) openSignInScreen();

  Map<String, String> request = {"username": appStore.userEmail, "password": appStore.password};

  await getLoginUserRestApi(request).then((res) async {
    openSignInScreen();
    if (isBookDetails && req != null) await getBookDetailsRestWithLoading(getContext, request: req);
    if (isBookMarkBook) await getBookmarkRestApi();
  }).catchError((e, s) {
    debugPrint('ERROR - $e - STACK-TRACE - $s');
    openSignInScreen();
  });
}

dynamic errorHandle(Response response) {
  appStore.setLoading(false);

  if (response.statusCode == 400) return jsonDecode(response.body);
  if (response.statusCode == 401) throw 'Unauthorized';
  if (response.statusCode == 405) throw 'Method Not Allowed';
  if (response.statusCode == 406 && response.body.contains("code")) throw response.body.contains("message");
  if (response.statusCode == 500) throw 'Internal Server Error';
  if (response.statusCode == 501) throw 'Not Implemented';

  if (response.statusCode == 403) {
    if (response.body.contains("jwt_auth")) throw 'Invalid Credential.';
    throw 'Forbidden 403';
  }

  if (response.statusCode == 404) {
    if (response.body.contains("email_missing")) throw 'Email Not Found';
    if (response.body.contains("not_found")) throw 'Current password is invalid';
    if (response.body.contains("empty_wishlist")) throw 'No Product Available';
    throw 'Not Found 404';
  }

  if (!(response.body).isJson()) throw 'Invalid Json';

  throw 'Please try again later.';
}

Future logout(BuildContext context) async {
  if (!appStore.isNetworkAvailable) {
    toast("Internet is Not Available");
    appStore.setLoading(false);
    return;
  }

  showConfirmDialogCustom(
    context,
    title: locale.lblAreYourLogout,
    primaryColor: context.primaryColor,
    negativeText: locale.lblCancel,
    positiveText: locale.lblYes,
    onAccept: (e) async {
      await appStore.setLoggedIn(false);
      await cartStore.cleanCart();
      // await purchaseService.dispose();
      await appStore.setUserName('');
      await appStore.setToken('');
      await appStore.setFirstName('');
      await appStore.setLastName('');
      await appStore.setDisplayName('');
      await appStore.setUserId(0);
      await appStore.setUserEmail('');
      await appStore.setAvatar('');
      await appStore.setUserProfile('');
      await appStore.setSocialLogin(false);
      appStore.setLoading(false);
      await clearCurrency();
      await SignInScreen().launch(context, isNewTask: true);
    },
  );
}

void openSignInScreen() async {
  await appStore.setUserName('');
  await appStore.setToken('');
  await appStore.setFirstName('');
  await appStore.setLastName('');
  await appStore.setDisplayName('');
  await appStore.setUserId(0);
  await appStore.setUserEmail('');
  await appStore.setAvatar('');
  await appStore.setLoggedIn(false);
  await appStore.setUserProfile('');
  try {
    await SignInScreen().launch(getContext, isNewTask: true);
  } on Exception catch (e, s) {
    debugPrint('ERROR - $e - STACK-TRACE - $s');
    toast("Something went wrong please try again");
  }
}

void afterTransaction(BuildContext context, {required String bookId, required bool isClearCart, required bool isShowErrorMessage, required bool isSuccess, String msg = ''}) {
  appStore.setLoading(true);
  if (isClearCart) cartStore.removeCart();

  if (isShowErrorMessage) (msg.isEmpty) ? toast(locale.lblError) : toast(msg);

  cartStore.init();

  if (isSuccess) {
    afterBuildCreated(() async {
      await BookDescriptionScreen(bookId: bookId).launch(context);
      await DashboardScreen().launch(context, isNewTask: true);
    });
  } else {
    finish(context);
  }
}

Future clearData(BuildContext context) async {
  await appStore.setUserName('');
  await appStore.setToken('');
  await appStore.setFirstName('');
  await appStore.setLastName('');
  await appStore.setDisplayName('');
  await appStore.setUserId(0);
  await appStore.setUserEmail('');
  await appStore.setAvatar('');
  await appStore.setLoggedIn(false);
  await appStore.setUserProfile('');
  await appStore.setSocialLogin(false);
  cartStore.removeCart();
  await DashboardScreen().launch(context, isNewTask: true);
}

void apiPrint({String url = "", String endPoint = "", String headers = "", String request = "", int statusCode = 0, String responseBody = "", String methodtype = ""}) {
  Logger.Black.log("$url");
  Logger.Yellow.log("$endPoint");
  Logger.Magenta.log("$headers");
  Logger.Green.log("$request");
  Logger.Red.log("$responseBody");
}

enum Logger {
  Black("30"),
  Red("31"),
  Green("32"),
  Yellow("33"),
  Blue("34"),
  Magenta("35"),
  Cyan("36"),
  White("37");

  final String code;

  const Logger(this.code);

  void log(dynamic text) {
    print('\x1B[' + code + 'm' + text.toString() + '\x1B[0m');
  }
}
