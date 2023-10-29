import 'dart:async';

import 'package:bookkart_flutter/locale/language_en.dart';
import 'package:bookkart_flutter/screens/settings/store/bluetooth_store.dart';
import 'package:bookkart_flutter/screens/splash_screen.dart';
import 'package:bookkart_flutter/utils/app_theme.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import 'locale/app_localizations.dart';
import 'locale/languages.dart';
import 'screens/bookDescription/store/cart_store.dart';
import 'screens/dashboard/model/offline_book_list_model.dart';
import 'store/api_store.dart';
import 'store/app_store.dart';
import 'utils/common_base.dart';
import 'utils/database_helper.dart';

AppStore appStore = AppStore();
CartStore cartStore = CartStore();
ApiStore apiStore = ApiStore();
BluetoothStore bluetoothStore = BluetoothStore();

List<OfflineBookList> downloadedList = <OfflineBookList>[];

BaseLanguage locale = LanguageEn();

final DatabaseHelper dbHelper = DatabaseHelper.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initialize(aLocaleLanguageList: languageList());

  defaultRadius = 30;



  defaultRadius = 30;

  await appStore.setLoggedIn(getBoolAsync(IS_LOGGED_IN).validate(), isInitializing: true);
  await appStore.setDarkMode(getBoolAsync(DARK_MODE).validate(), isInitializing: true);
  await appStore.setRemember(getBoolAsync(REMEMBER_PASSWORD).validate(), isInitializing: true);
  await appStore.setFirstTime(getBoolAsync(IS_FIRST_TIME));

  int currentIndex = getIntAsync(THEME_MODE_INDEX).validate();

  if (currentIndex == THEME_MODE_LIGHT) {
    appStore.setDarkMode(false);
  } else if (currentIndex == THEME_MODE_DARK) {
    appStore.setDarkMode(true);
  }
 
  await appStore.setLanguage(getStringAsync(SELECTED_LANGUAGE_CODE), isInitializing: true);

  if (appStore.isLoggedIn) {
    await appStore.setUserEmail(getStringAsync(USER_EMAIL), isInitializing: true);
    await appStore.setUserName(getStringAsync(USERNAME), isInitializing: true);
    await appStore.setFirstName(getStringAsync(FIRST_NAME), isInitializing: true);
    await appStore.setLastName(getStringAsync(LAST_NAME), isInitializing: true);
    await appStore.setContactNumber(getStringAsync(CONTACT_NUMBER), isInitializing: true);
    await appStore.setWebsite(getStringAsync(USER_WEBSITE), isInitializing: true);
    await appStore.setUserId(getIntAsync(USER_ID), isInitializing: true);
    await appStore.setLoginType(getStringAsync(LOGIN_TYPE), isInitializing: true);
    await appStore.setUserType(getStringAsync(USER_TYPE), isInitializing: true);
    await appStore.setPlayerId(getStringAsync(PLAYER_ID), isInitializing: true);
    await appStore.setToken(getStringAsync(TOKEN), isInitializing: true);
    await appStore.setUserProfile(getStringAsync(PROFILE_IMAGE), isInitializing: true);
    await appStore.setAvatar(getStringAsync(AVATAR));
    await appStore.setPaymentMethod(getStringAsync(PAYMENT_METHOD), isInitializing: true);
  }

  await bluetoothStore.init();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription<ConnectivityResult> onConnectivityChanged;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    onConnectivityChanged = Connectivity().onConnectivityChanged.listen((event) {
      log('onConnectivityChanged $event');
      appStore.setNetworkAvailabilityForUser(event == ConnectivityResult.wifi || event == ConnectivityResult.mobile);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    onConnectivityChanged.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return MaterialApp(
          home: SplashScreen(),
          themeMode: appStore.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          navigatorKey: navigatorKey,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          debugShowCheckedModeBanner: false,
          supportedLocales: LanguageDataModel.languageLocales(),
          locale: Locale(appStore.selectedLanguageCode),
          localizationsDelegates: [
            AppLocalizations(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) => locale,
        );
      },
    );
  }
}
