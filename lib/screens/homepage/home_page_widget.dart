import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:milk_user/comman/widgets.dart';

import '../../utils/constants.dart';

void handleMenuButtonPressed() {
  advancedDrawerController.showDrawer();
}

PreferredSizeWidget customAppBar(String title, {List<Widget>? actions}) =>
    AppBar(
      leadingWidth: 33,
      elevation: 1,
      backgroundColor: indigo700,
      actions: actions,
      title: Text(
        title,
        style: appbarTitleTextStyle(),
      ),
      leading: IconButton(
        color: white,
        iconSize: 28,
        onPressed: handleMenuButtonPressed,
        icon: ValueListenableBuilder<AdvancedDrawerValue>(
          valueListenable: advancedDrawerController,
          builder: (_, value, __) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Icon(
                value.visible ? icClear : icMenu,
                key: ValueKey<bool>(
                  value.visible,
                ),
              ),
            );
          },
        ),
      ),
    );

Widget customProfileCircle(String path) => Padding(
    padding: const EdgeInsets.only(
      left: 50,
      right: 50,
      top: 40,
      bottom: 20,
    ),
    child: CircleAvatar(
      radius: 65,
      backgroundColor: white,
      backgroundImage: NetworkImage(path == ""
          ? "https://static.vecteezy.com/system/resources/previews/005/544/718/original/profile-icon-design-free-vector.jpg"
          : path),
      // child: path == ""
      //     ? const Icon(
      //         Icons.person,
      //         size: 100,
      //         color: grey,
      //       )
      //     : null,
    ));
