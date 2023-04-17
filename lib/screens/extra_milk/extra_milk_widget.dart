import 'package:flutter/material.dart';
import 'package:milk_user/size_config.dart';
import 'package:milk_user/utils/constants.dart';
import 'package:provider/provider.dart';

import '../../dark_theme_provider.dart';



class ToggleButtonWidget extends StatelessWidget {
  final void Function(int)? onPressed;
  final List<bool> isSelected;
  final List<Widget> children;
  const ToggleButtonWidget(
      {super.key,
      this.onPressed,
      required this.isSelected,
      required this.children});

  @override
  Widget build(BuildContext context) {
    final themeChange= Provider.of<DarkThemeProvider>(context);
    SizeConfig().init(context);
    return ToggleButtons(
      direction: Axis.horizontal,
      onPressed: onPressed,
      textStyle: const TextStyle(
        fontSize: 16,
      ),
      borderRadius: const BorderRadius.all(
        Radius.circular(8),
      ),
      selectedBorderColor: indigo700,
      selectedColor: white,
      fillColor: indigo700,
      color:  themeChange.darkTheme?Colors.white:indigo700,
      constraints: BoxConstraints(
        minHeight: SizeConfig.screenHeight! * 0.065,
        minWidth: SizeConfig.screenWidth! * 0.289,
      ),
      isSelected: isSelected,
      children: children,
    );
  }
}

class TaskTitle extends StatelessWidget {
  final String text;
  const TaskTitle({super.key, required this.text});
  
  @override
  Widget build(BuildContext context) {
    final themeChange= Provider.of<DarkThemeProvider>(context);
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: themeChange.darkTheme?Colors.white70:grey700,
        fontSize: 15,
      ),
    );
  }
}

class AddTask extends StatelessWidget {
  final VoidCallback increment;
  final VoidCallback decrement;
  final String text;
  const AddTask(
      {super.key,
      required this.increment,
      required this.decrement,
      required this.text});

  @override
  Widget build(BuildContext context) {
    Provider.of<DarkThemeProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
       FloatingActionButton(
        backgroundColor: indigo700,
          heroTag: "decriment",
          onPressed: decrement,
          child:const Icon(icRemove,color: white),
        ),
        Text(
          text,
          style: const TextStyle(
            fontSize: 35,
          ),
        ),
        FloatingActionButton(
        backgroundColor: indigo700,

          heroTag: "increment",
          onPressed: increment,
          child:const Icon(icAdd,color: white),
        ),
      ],
    );
  }
}

class TotalTask extends StatelessWidget {
  final double ltr;
  const TotalTask({super.key, required this.ltr});

  @override
  Widget build(BuildContext context) {
    final themeChange= Provider.of<DarkThemeProvider>(context);
    SizeConfig().init(context);
    return Container(
      height: SizeConfig.screenHeight! * 0.07,
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.screenWidth! * 0.07,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: themeChange.darkTheme?Colors.white12:grey300,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            labelTotal,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: themeChange.darkTheme?Colors.white70:grey700,
            ),
          ),
          Text(
            '$ltr Liters',
            style:  TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: themeChange.darkTheme?Colors.white:black,
            ),
          ),
        ],
      ),
    );
  }
}
