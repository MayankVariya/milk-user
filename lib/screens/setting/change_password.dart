import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:milk_user/comman/widgets.dart';
import 'package:milk_user/models/customer.dart';
import 'package:milk_user/size_config.dart';
import 'package:milk_user/utils/constants.dart';

class ChangePassword extends StatefulWidget {
  final CustomerModel customer;
  const ChangePassword({super.key, required this.customer});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final changeOldPassController = TextEditingController();
  final changeNewPassController = TextEditingController();
  final changeConfirmPassController = TextEditingController();
  bool obscuredOldPass = true;
  bool obscuredNewPass = true;
  bool obscuredConfrimPass = true;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: appBar(title: labelChangePassword),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.screenWidth! * 0.1,
              vertical: SizeConfig.screenWidth! * 0.03),
          children: [
            TextFormFieldWidget(
              label: labelEnterOldPassword,
              obscureText: obscuredOldPass,
              keyboardType: TextInputType.number,
              controller: changeOldPassController,
              validator: (oldPass) {
                if (oldPass!.isEmpty) {
                  return "Please Enter Password";
                }
                return null;
              },
              suffixIcon: BtnIcon(
                  icon: obscuredOldPass ? icVisibleOff : icVisible,
                  onPressed: () {
                    setState(() {
                      obscuredOldPass = !obscuredOldPass;
                    });
                  }),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormFieldWidget(
              label: labelNewPassword,
              obscureText: obscuredNewPass,
              keyboardType: TextInputType.number,
              controller: changeNewPassController,
              validator: (newPass) {
                if (newPass!.isEmpty) {
                  return "Please Enter Password";
                } else if (newPass.length <= 6) {
                  return "Please Enter more than 6 character Password";
                }
                return null;
              },
              suffixIcon: BtnIcon(
                  icon: obscuredNewPass ? icVisibleOff : icVisible,
                  onPressed: () {
                    setState(() {
                      obscuredNewPass = !obscuredNewPass;
                    });
                  }),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormFieldWidget(
              label: labelConfirmPassword,
              obscureText: obscuredNewPass,
              keyboardType: TextInputType.number,
              controller: changeConfirmPassController,
              validator: (oldPass) {
                if (oldPass!.isEmpty) {
                  return "Please Enter Password";
                }
                return null;
              },
              suffixIcon: BtnIcon(
                  icon: obscuredConfrimPass ? icVisibleOff : icVisible,
                  onPressed: () {
                    setState(() {
                      obscuredConfrimPass = !obscuredConfrimPass;
                    });
                  }),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.screenWidth! * 0.1),
              child: BtnMaterial(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final snapshot = await FirebaseFirestore.instance
                          .collection("users")
                          .doc(widget.customer.cid)
                          .get();
                      if (snapshot.exists) {
                        final jsonString = json.encode(snapshot.data());
                        final values =
                            json.decode(jsonString) as Map<String, dynamic>;
                        CustomerModel customer = CustomerModel.fromJson(values);
                        if (changeOldPassController.text == customer.pass) {
                          if (changeNewPassController.text != customer.pass) {
                            if (changeNewPassController.text ==
                                changeConfirmPassController.text) {
                              await FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(widget.customer.cid)
                                  .update({
                                "pass": changeConfirmPassController.text.trim()
                              });
                              changeOldPassController.clear;
                              changeNewPassController.clear();
                              changeConfirmPassController.clear();
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
                              // ignore: use_build_context_synchronously
                              showErrorAlertDialog(context, "Error",
                                  "Please Enter Same Password");
                            }
                          } else {
                            // ignore: use_build_context_synchronously
                            showErrorAlertDialog(context, "Error",
                                "Please Enter different Password");
                          }
                        } else {
                          // ignore: use_build_context_synchronously
                          showErrorAlertDialog(context, "Error",
                              "Please Enter valid Old Password");
                        }
                      }
                    }
                  },
                  child: const Text(
                    btnChange,
                    style: TextStyle(color: white),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}