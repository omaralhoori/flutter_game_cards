import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/auth/view/sign_in_screen.dart';
import 'package:bookkart_flutter/screens/dashboard/view/dashboardFragment/book_view_fragment.dart';
import 'package:bookkart_flutter/screens/dashboard/view/dashboardFragment/category_list_fragment_screen.dart';
import 'package:bookkart_flutter/screens/dashboard/view/dashboardFragment/library_view_fragment.dart';
import 'package:bookkart_flutter/screens/dashboard/view/dashboardFragment/search_view_fragment.dart';
import 'package:bookkart_flutter/screens/settings/view/setting_screen.dart';
import 'package:bookkart_flutter/screens/transaction/view/my_cart_screen.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:bookkart_flutter/utils/extensions/string_extension.dart';
import 'package:bookkart_flutter/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen();

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int currentIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (getIntAsync(THEME_MODE_INDEX) == 2) appStore.setDarkMode(context.platformBrightness() == Brightness.dark);
  }

  @override
  void initState() {
    if (mounted) {
      super.initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DoublePressBackWidget(
      child: Scaffold(
        floatingActionButton: Observer(
          builder: (context) {
            if (cartStore.cartList.isNotEmpty && appStore.isLoggedIn) {
              return FloatingActionButton(
                backgroundColor: context.primaryColor,
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    IconButton(
                      icon: Icon(Icons.shopping_cart_outlined, color: white),
                      onPressed: () {
                        (appStore.isLoggedIn) ? MyCartScreen().launch(context) : SignInScreen().launch(context);
                      },
                    ),
                    if (cartStore.cartList.length > 0)
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle, backgroundColor: redColor),
                        child: Text(cartStore.cartList.length.toString(), style: primaryTextStyle(size: 12, color: white)).paddingAll(4),
                      ),
                  ],
                ),
                onPressed: () {
                  MyCartScreen().launch(context);
                },
              );
            }
            return Offstage();
          },
        ),
        body: [
          const CategoriesListFragment(showLargeTitle: false),//BookStoreViewFragment(),
          MyCartScreen(),//CategoriesListFragment(showLargeTitle: false)(appStore.isLoggedIn && !getBoolAsync(HAS_IN_REVIEW)) ? const MyLibraryViewFragment() : const CategoriesListFragment(showLargeTitle: false),
          const SearchViewFragment(),
          const SettingScreen(),
        ][currentIndex],
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentIndex,
          height: 60,
          onDestinationSelected: (index) {
            currentIndex = index;
            setState(() {});
          },
          destinations: [
            NavigationDestination(
              icon: ic_home.iconImage(color: textSecondaryColor),
              selectedIcon: ic_home.iconImage(color: context.primaryColor),
              label: locale.titleBookStore,
            ),
            NavigationDestination(
              icon: ic_shopping_cart.iconImage(color: textSecondaryColor),
              selectedIcon: ic_shopping_cart.iconImage(color: context.primaryColor),
              label: locale.lblMyCart,
            ),
            // NavigationDestination(
            //   icon: (appStore.isLoggedIn && !getBoolAsync(HAS_IN_REVIEW)) ? ic_library.iconImage(color: textSecondaryColor) : ic_category.iconImage(color: textSecondaryColor),
            //   label: (appStore.isLoggedIn && !getBoolAsync(HAS_IN_REVIEW)) ? locale.titleMyLibrary : locale.lblCategories,
            //   selectedIcon: (appStore.isLoggedIn && !getBoolAsync(HAS_IN_REVIEW)) ? ic_library.iconImage(color: context.primaryColor) : ic_category.iconImage(color: context.primaryColor),
            // ),
            NavigationDestination(
              icon: ic_search.iconImage(color: textSecondaryColor),
              selectedIcon: ic_search.iconImage(color: context.primaryColor),
              label: locale.titleSearch,
            ),
            NavigationDestination(
              icon: ic_profile.iconImage(color: textSecondaryColor),
              selectedIcon: ic_profile.iconImage(color: context.primaryColor),
              label: locale.lblSettings,
            ),
          ],
        ),
      ),
    );
  }
}
