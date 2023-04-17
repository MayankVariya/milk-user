import 'package:flutter/cupertino.dart';
import 'package:milk_user/utils/colors.dart';

const FontWeight bold = FontWeight.bold;

/// AppBar
TextStyle appBarTitleTextStyle() =>
    const TextStyle(color: white, fontWeight: bold, fontSize: 17);

/// Login Page
TextStyle headerTextStyle() =>
    const TextStyle(fontSize: 25, fontWeight: bold, color: white);

TextStyle headerAppNameTextStyle() =>
    TextStyle(fontSize: 25, fontWeight: bold, color: blue200);

TextStyle forgotPasswordTextStyle() => const TextStyle(fontWeight: bold);

TextStyle headerLoginNowTextStyle() =>
    const TextStyle(fontSize: 30, color: white);

/// Forgot Password Page
TextStyle dropDownItemsTextStyle() => const TextStyle(fontWeight: bold);

TextStyle btnSubmitTextStyle() => const TextStyle(color: white);

TextStyle buildUserIdTextStyle() =>
    const TextStyle(fontSize: 16, fontWeight: bold);

TextStyle buildForgotPasswordHeadLine() =>
    TextStyle(fontWeight: bold, fontSize: 17, color: grey700);
TextStyle buildForgotPasswordHeader() =>
    const TextStyle(color: white, fontSize: 30, fontWeight: bold);

/// Home Page
TextStyle appbarTitleTextStyle() => const TextStyle(color: white,fontWeight: bold,fontSize: 18,);

TextStyle drawerUserNameTextStyle() =>
    const TextStyle(fontSize: 20, color: white);

TextStyle drawerUserIdTextStyle() =>
    const TextStyle(color: white54, fontSize: 14);

TextStyle totalMilkTextStyle() =>
    const TextStyle(fontWeight: bold, fontSize: 20, color: white);

///profile
TextStyle userIdTextStyle() =>
    const TextStyle(color: black, fontSize: 14, fontWeight: bold);
