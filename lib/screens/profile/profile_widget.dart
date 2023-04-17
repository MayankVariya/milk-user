
import 'package:flutter/material.dart';
import 'package:milk_user/utils/constants.dart';
import 'package:provider/provider.dart';

import '../../dark_theme_provider.dart';

Widget buildBackButton(context, {IconData? icon,required Function() backButton}) {
  return IconButton(
      alignment: Alignment.centerLeft,
      onPressed: backButton,
      icon: Icon(
        icon,
        color: white,
      ));
}

class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final bool isEdit;
  final VoidCallback onClicked;
  final bool fillProfile;

  const ProfileWidget({
    Key? key,
    required this.imagePath,
    this.isEdit = false,
    required this.onClicked,
    required this.fillProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange= Provider.of<DarkThemeProvider>(context);
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            backgroundColor: themeChange.darkTheme?black:white,
            radius: fillProfile ? 70 : 80,
            child: imagePath == ""
                ? const Icon(
                    icperson,
                    size: 100,
                    color: grey,
                  )
                : buildImage(),
          ),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(themeChange.darkTheme?black:indigo700,themeChange.darkTheme?Colors.white70:white,),
          ),
        ],
      ),
    );
  }

  Widget buildImage() {
    final image = NetworkImage(imagePath);

    return ClipOval(
      child: Material(
        color: transparent,
        child: Image(
          image: image,
          fit: BoxFit.cover,
          width: fillProfile ? 132 : 150,
          height: fillProfile ? 132 : 150,
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color,Color cricleColor ) => buildCircle(
        color: cricleColor,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: GestureDetector(
            onTap: onClicked,
            child: Icon(
              isEdit ? icAddPhoto : icEdit,
              color: white,
              size: 20,
            ),
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
