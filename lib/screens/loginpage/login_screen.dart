import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:milk_user/comman/widgets.dart';
import 'package:milk_user/models/customer.dart';
import 'package:milk_user/network/share_preferences.dart';
import 'package:milk_user/screens/forgot_password/forgot_password.dart';
import 'package:milk_user/screens/homepage/home_page.dart';
import 'package:milk_user/size_config.dart';
import 'package:milk_user/utils/constants.dart';
import 'package:provider/provider.dart';
import '../../dark_theme_provider.dart';
import 'login_screen_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool obscured = true;
  CustomerModel? customer;

  Future<void> getCustomer(String id, String pass) async {
    //showLoadingDialog(context, "Loggin...");
    try {
      final userRef = FirebaseFirestore.instance.collection("users");

      final querySnapshot = await userRef.where("id", isEqualTo: id).get();
      if (querySnapshot.docs.isNotEmpty) {
        final customers = querySnapshot.docs.first.data();
        customer = CustomerModel(
            id: customers["id"],
            pass: customers["pass"],
            cid: customers["cid"],
            cName: customers["cName"],
            cProfilePic: customers["cProfilePic"],
            cContactNumber: customers["cContactNumber"],
            cEmail: customers["cEmail"],
            cAddress: customers["cAddress"],
            myproduct: customers["myproduct"],
            delivered: customers["delivered"],
            useNotDeleted: customers["useNotDeleted"]);
        if (pass == customers["pass"]) {
          await saveLoginCredentials(id, pass, customers["cid"]);
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(
                  customer: customer,
                ),
              ));
          userIdController.clear();
          passwordController.clear();
        } else {
          // ignore: use_build_context_synchronously
          showErrorAlertDialog(
              context, "Invalid Credentials", "Please Fill correct password.");
        }
      } else {
        // ignore: use_build_context_synchronously
        showErrorAlertDialog(context, "Invalid Credentials", "No User found");
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      showErrorAlertDialog(context, "error", "$e");
    }
  }

  checkValue() async {
    String id = userIdController.text.trim();
    String pass = passwordController.text.trim();

    if (formKey.currentState!.validate()) {
      await getCustomer(id, pass);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeChange= Provider.of<DarkThemeProvider>(context);
    SizeConfig().init(context);
    return Scaffold(
        body: CirclesBackground(
      topMediumHight: SizeConfig.screenHeight! * 0.92, //700,
      topMediumWidth: SizeConfig.screenWidth! * 1.95,
      topMediumTop: SizeConfig.screenHeight! * -0.58,
      topMediumLeft: SizeConfig.screenWidth! * -0.65, //-223,
      backgroundColor: themeChange.darkTheme?black:white,
      topSmallCircleColor: indigo700,
      topMediumCircleColor: indigo700,
      topRightCircleColor: blue200,
      bottomRightCircleColor: themeChange.darkTheme?black:white,
      child: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.defaultSize! * 3.5,
            vertical: SizeConfig.defaultSize! * 2.0,
          ),
          physics: const NeverScrollableScrollPhysics(),
          children: [
            ///Top Header WELCOME TO KUDOS MILK
            const HeaderText(),

            ///Center Header Login Now
            const HeaderCenter(),
            SizedBox(
              height: SizeConfig.screenHeight! * 0.015,
            ),
            TextFormFieldWidget(

              controller: userIdController,
              label: labelUserId,
              keyboardType: TextInputType.number,
              hintText: "12345 67890",
              validator: (userId) {
                  String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                  RegExp regExp = RegExp(pattern);
                  if (userId == null || userId.isEmpty) {
                    return "Please Enter User ID";
                  } else if (!regExp.hasMatch(userId)) {
                    return 'User ID field must contain only numbers';
                  } else if (userId.length != 10) {
                    return 'User ID must be of 10 digit';
                  }
                  return null;
                }
            ),
            SizedBox(
              height: SizeConfig.defaultSize! * 2.0,
            ),
            TextFormFieldWidget(
                controller: passwordController,
                label: labelPassword,
                obscureText: obscured,
                keyboardType: TextInputType.number,
                hintText: "*******",
                suffixIcon: BtnIcon(
                    icon: obscured ? icVisibleOff : icVisible,
                    onPressed: () {
                      setState(() {
                        obscured = !obscured;
                      });
                    }),
                validator: (pass) {
                  if (pass!.isEmpty) {
                    return 'Please enter Password';
                  } else if (pass.length < 6) {
                    return "Password must be at least 6 characters long.";
                  } else {
                    return null;
                  }
                }),
            SizedBox(
              height: SizeConfig.defaultSize! * 2.5,
            ),

            /// Forgot password Task
            ForgotPasswordText(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>const  ForgotPassword(),
                  )),
            ),
            SizedBox(
              height: SizeConfig.defaultSize! * 2.0,
            ),

            ///Login Button
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize! * 6),
              child: BtnMaterial(
                  onPressed: () {
                    checkValue();
                  },
                  child: const Text(
                    txtLogin,
                    style: TextStyle(color: white),
                  )),
            ),
            Padding(
              padding: EdgeInsets.only(top: SizeConfig.screenHeight! * 0.17),
              child: Text(
                notAccount,
                style: TextStyle(color: indigo700, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
