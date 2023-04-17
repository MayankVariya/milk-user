import 'package:flutter/material.dart';
import 'package:milk_user/comman/widgets.dart';
import 'package:milk_user/utils/constants.dart';

PreferredSizeWidget appBar({String title = "", List<Widget>? actions}) =>
    AppBar(
      title: Text(title),
      
      titleTextStyle: appBarTitleTextStyle(),
      backgroundColor: indigo700,
      iconTheme: const IconThemeData(color: white),
      elevation: 1,
      actions: actions,
    );
