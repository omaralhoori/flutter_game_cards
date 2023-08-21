import 'package:bookkart_flutter/components/app_loader.dart';
import 'package:bookkart_flutter/components/background_component.dart';
import 'package:bookkart_flutter/components/cached_image_widget.dart';
import 'package:bookkart_flutter/components/no_internet_component.dart';
import 'package:bookkart_flutter/components/sliver_appbar_widget.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/bookDescription/book_description_repository.dart';
import 'package:bookkart_flutter/screens/bookDescription/model/invoice_list_model.dart';
import 'package:bookkart_flutter/screens/bookDescription/model/invoice_model.dart';
import 'package:bookkart_flutter/screens/bookDescription/view/invoice_details_screen.dart';
import 'package:bookkart_flutter/screens/dashboard/component/all_sub_category_component.dart';
import 'package:bookkart_flutter/screens/settings/settings_repository.dart';
import 'package:bookkart_flutter/utils/colors.dart';
import 'package:bookkart_flutter/utils/common_base.dart';
import 'package:bookkart_flutter/utils/extensions/int_extensions.dart';
import 'package:bookkart_flutter/utils/extensions/string_extension.dart';
import 'package:bookkart_flutter/utils/images.dart';
import 'package:bookkart_flutter/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class RecommendationsScreen extends StatefulWidget {
  
  const RecommendationsScreen({super.key});

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  final formKey = GlobalKey<FormState>();

  TextEditingController subjectController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  FocusNode subjectFocusNode = FocusNode();
  FocusNode messageFocusNode = FocusNode();

  void shareRecommendation() async {
    hideKeyboard(context);

    if (formKey.currentState!.validate()) {
      appStore.setLoading(true);

      Map<String, String> request = {"subject": subjectController.text, "message": messageController.text};

      await getShareRecommendationRestApi(request).then((res) async {

        appStore.setLoading(false);
        if(res){
          toast(locale.msgSuccessRecommendation);
        messageController.clear();
        subjectController.clear();
        }else{
          toast(locale.somethingWentWrong);
        }
        
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
            locale.introRecommendation,
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
            textFieldType: TextFieldType.OTHER,
            controller: subjectController,
            focus: subjectFocusNode,
            nextFocus: messageFocusNode,
            errorThisFieldRequired: locale.lblFieldRequired,
            decoration: inputDecoration(context, locale.lblSubject),
            suffix: ic_term_and_condition.iconImage(size: 10).paddingAll(14),
          ),
          16.height,
          AppTextField(
            textFieldType: TextFieldType.MULTILINE,
            minLines: 6,
            controller: messageController,
            focus: messageFocusNode,
            errorThisFieldRequired: locale.lblFieldRequired,
            decoration: inputDecoration(context, locale.lblRecommendation),
            suffix: ic_message.iconImage(size: 10).paddingAll(14),
          ),
          24.height,
        AppButton(
          color: primaryColor,
          text: locale.lblSubmit,
          shapeBorder: RoundedRectangleBorder(borderRadius: radius()),
          textStyle: boldTextStyle(color: white),
          width: context.width() - context.navigationBarHeight,
          onTap: () {
            shareRecommendation();
            //DashboardScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Slide);
          },
        ),
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


