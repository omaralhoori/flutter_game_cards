import 'package:bookkart_flutter/components/app_loader.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/settings/settings_repository.dart';
import 'package:bookkart_flutter/utils/colors.dart';
import 'package:bookkart_flutter/utils/common_base.dart';
import 'package:bookkart_flutter/utils/extensions/string_extension.dart';
import 'package:bookkart_flutter/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

class RechargeBalanceScreen extends StatefulWidget {
  
  const RechargeBalanceScreen({super.key});

  @override
  State<RechargeBalanceScreen> createState() => _RechargeBalanceScreenState();
}

class _RechargeBalanceScreenState extends State<RechargeBalanceScreen> {
  final formKey = GlobalKey<FormState>();

  TextEditingController amountController = TextEditingController();

  FocusNode amountFocusNode = FocusNode();

  String result = "";

  void submitRequest() async {
    hideKeyboard(context);

    if (formKey.currentState!.validate()) {
      appStore.setLoading(true);

      Map<String, String> request = {"amount": amountController.text};

      await getRechargeBalanceRestApi(request).then((res) async {

        appStore.setLoading(false);
        //toast(res);
        setState(() {
          result = res;
        });
        amountController.clear();
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString());
      });
    }
  }

   @override
  void initState() {
    super.initState();
  }

    Widget _buildTopWidget() {
    return Container(
      child: Column(
        children: [
          Text(
            locale.introRechargeBalance,
            style: primaryTextStyle(size: 18),
            textAlign: TextAlign.center,
          ).center().paddingSymmetric(horizontal: 32),
          32.height,
        ],
      ),
    );
  }

  Widget _buildFormWidget() {
    return AutofillGroup(
      child: Column(
        children: [
          AppTextField(
            textFieldType: TextFieldType.NUMBER,
            controller: amountController,
            focus: amountFocusNode,
            errorThisFieldRequired: locale.lblFieldRequired,
            decoration: inputDecoration(context, locale.lblAmount),
            suffix: ic_term_and_condition.iconImage(size: 10).paddingAll(14),
          ),
          16.height,
        AppButton(
          color: primaryColor,
          text: locale.lblSubmit,
          shapeBorder: RoundedRectangleBorder(borderRadius: radius()),
          textStyle: boldTextStyle(color: white),
          width: context.width() - context.navigationBarHeight,
          onTap: () {
            submitRequest();
            //DashboardScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Slide);
          },
        ),
        24.height,
        Text(result)
        ],
      ),
    );
  }


@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.scaffoldBackgroundColor,
        automaticallyImplyLeading: Navigator.of(context).canPop(),
        scrolledUnderElevation: 0,
      ),
      body: Stack(
        children: [
          Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTopWidget(),
                  _buildFormWidget(),
                ],
              ),
            ),
          ),
          AppLoader(isObserver: true),
        ],
      ),
    );
  }
}


