import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:milk_user/comman/widgets.dart';
import 'package:milk_user/size_config.dart';
import 'package:milk_user/utils/colors.dart';
import 'package:milk_user/utils/icons.dart';
import 'package:milk_user/utils/strings.dart';
import 'package:provider/provider.dart';

import '../../dark_theme_provider.dart';

String cid = "";

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({
    super.key,
  });

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final forgotNewPassController = TextEditingController();
  final forgotNewConfirmPassController = TextEditingController();
  final numberController = TextEditingController();
  final auth = FirebaseAuth.instance;
  final otpController = TextEditingController();

  final verificationCode = TextEditingController();

  bool obscured = true;

  // checkCredential(String number) async {
  //   final userRef = FirebaseFirestore.instance.collection("users");
  //   final querySnapshot =
  //       await userRef.where("cContactNumber", isEqualTo: number).get();
  //   if (querySnapshot.docs.isNotEmpty) {
  //     final user = querySnapshot.docs.first.data();
  //     try {
  //       ConfirmationResult confirmationResult = await FirebaseAuth.instance
  //           .signInWithPhoneNumber("+91$number",
  //               RecaptchaVerifier(auth: FirebaseAuthPlatform.instance));

  //       showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(15)),
  //             title: const Text("Enter verification code"),
  //             content: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 TextFormField(
  //                   controller: otpController,
  //                   keyboardType: TextInputType.number,
  //                   decoration: const InputDecoration(
  //                     labelText: "Verification code",
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             actions: [
  //               TextButton(
  //                 child: const Text("Verify"),
  //                 onPressed: () async {
  //                   try {
  //                     UserCredential credential =
  //                         await confirmationResult.confirm(otpController.text);

  //                     if (credential.user != null) {
  //                       // ignore: use_build_context_synchronously
  //                       Navigator.pushReplacement(
  //                           context,
  //                           MaterialPageRoute(
  //                             builder: (context) => const EditPasswordWidget(),
  //                           ));
  //                     }
  //                   } catch (e) {
  //                     showErrorAlertDialog(context, "Error", "$e");
  //                   }
  //                 },
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     } catch (e) {
  //       // ignore: use_build_context_synchronously
  //       showErrorAlertDialog(context, "Error", "$e");
  //     }
  //   } else {
  //     // ignore: use_build_context_synchronously
  //     showErrorAlertDialog(context, "Error", "User Not Available");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    SizeConfig().init(context);
    return Scaffold(
      body: CirclesBackground(
        topMediumHight: SizeConfig.screenHeight! * 0.8, //700,
        topMediumWidth: SizeConfig.screenWidth! * 1.72, //700,
        topMediumTop: SizeConfig.defaultSize! * -41, //-412,
        topMediumLeft: SizeConfig.defaultSize! * -23, //-223,
        backgroundColor: themeChange.darkTheme ? black : white,
        topSmallCircleColor: indigo700,
        topMediumCircleColor: indigo700,
        topRightCircleColor: blue200,
        bottomRightCircleColor: themeChange.darkTheme ? black : white,
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.screenHeight! * 0.04,
              vertical: SizeConfig.screenHeight! * 0.02),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    icBack,
                    color: white,
                  )),
            ),
            SizedBox(
              height: SizeConfig.screenHeight! * 0.06,
            ),
            Text(
              labelForgotPassword,
              style: buildForgotPasswordHeader(),
            ),
            SizedBox(
              height: SizeConfig.screenHeight! * 0.08,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.screenHeight! * 0.02),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormFieldWidget(
                      label:
                          "Enter Mobile Number to \nVerified and Reset Password",
                      controller: numberController,
                      keyboardType: TextInputType.phone,
                      validator: (number) {
                        return validateMobile(number!);
                      },
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight! * 0.02,
                    ),
                    BtnMaterial(
                        hPadding: SizeConfig.screenWidth! * 0.17,
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            final userRef =
                                FirebaseFirestore.instance.collection("users");
                            final querySnapshot = await userRef
                                .where("cContactNumber",
                                    isEqualTo: numberController.text)
                                .get();
                            if (querySnapshot.docs.isNotEmpty) {
                              final user = querySnapshot.docs.first.data();
                              setState(() {
                                cid = user["cid"];
                              });
                              // ignore: use_build_context_synchronously
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const EditPasswordWidget(),
                                  ));
                              numberController.clear();
                            } else {
                              // ignore: use_build_context_synchronously
                              showErrorAlertDialog(
                                  context, "Error", "User Not Available");
                            }
                          }
                        },
                        child: const Text(
                          "Submit",
                          style: TextStyle(color: white),
                        )),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class EditPasswordWidget extends StatefulWidget {
  const EditPasswordWidget({super.key});

  @override
  State<EditPasswordWidget> createState() => _EditPasswordWidgetState();
}

class _EditPasswordWidgetState extends State<EditPasswordWidget> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final forgotNewPassController = TextEditingController();
  final forgotNewConfirmPassController = TextEditingController();
  bool obscured = true;

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    SizeConfig().init(context);
    return Scaffold(
      body: CirclesBackground(
        topMediumHight: SizeConfig.screenHeight! * 0.8, //700,
        topMediumWidth: SizeConfig.screenWidth! * 1.72, //700,
        topMediumTop: SizeConfig.defaultSize! * -41, //-412,
        topMediumLeft: SizeConfig.defaultSize! * -23, //-223,
        backgroundColor: themeChange.darkTheme ? black : white,
        topSmallCircleColor: indigo700,
        topMediumCircleColor: indigo700,
        topRightCircleColor: blue200,
        bottomRightCircleColor: themeChange.darkTheme ? black : white,
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.screenHeight! * 0.04,
              vertical: SizeConfig.screenHeight! * 0.02),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    icBack,
                    color: white,
                  )),
            ),
            SizedBox(
              height: SizeConfig.screenHeight! * 0.06,
            ),
            Text(
              labelForgotPassword,
              style: buildForgotPasswordHeader(),
            ),
            SizedBox(
              height: SizeConfig.screenHeight! * 0.08,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.screenHeight! * 0.009),
              child: Form(
                key: formKey,
                child: Column(children: [
                  TextFormFieldWidget(
                    label: labelNewPassword,
                    controller: forgotNewPassController,
                    obscureText: obscured,
                    validator: (newPass) {
                      if (newPass!.isEmpty) {
                        return "Please Enter New PassWord";
                      }
                      return null;
                    },
                    suffixIcon: BtnIcon(
                        icon: obscured ? icVisibleOff : icVisible,
                        onPressed: () {
                          setState(() {
                            obscured = !obscured;
                          });
                        }),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.02,
                  ),
                  TextFormFieldWidget(
                    label: labelConfirmPassword,
                    controller: forgotNewConfirmPassController,
                    obscureText: obscured,
                    validator: (confirmPass) {
                      if (confirmPass!.isEmpty) {
                        return "Please Enter PassWord";
                      }
                      return null;
                    },
                    suffixIcon: BtnIcon(
                        icon: obscured ? icVisibleOff : icVisible,
                        onPressed: () {
                          setState(() {
                            obscured = !obscured;
                          });
                        }),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.02,
                  ),
                  BtnMaterial(
                      hPadding: SizeConfig.screenWidth! * 0.17,
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          if (forgotNewPassController.text ==
                              forgotNewConfirmPassController.text) {
                            await FirebaseFirestore.instance
                                .collection("users")
                                .doc(cid)
                                .update({
                              "pass": forgotNewConfirmPassController.text.trim()
                            });

                            forgotNewPassController.clear;
                            forgotNewConfirmPassController.clear();

                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      title: const Text("Succsess"),
                                      content: const Text(
                                          "Password SuccsessFully Changed"),
                                      actions: [
                                        BtnText(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                            },
                                            text: "OK")
                                      ],
                                    ));
                          } else {
                            showErrorAlertDialog(
                                context, "Error", "Please Enter Same Password");
                          }
                        }
                      },
                      child: const Text(
                        "Reset Password",
                        style: TextStyle(color: white),
                      )),
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
