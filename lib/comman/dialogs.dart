import 'package:flutter/material.dart';
import 'package:milk_user/utils/constants.dart';

import 'buttons.dart';

void buildDialog(BuildContext context,
    {List<Widget> children = const <Widget>[],
    double cHPadding = 20,
    Key? formKey,
    double cVPadding = 32}) {
  Dialog dialog = Dialog(
      shape: OutlineInputBorder(
          borderSide: BorderSide.none, borderRadius: BorderRadius.circular(10)),
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: cHPadding, vertical: cVPadding),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: children,
              ),
            ),
          )));
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => dialog,
  );
}

void showAlertDialog(BuildContext context,
    {String title = "",
    List<Widget>? children,
    List<Widget>? actions,
    Key? formKey,
    bool barrierDismissible = false,
    EdgeInsetsGeometry? actionsPadding}) {
  AlertDialog alertDialog = AlertDialog(
    shape: OutlineInputBorder(
        borderSide: BorderSide.none, borderRadius: BorderRadius.circular(10)),
    actionsPadding: actionsPadding,
    title: Text(title),
    content: Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children!,
      ),
    ),
    actions: actions,
  );
  showDialog(
    barrierDismissible: barrierDismissible,
    context: context,
    builder: (context) => alertDialog,
  );
}

showConfirmDeleteDialog(
  context, {
  VoidCallback? onClicked,
  String title = "",
  String content = "",
  String btnPerform = "",
}) =>
    showAlertDialog(context,
        actionsPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        title: title,
        children: [
          Text(content),
        ],
        actions: [
          const BtnCancel(),
          MaterialButton(
              color: red,
              shape: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10)),
              textColor: white,
              onPressed: onClicked,
              child: Text(btnPerform)),
        ]);

void showErrorAlertDialog(BuildContext context, String title, String content) {
  AlertDialog alertDialog = AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    title: Text(title),
    content: Text(content),
    actions: [
      TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Ok"))
    ],
  );
  showDialog(
    context: context,
    builder: (context) => alertDialog,
  );
}

void showLoadingDialog(BuildContext context, String title) {
  AlertDialog loadingDialog = AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    content: Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(
            height: 30,
          ),
          Text(title),
        ],
      ),
    ),
  );
  showDialog(
    context: context,
    builder: (context) => loadingDialog,
  );
}

void showEditDialog(BuildContext context,
    {List<Widget>? children,
    VoidCallback? onPressed,
    bool barrierDismissible = false,
    EdgeInsetsGeometry? actionsPadding}) {
  AlertDialog alertDialog = AlertDialog(
    shape: OutlineInputBorder(
        borderSide: BorderSide.none, borderRadius: BorderRadius.circular(10)),
    actionsPadding: actionsPadding,
    title: const Text("Edit"),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children!,
      ),
    ),
    actions: [const BtnCancel(), BtnText(onPressed: onPressed!, text: btnSave)],
  );
  showDialog(
    barrierDismissible: barrierDismissible,
    context: context,
    builder: (context) => alertDialog,
  );
}
