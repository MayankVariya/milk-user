import 'package:flutter/material.dart';
import 'package:milk_user/comman/widgets.dart';
import 'package:milk_user/size_config.dart';
import 'package:milk_user/utils/constants.dart';

milkQuintityDialog(context, List type, {required VoidCallback save}) {
  showAlertDialog(context, title: labelMilkQuintity, children: [
    SizedBox(
        width: SizeConfig.screenWidth! * 0.7,
        child: TextFormFieldWidget(
          autoFocus: true,
          label: type[0],
          suffix: const Text("Ltr"),
          labelStyle:
              const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        )),
    SizedBox(
      height: SizeConfig.screenHeight! * 0.01,
    ),
    SizedBox(
        width: SizeConfig.screenWidth! * 0.7,
        child: TextFormFieldWidget(
          label: type[1],
          suffix: const Text("Ltr"),
          labelStyle:
              const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        )),
  ], actions: [
    const BtnCancel(),
    BtnMaterial(
        vPadding: 2,
        onPressed: save,
        child: const Text(
          btnDone,
          style: TextStyle(color: white),
        ))
  ]);
}
