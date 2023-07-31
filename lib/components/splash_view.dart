import 'package:bookkart_flutter/utils/widgets/colorize_animated_text.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

enum TextType { ColorizeAnimationText, TypeAnimatedText, ScaleAnimatedText, NormalText }

enum PageRouteTransition { Normal, CupertinoPageRoute, SlideTransition }

class SplashScreenView extends StatefulWidget {
  final Widget navigateTo;

  final String? imageSrc;

  final String text;

  final TextType textType;
  final TextStyle textStyle;

  final int imageSize;

  final Color? backgroundColor;

  final List<Color> colors;

  SplashScreenView({
    required this.navigateTo,
    required this.imageSrc,
    required this.imageSize,
    required this.textStyle,
    required this.colors,
    required this.textType,
    required this.backgroundColor,
    required this.text,
  });

  @override
  _SplashScreenViewState createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  Animation<double>? animation;

  @override
  void initState() {
    if (mounted) {
      super.initState();
      init();
    }
  }

  AnimationController getAnimationCont(TextType? textType) => (textType == TextType.TypeAnimatedText) ? AnimationController(vsync: this, duration: Duration(milliseconds: 500)) : AnimationController(vsync: this, duration: Duration(milliseconds: 500));

  init() async {
    animationController = getAnimationCont(widget.textType);
    animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animationController!, curve: Curves.easeInCirc));
    animationController!.forward();
    await 1.seconds.delay;
    return await widget.navigateTo.launch(context, isNewTask: true);
  }

  @override
  void dispose() {
    super.dispose();
    animationController!.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: SizedBox(
        width: context.width(),
        height: context.height(),
        child: FadeTransition(
          opacity: animation!,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(widget.imageSrc.validate(), height: widget.imageSize.validate().toDouble()),
              ColorizeAnimatedText(
                text: widget.text,
                speed: 4.seconds,
                textStyle: widget.textStyle,
                colors: widget.colors,
              ).paddingOnly(right: 10, left: 10, top: 20)
            ],
          ),
        ),
      ),
    );
  }
}
