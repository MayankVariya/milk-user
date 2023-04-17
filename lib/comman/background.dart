import 'package:flutter/material.dart';
import 'package:milk_user/size_config.dart';

class CirclesBackground extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final Color? topSmallCircleColor;
  final Color? topMediumCircleColor;
  final Color? topRightCircleColor;
  final Color? bottomRightCircleColor;
  final double topMediumLeft;
  final double topMediumWidth;
  final double topMediumTop;
  final double topMediumHight;

  const CirclesBackground(
      {Key? key,
      required this.child,
      this.backgroundColor,
      this.topSmallCircleColor,
      this.topMediumCircleColor,
      this.topRightCircleColor,
      this.bottomRightCircleColor,
      required this.topMediumWidth,
      required this.topMediumHight,
      required this.topMediumTop,
      required this.topMediumLeft})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(color: backgroundColor),
      child: Stack(
        children: [
          Positioned(
            top: SizeConfig.screenHeight! * -0.01, //-16,
            left: SizeConfig.screenWidth! * 0.6, //235,
            child: _CircularBox(
              width: SizeConfig.screenWidth! * 0.9, //398,
              height: SizeConfig.screenHeight! * 0.45, //398,
              color: topRightCircleColor!,
            ),
          ),
          Positioned(
            top: topMediumTop, //-412,
            left: topMediumLeft, //-184
            child: _CircularBox(
              width: topMediumWidth,
              height: topMediumHight,
              color: topMediumCircleColor!,
            ),
          ),
          Positioned(
            top: SizeConfig.screenHeight! * -0.36, //-292,
            left: SizeConfig.screenWidth! * -0.38, //-163,
            child: _CircularBox(
              width: SizeConfig.screenWidth! * 0.98, //398,
              height: SizeConfig.screenHeight! * 0.55, //398,
              color: topSmallCircleColor!,
            ),
          ),
          Positioned(
            top: SizeConfig.screenHeight! - (454 / 2),
            left: SizeConfig.screenWidth! - (454 / 2),
            child: _CircularBox(
              width: SizeConfig.screenWidth! * 44, //459,
              height: SizeConfig.screenHeight! * 0.59, //459,
              color: bottomRightCircleColor!,
            ),
          ),
          SafeArea(child: child),
        ],
      ),
    );
  }
}

class _CircularBox extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  const _CircularBox({
    Key? key,
    required this.width,
    required this.height,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(height),
      ),
    );
  }
}
