import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:milk_user/comman/widgets.dart';
import 'package:milk_user/models/customer.dart';
import 'package:milk_user/utils/constants.dart';
import 'package:provider/provider.dart';
import '../../dark_theme_provider.dart';
import 'change_password.dart';

class SettingScreen extends StatefulWidget {
  final CustomerModel customer;
  const SettingScreen({super.key, required this.customer});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    final themeChange= Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      appBar: appBar(title: labelDrawerSetting),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          Card(
            shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 3,
                shadowColor: indigo700,
            child: NavListTileWidget(
              titleStyle: TextStyle(color: themeChange.darkTheme?grey300:black,fontWeight: FontWeight.bold),
          
                leading:  Icon(icLock,color: themeChange.darkTheme?grey300:black,),
                tileColor: themeChange.darkTheme?Colors.white12:white,
                title: labelChangePassword,
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangePassword(
                        customer: widget.customer,
                      ),
                    ))),
          ),
          const SizedBox(height:15,),
          Card(
            
            shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 3,
                shadowColor: indigo700,
            child: NavListTileWidget(
              titleStyle: TextStyle(color: themeChange.darkTheme?grey300:black,fontWeight: FontWeight.bold),
              trailing: CupertinoSwitch(value: themeChange.darkTheme, onChanged: (value){
                themeChange.darkTheme=value;
              }),
                leading:  Icon(icTheme,color: themeChange.darkTheme?grey300:black),
                tileColor: themeChange.darkTheme?Colors.white12:white,
                title: labelChangeTheme,
                onTap: () {},),
          )
        ],
      ),
    );
  }
}