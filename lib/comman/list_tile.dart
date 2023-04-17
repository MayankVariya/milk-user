import 'package:flutter/material.dart';
import 'package:milk_user/utils/colors.dart';

class ListTileWidget extends StatelessWidget {
  final Widget? leading;
  final Widget? trailing;
  final String title;
  final String? subTitle;
  final TextStyle? titleStyle;
  final TextStyle? subTitleStyle;
  final double? hPadding;
  final double? vPadding;
  final Color? tileColor;
  final bool? isTreeLine;
  final double? minLeadingWidth;
  final VoidCallback? onTap;
  const ListTileWidget(
      {super.key,
      this.leading,
      this.trailing,
      required this.title,
      this.subTitle,
      this.titleStyle,
      this.subTitleStyle,
      this.hPadding,
      this.vPadding,
      this.tileColor,
      this.isTreeLine,
      this.minLeadingWidth,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      trailing: trailing,
      title: Text(
        title,
        style: titleStyle ?? const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        subTitle ?? "",
        style: subTitleStyle ??
            const TextStyle(fontWeight: FontWeight.bold, color: grey),
      ),
      enabled: true,
      tileColor: tileColor,
      isThreeLine: isTreeLine ?? false,
      minLeadingWidth: minLeadingWidth,
      onTap: onTap,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), side: BorderSide.none),
      contentPadding: EdgeInsets.symmetric(
          horizontal: hPadding ?? 16, vertical: vPadding ?? 0),
    );
  }
}

class NavListTileWidget extends StatelessWidget {
  final Widget? leading;
  final String title;
  final TextStyle? titleStyle;
  final VoidCallback onTap;
  final Color? tileColor;
  final Widget? trailing;
  const NavListTileWidget(
      {super.key,
      this.leading,
      required this.title,
      this.titleStyle,
      required this.onTap, this.tileColor, this.trailing});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minLeadingWidth: 15,
      leading: leading,
      trailing:trailing ,
      onTap: onTap,
      enabled: true,
      tileColor:tileColor ,
      title: Text(
        title,
        style: titleStyle ?? const TextStyle(fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), side: BorderSide.none),
    );
  }
}
