import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:milk_user/comman/widgets.dart';
import 'package:milk_user/models/customer.dart';
import 'package:milk_user/models/myproducts.dart';
import 'package:milk_user/network/helper.dart';
import 'package:milk_user/network/share_preferences.dart';
import 'package:milk_user/screens/contact_us/contact_us.dart';
import 'package:milk_user/screens/extra_milk/extra_milk.dart';
import 'package:milk_user/screens/history/history.dart';
import 'package:milk_user/screens/homepage/body.dart';
import 'package:milk_user/screens/loginpage/login_screen.dart';
import 'package:milk_user/screens/myproducts/myproduct.dart';
import 'package:milk_user/screens/payment/payment.dart';
import 'package:milk_user/screens/profile/profile.dart';
import 'package:milk_user/screens/setting/settings_screen.dart';
import 'package:milk_user/size_config.dart';
import 'package:milk_user/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../dark_theme_provider.dart';
import 'home_page_widget.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  CustomerModel? customer;
  HomePage({
    Key? key,
    required this.customer,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final editMorningQuentity = TextEditingController();
  final editEveningQuentity = TextEditingController();

  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final currantUser = prefs.getString("cUser");
    CustomerModel? user =
        await FirebaseHelper.getUserModelByProfile(currantUser!);
    setState(() {
      widget.customer = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<DarkThemeProvider>(context);

    // print(widget.customer);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: indigo700),
    );
    SizeConfig().init(context);
    return AdvancedDrawer(
      backdropColor: indigo700,
      controller: advancedDrawerController,
      // animationCurve: Curves.easeInOutBack,
      // animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
      ),
      drawer: SafeArea(
        child: ListTileTheme(
          iconColor: white,
          textColor: white,
          child: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            physics: const BouncingScrollPhysics(),
            children: [
              customProfileCircle(widget.customer!.cProfilePic!),
              Center(
                child: Text(
                  widget.customer!.cName.toString(),
                  style: drawerUserNameTextStyle(),
                ),
              ),
              SizedBox(
                height: SizeConfig.screenHeight! * 0.01,
              ),
              Center(
                child: Text(
                  widget.customer!.id.toString(),
                  style: drawerUserIdTextStyle(),
                ),
              ),
              const Divider(
                indent: 15,
                color: white,
              ),
              NavListTileWidget(
                leading: const Icon(icProfile),
                title: labelDrawerProfile,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MyProfile(customer: widget.customer!),
                      )).then((value) {
                    setState(() {
                      widget.customer = value;
                    });
                  });
                },
              ),
              NavListTileWidget(
                leading: const Icon(icProduct),
                title: labelDrawerMyProduct,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MyProduct(customer: widget.customer!),
                      ));
                },
              ),
              NavListTileWidget(
                leading: const Icon(icPayment),
                title: labelDrawerPayment,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyPayment(
                          user: widget.customer!,
                        ),
                      ));
                },
              ),
              NavListTileWidget(
                leading: const Icon(icHistory),
                title: labelDrawerHistory,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyHistory(user: widget.customer!),
                      ));
                },
              ),
              NavListTileWidget(
                leading: const Icon(icSetting),
                title: labelDrawerSetting,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SettingScreen(customer: widget.customer!),
                      ));
                },
              ),
              const Divider(
                indent: 15,
                color: white,
              ),
              NavListTileWidget(
                leading: const Icon(icContactUs),
                title: labelDrawerContactUs,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ContectUs(),
                      ));
                },
              ),
              NavListTileWidget(
                leading: const Icon(icLogout),
                title: labelDrawerLogout,
                onTap: () async {
                  await removeLoginCredentials();

                  // ignore: use_build_context_synchronously
                  Navigator.popUntil(context, (route) => route.isFirst);
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ));
                },
              ),
            ],
          ),
        ),
      ),
      child: Scaffold(
        appBar: customAppBar(widget.customer!.cName.toString(), actions: [
          DataTable(
              dividerThickness: 0,
              columnSpacing: MediaQuery.of(context).size.height / 43,
              dataRowHeight: MediaQuery.of(context).size.height / 30,
              headingRowHeight: MediaQuery.of(context).size.height / 40,
              horizontalMargin: MediaQuery.of(context).size.height / 50,
              headingTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 13, color: white),
              dataTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 15, color: white),
              columns: const [
                DataColumn(label: Text("Morning")),
                DataColumn(label: Text("Evening"))
              ],
              rows: [
                DataRow(cells: [
                  DataCell(GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          title: const Text("Edit Milk Quentity"),
                          content: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormFieldWidget(
                                  label: "Morning",
                                  controller: editMorningQuentity,
                                  suffixText: "Per/LTR",
                                  maxLength: 3,
                                  autoFocus: true,
                                  keyboardType: TextInputType.number,
                                  validator: (editMorning) =>
                                      editMorning!.isEmpty
                                          ? "Please Enter Quentity"
                                          : null,
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            const BtnCancel(),
                            BtnText(
                                onPressed: () async {
                                  setState(() {
                                    widget.customer!.myproduct![0]["morningQ"] =
                                        double.parse(
                                            editMorningQuentity.text.trim());
                                  });
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).pop();
                                  final updatedMyProduct = SelectedProductModel(
                                      price: widget.customer!.myproduct![0]
                                          ["price"],
                                      product: widget.customer!.myproduct![0]
                                          ["product"],
                                      morningQ: double.parse(
                                          editMorningQuentity.text.trim()),
                                      eveningQ: widget.customer!.myproduct![0]
                                          ["eveningQ"],
                                      type: widget.customer!.myproduct![0]
                                          ["type"]);
                                  await FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(widget.customer!.cid)
                                      .update({
                                    "myproduct": [updatedMyProduct.toMap()]
                                  });
                                  editMorningQuentity.clear();
                                },
                                text: btnChange)
                          ],
                        ),
                      );
                    },
                    child: Center(
                      child: Text(widget.customer!.myproduct!.isNotEmpty
                          ? widget.customer!.myproduct![0]["morningQ"]
                              .toString()
                          : ""),
                    ),
                  )),
                  DataCell(Center(
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            title: const Text("Edit Milk Quentity"),
                            content: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormFieldWidget(
                                    label: "Evening",
                                    controller: editEveningQuentity,
                                    suffixText: "Per/LTR",
                                    maxLength: 3,
                                    autoFocus: true,
                                    keyboardType: TextInputType.number,
                                    validator: (editEvening) =>
                                        editEvening!.isEmpty
                                            ? "Please Enter Quentity"
                                            : null,
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              const BtnCancel(),
                              BtnText(
                                  onPressed: () async {
                                    setState(() {
                                      widget.customer!.myproduct![0]
                                              ["eveningQ"] =
                                          double.parse(
                                              editEveningQuentity.text.trim());
                                    });
                                    // ignore: use_build_context_synchronously
                                    Navigator.of(context).pop();
                                    final updatedMyProduct =
                                        SelectedProductModel(
                                            price: widget.customer!.myproduct![
                                                0]["price"],
                                            product: widget
                                                    .customer!.myproduct![0][
                                                "product"],
                                            morningQ: widget
                                                    .customer!.myproduct![0][
                                                "morningQ"],
                                            eveningQ: double
                                                .parse(editEveningQuentity
                                                    .text
                                                    .trim()),
                                            type: widget.customer!.myproduct![0]
                                                ["type"]);
                                    await FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(widget.customer!.cid)
                                        .update({
                                      "myproduct": [updatedMyProduct.toMap()]
                                    });
                                    editEveningQuentity.clear();
                                  },
                                  text: btnChange)
                            ],
                          ),
                        );
                      },
                      child: Text(widget.customer!.myproduct!.isNotEmpty
                          ? widget.customer!.myproduct![0]["eveningQ"]
                              .toString()
                          : ""),
                    ),
                  ))
                ])
              ])
        ]),
        body: HomePageBodyWidget(customer: widget.customer!, function: getData),
        floatingActionButton: FloatingActionButton.extended(
            heroTag: "EditMilk",
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExtraMilk(
                      customer: widget.customer!,
                    ),
                  ));
            },
            backgroundColor: indigo700,
            label: const Text(
              labelExtraMilk,
              style: TextStyle(color: white),
            )),
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
