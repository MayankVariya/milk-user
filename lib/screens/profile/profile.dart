import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:milk_user/comman/widgets.dart';
import 'package:milk_user/models/customer.dart';
import 'package:milk_user/size_config.dart';
import 'package:milk_user/utils/constants.dart';
import 'package:provider/provider.dart';
import '../../dark_theme_provider.dart';
import 'profile_widget.dart';

// ignore: must_be_immutable
class MyProfile extends StatefulWidget {
  CustomerModel customer;
  MyProfile({super.key, required this.customer});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final otp = TextEditingController();
  File? imageFile;
  bool isEdit = false;
  FirebaseAuth auth = FirebaseAuth.instance;

  void selectImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      cropImage(pickedFile);
    }
  }

  void cropImage(XFile file) async {
    File? croppedImage = await ImageCropper.cropImage(
        sourcePath: file.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 20);

    if (croppedImage != null) {
      // ignore: use_build_context_synchronously

      Reference ref = FirebaseStorage.instance
          .ref()
          .child('users_profile_pics/${widget.customer.cid}.jpg');
      TaskSnapshot task = await ref.putFile(croppedImage);
      final imageUrl = await task.ref.getDownloadURL();
      updateProfile(widget.customer.cid!, "cProfilePic", imageUrl);
      setState(() {
        imageFile = croppedImage;
        widget.customer.cProfilePic = imageUrl;
        isEdit = false;
      });
    }
  }

  void showPhotoOptions() {
    showAlertDialog(context,
        barrierDismissible: true,
        title: labelPhotoOptionTitle,
        children: [
          NavListTileWidget(
              onTap: () {
                Navigator.pop(context);
                selectImage(ImageSource.gallery);
              },
              leading: const Icon(icPhotoOptionGallary),
              title: labelPhotoOptionGallary),
          NavListTileWidget(
              onTap: () {
                Navigator.pop(context);
                selectImage(ImageSource.camera);
              },
              leading: const Icon(icPhotoOptionCamera),
              title: labelPhotoOptionCamera)
        ]);
  }

  Future<void> updateProfile(String cid, String key, dynamic value) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(cid)
        .update({key: value});
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    SizeConfig().init(context);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: indigo700),
    );
    return WillPopScope(
      onWillPop: (() async => false),
      child: Scaffold(
        body: CirclesBackground(
          topMediumWidth: SizeConfig.screenWidth! * 1.76, //660,
          topMediumHight: SizeConfig.screenHeight! * 0.87, //660,
          topMediumTop: SizeConfig.screenHeight! * -0.570, //-432,
          topMediumLeft: SizeConfig.screenWidth! * -0.41,
          backgroundColor: themeChange.darkTheme ? black : white,
          topSmallCircleColor: indigo700,
          topMediumCircleColor: indigo700,
          topRightCircleColor: themeChange.darkTheme ? black : white,
          bottomRightCircleColor: themeChange.darkTheme ? black : white,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            children: [
              const SizedBox(
                height: 10,
              ),
              buildBackButton(context, icon: icBack, backButton: () {
                Navigator.of(context).pop(widget.customer);
              }),
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 25),
                child: ProfileWidget(
                  imagePath: widget.customer.cProfilePic!.isEmpty
                      ? ""
                      : widget.customer.cProfilePic!,
                  fillProfile: false,
                  isEdit: isEdit,
                  onClicked: () {
                    showPhotoOptions();
                  },
                ),
              ),
              Center(
                child: Text(
                  widget.customer.id.toString(),
                  style: TextStyle(
                      color: themeChange.darkTheme ? white : black,
                      fontSize: 14,
                      fontWeight: bold),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ListTileWidget(
                title: labelName,
                leading: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.screenHeight! * 0.025),
                  child: const Icon(icperson),
                ),
                subTitle: widget.customer.cName,
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                      title: const Text("Edit"),
                      content: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormFieldWidget(
                              label: labelEditName,
                              autoFocus: true,
                              controller: editNameController,
                              validator: (name) {
                                return name!.isEmpty
                                    ? "Please enter FullName"
                                    : null;
                              },
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        const BtnCancel(),
                        BtnText(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                setState(() {
                                  widget.customer.cName =
                                      editNameController.text;
                                });
                                Navigator.of(context).pop();
                                updateProfile(widget.customer.cid!, "cName",
                                    editNameController.text.trim());
                                editNameController.clear();
                              }
                            },
                            text: btnSave)
                      ],
                    ),
                  );
                },
                trailing: Icon(
                  icEdit,
                  color: themeChange.darkTheme ? Colors.white70 : indigo700,
                ),
              ),
              ListTileWidget(
                title: labelMobileNumber,
                leading: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.screenHeight! * 0.025),
                  child: Icon(icPhone),
                ),
                subTitle: widget.customer.cContactNumber,
                trailing: widget.customer.verified == true
                    ? const Icon(Icons.done)
                    : BtnText(
                        onPressed: () async {
                          try {
                            auth.verifyPhoneNumber(
                              phoneNumber:
                                  "+91${widget.customer.cContactNumber}",
                              verificationCompleted:
                                  (phoneAuthCredential) async {
                                await auth
                                    .signInWithCredential(phoneAuthCredential);
                              },
                              verificationFailed: (error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(error.toString())));
                              },
                              codeSent: (verificationId, forceResendingToken) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title:
                                        const Text("Enter Verification Code"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextFormField(
                                          controller: otp,
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            labelText: "Verification code",
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () async {
                                            PhoneAuthCredential credential =
                                                PhoneAuthProvider.credential(
                                              verificationId: verificationId,
                                              smsCode: otp.text,
                                            );
                                            await auth.signInWithCredential(
                                                credential);

                                            setState(() {
                                              widget.customer.verified = true;
                                            });
                                            // ignore: use_build_context_synchronously
                                            Navigator.of(context).pop();
                                            // ignore: use_build_context_synchronously
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        "Verification Successfully Complited")));
                                            updateProfile(widget.customer.cid!,
                                                "verified", true);
                                          },
                                          child: const Text("Verify"))
                                    ],
                                  ),
                                );
                              },
                              codeAutoRetrievalTimeout: (verificationId) {},
                            );
                          } catch (e) {
                            showErrorAlertDialog(context, "Error", "$e");
                          }
                        },
                        text: "Verify"),
              ),
              ListTileWidget(
                title: labelEmail,
                leading: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.screenHeight! * 0.025),
                  child: Icon(icEmail),
                ),
                subTitle: widget.customer.cEmail,
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                      title: const Text("Edit"),
                      content: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormFieldWidget(
                              label: labelEditEmail,
                              autoFocus: true,
                              controller: editEmailController,
                              validator: (email) {
                                return validateEmail(email!);
                              },
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        const BtnCancel(),
                        BtnText(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                setState(() {
                                  widget.customer.cEmail =
                                      editEmailController.text;
                                });
                                Navigator.of(context).pop();
                                updateProfile(widget.customer.cid!, "cEmail",
                                    editEmailController.text.trim());
                                editEmailController.clear();
                              }
                            },
                            text: btnSave)
                      ],
                    ),
                  );
                },
                trailing: Icon(
                  icEdit,
                  color: themeChange.darkTheme ? Colors.white70 : indigo700,
                ),
              ),
              ListTileWidget(
                title: labelAddress,
                leading: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.screenHeight! * 0.025),
                  child: Icon(icAddress),
                ),
                subTitle: widget.customer.cAddress,
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                      title: const Text("Edit"),
                      content: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormFieldWidget(
                              label: labelEditAddress,
                              autoFocus: true,
                              controller: editAddressController,
                              validator: (address) {
                                return validateAddress(address!);
                              },
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        const BtnCancel(),
                        BtnText(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                setState(() {
                                  widget.customer.cAddress =
                                      editAddressController.text;
                                });
                                Navigator.of(context).pop();
                                updateProfile(widget.customer.cid!, "cName",
                                    editAddressController.text.trim());
                                editAddressController.clear();
                              }
                            },
                            text: btnSave)
                      ],
                    ),
                  );
                },
                trailing: Icon(
                  icEdit,
                  color: themeChange.darkTheme ? Colors.white70 : indigo700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Reset the status bar color when the widget is disposed
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    super.dispose();
  }
}
