import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:milk_user/models/customer.dart';
import 'package:milk_user/network/helper.dart';
import 'package:milk_user/screens/homepage/home_page.dart';
import 'package:milk_user/screens/loginpage/login_screen.dart';
import 'package:milk_user/size_config.dart';
import 'package:milk_user/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  // check the user's login status using shared preferences
  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
    Timer(const Duration(seconds: 4), navigateToScreen);
  }

  // navigate to the appropriate screen based on login status
  void navigateToScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final currantUser = prefs.getString("cUser");

    if (currantUser == null || isLoggedIn == false) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ));
    } else {
      CustomerModel? user =
          await FirebaseHelper.getUserModelByProfile(currantUser);
      if (user != null) {
        if (user.useNotDeleted == null) {
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ));
        } else {
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(customer: user),
              ));
        }
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark, statusBarColor: transparent),
    );
    return Scaffold(
        body: Stack(
      children: [
        Container(
            height: double.infinity,
            width: double.infinity,
            color: white,
            child: const Image(fit: BoxFit.cover, image: AssetImage(splash))),
        Padding(
          padding: EdgeInsets.only(
              top: SizeConfig.screenHeight! * 0.9,
              left: SizeConfig.screenWidth! * 0.45),
          child: CircularProgressIndicator(
            color: indigo700,
            strokeWidth: 3,
          ),
        ),
      ],
    ));
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    super.dispose();
  }
}
