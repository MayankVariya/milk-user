import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:milk_user/models/customer.dart';
import 'package:milk_user/models/myproducts.dart';
import 'package:milk_user/models/product.dart';
import 'package:milk_user/size_config.dart';
import 'package:milk_user/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../comman/widgets.dart';
import '../../dark_theme_provider.dart';

class MyProduct extends StatefulWidget {
  final CustomerModel customer;
  const MyProduct({super.key, required this.customer});

  @override
  State<MyProduct> createState() => _MyProductState();
}

class _MyProductState extends State<MyProduct> {
  ProductModel productModel=ProductModel(key: "", type: "", price: "");
  bool isLoading = false;

  List type = ["Morning", "Evening"];
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  saveProduct(ProductModel product) async {
    double morningQuantity = double.parse(morningQController.text.trim());
    double eveningQuantity = double.parse(eveningQController.text.trim());
    try {
      final myproduct = SelectedProductModel(
          product: product.key!,
          type: product.type!,
          price: product.price.toString(),
          morningQ: morningQuantity,
          eveningQ: eveningQuantity);
      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.customer.cid)
          .update({
        "myproduct": [myproduct.toMap()]
      });
    } catch (e) {
      showErrorAlertDialog(context, "Error", "$e");
    }
  }

  getUserProduct() async {
    final ref = FirebaseFirestore.instance
        .collection("users")
        .doc(widget.customer.cid)
        .get();
    await ref.then((snapshot) {
      final data = snapshot.data();
      if (data!["myproduct"].length != 0) {
       // print(data["myproduct"][0]["product"]);
        productModel = ProductModel(key: data["myproduct"][0]["product"], type: data["myproduct"][0]["type"], price: data["myproduct"][0]["price"]);
      }
    });
    setState(() {
      isLoading = false;
    });

  }

  @override
  void initState() {
    isLoading = true;
    getUserProduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange= Provider.of<DarkThemeProvider>(context);
    SizeConfig().init(context);
    return Scaffold(
      appBar: appBar(title: labelDrawerMyProduct),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("admin")
            .doc("products")
            .collection("product")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final products = snapshot.data!.docs
              .map((doc) =>
                  ProductModel.fromJson(doc.data() as Map<String, dynamic>))
              .toList();

          if (products.isEmpty) {
            return const Center(
              child: Text(
                "Product Not Available",
              ),
            );
          }

          return isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.screenWidth! * 0.04),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      elevation: 4,
                      shadowColor:
                          themeChange.darkTheme?(products[index].isSelected!?Colors.white38:indigo700):(products[index].isSelected! ? indigo700 : white),
                      margin: EdgeInsets.symmetric(
                          vertical: SizeConfig.screenHeight! * 0.007),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        leading: CircleAvatar(
                          backgroundColor:
                             themeChange.darkTheme?(productModel.key == products[index].key
                                  ? white
                                  : Colors.white70): (productModel.key == products[index].key
                                  ? white
                                  : indigo700),
                          child: Text(
                            "${index + 1}",
                            style: TextStyle(
                                color:themeChange.darkTheme?( productModel.key == products[index].key
                                    ? black
                                    : black):( productModel.key == products[index].key
                                    ? black
                                    : white),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(
                          products[index].type!,
                          style: TextStyle(
                              color: themeChange.darkTheme?(productModel.key == products[index].key
                                  ? white
                                  : white):(productModel.key == products[index].key
                                  ? white
                                  : black),
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "Price :${products[index].price}",
                          style: TextStyle(
                              color: themeChange.darkTheme?(productModel.key == products[index].key
                                  ? white
                                  : white54):(productModel.key == products[index].key
                                  ? white
                                  : grey700),
                              fontWeight: FontWeight.bold),
                        ),
                        enabled: true,
                        tileColor: themeChange.darkTheme?(productModel.key == products[index].key
                            ? indigo700
                            : Colors.white12):(productModel.key == products[index].key
                            ? indigo700
                            : white),
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                title: const Text(labelMilkQuintity),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Form(
                                        key: formKey,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            SizedBox(
                                              width: SizeConfig.screenWidth! *
                                                  0.28,
                                              child: TextFormFieldWidget(
                                                label: type[0],
                                                keyboardType:
                                                    TextInputType.number,
                                                controller: morningQController,
                                                autoFocus: true,
                                                maxLength: 2,
                                                validator: (morning) {
                                                  if (morning!.isEmpty) {
                                                    return "Please Enter Morning Milk Quantity";
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              width: SizeConfig.screenWidth! *
                                                  0.28,
                                              child: TextFormFieldWidget(
                                                label: type[1],
                                                keyboardType:
                                                    TextInputType.number,
                                                controller: eveningQController,
                                                maxLength: 2,
                                                validator: (morning) {
                                                  if (morning!.isEmpty) {
                                                    return "Please Enter Evening Milk Quantity";
                                                  }
                                                  return null;
                                                },
                                              ),
                                            )
                                          ],
                                        )),
                                  ],
                                ),
                                actions: [
                                  const BtnCancel(),
                                  BtnText(
                                      onPressed: () async {
                                        if (formKey.currentState!.validate()) {
                                          saveProduct(products[index]);
                                          final prefs = await SharedPreferences.getInstance();
                                          await prefs.setDouble("morningQ", double.parse(morningQController.text));
                                          await prefs.setDouble("eveningQ", double.parse(eveningQController.text));
                                          morningQController.clear();
                                          eveningQController.clear();
                                          // ignore: use_build_context_synchronously
                                          Navigator.of(context)
                                              .pop(products[index]);
                                        }
                                      },
                                      text: btnSave)
                                ]),
                          ).then((value) {
                            if (value != null) {
                              productModel = value;
                              setState(() {});
                            }
                          });
                        },
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
