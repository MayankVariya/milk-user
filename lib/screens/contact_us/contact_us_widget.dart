import 'package:flutter/material.dart';
import 'package:milk_user/comman/widgets.dart';
import 'package:milk_user/screens/contact_us/url_launcher.dart';
import 'package:milk_user/size_config.dart';
import 'package:milk_user/utils/constants.dart';

class ContactUsHeader extends StatelessWidget {
  final Map<String, dynamic> admin;
  const ContactUsHeader({super.key, required this.admin});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Stack(
      children: [
        Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          margin: EdgeInsets.only(
              top: SizeConfig.screenHeight! * 0.130,
              right: SizeConfig.screenWidth! * 0.02,
              left: SizeConfig.screenWidth! * 0.02),
          child: Container(
            padding: EdgeInsets.only(top: SizeConfig.screenHeight! * 0.125),
            width: double.infinity,
            height: SizeConfig.screenHeight! / 3.8,
            decoration: BoxDecoration(
                color: indigo700, borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                Text(
                  admin["name"],
                  style: const TextStyle(
                      color: white, fontWeight: FontWeight.bold, fontSize: 22),
                ),
                SizedBox(
                  height: SizeConfig.screenHeight! * 0.021,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                      backgroundColor: white,
                      child: BtnIcon(
                          onPressed: () {
                            launchPhoneDialer(admin["contactNumber"]);
                          },
                          icon: icPhone),
                    ),
                    CircleAvatar(
                      backgroundColor: white,
                      child: BtnIcon(
                          onPressed: () {
                            launchMessage(admin["contactNumber"]);
                          },
                          icon: icMessage),
                    ),
                    CircleAvatar(
                      backgroundColor: white,
                      child: BtnIcon(
                          onPressed: () {
                            launchEmail(admin["email"]);
                          },
                          icon: icEmail),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: SizeConfig.screenHeight! * 0.026,
              left: SizeConfig.screenWidth! * 0.227),
          child: CircleAvatar(
            radius: 77,
            backgroundColor: indigo700,
            child: CircleAvatar(
              radius: 73,
              backgroundColor: white,
              backgroundImage: NetworkImage(admin["profilePic"].toString()),
              child: admin["profilePic"] == null
                  ?const Icon(
                      icperson,
                      size: 120,
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}

class ContactUsData extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;
  const ContactUsData(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ListTileWidget(
      title: title,
      leading: Padding(
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.screenHeight! * 0.011,
            horizontal: SizeConfig.screenWidth! * 0.02),
        child: Icon(icon),
      ),
      subTitle: subTitle,
    );
  }
}
