import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:milk_user/comman/widgets.dart';
import 'package:milk_user/models/customer.dart';
import 'package:milk_user/models/myproducts.dart';
import 'package:milk_user/screens/extra_milk/extra_milk_widget.dart';
import 'package:milk_user/size_config.dart';
import 'package:milk_user/utils/constants.dart';
import 'package:provider/provider.dart';

import '../../dark_theme_provider.dart';

const List<Widget> timing = <Widget>[
  Text('Morning'),
  Text('Evening'),
  Text('Both')
];

class ExtraMilk extends StatefulWidget {
  final CustomerModel customer;
  const ExtraMilk({super.key, required this.customer});

  @override
  State<ExtraMilk> createState() => _ExtraMilkState();
}

class _ExtraMilkState extends State<ExtraMilk> {
  double _counter = 0.0;
  void increment() {
    setState(() {
      _counter += 0.5;
    });
  }

  void decrement() {
    setState(() {
      if (_counter - 0.5 >= 0) {
        _counter -= 0.5;
      }
    });
  }

  List<bool> _selectedMilks = <bool>[false, false, false];
  isSelectedTime(int time) {
    switch (time) {
      case 1:
        return widget.customer.myproduct![0]["morningQ"];
      case 2:
        return widget.customer.myproduct![0]["eveningQ"];
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    // print(widget.customer.myproduct);
    SizeConfig().init(context);
    return Scaffold(
      // backgroundColor: white,
      appBar: appBar(title: labelExtraMilk),
      body: ListView(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.screenWidth! * 0.06,
            vertical: SizeConfig.screenHeight! * 0.015),
        children: [
          Image(
            height: SizeConfig.screenHeight! * 0.2,
            fit: BoxFit.cover,
            image: const AssetImage(extraMilk),
          ),
          SizedBox(
            height: SizeConfig.screenHeight! * 0.01,
          ),
          const Text(
            labelHeaderTitle,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: SizeConfig.screenHeight! * 0.01,
            ),
            child: const TaskTitle(text: labelSelectDate),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 4,
            shadowColor: themeChange.darkTheme ? Colors.white38 : indigo700,
            child: ListTile(
              leading: Icon(
                icCalendor,
                color: themeChange.darkTheme ? Colors.white70 : indigo700,
              ),
              title: Text(
                DateFormat('dd-MM-yyyy').format(
                  DateTime.now(),
                ),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(vertical: SizeConfig.screenHeight! * 0.02),
            child: const TaskTitle(text: labelSelectTiming),
          ),
          ToggleButtonWidget(
            isSelected: _selectedMilks,
            children: timing,
            onPressed: (int index) {
              setState(() {
                _selectedMilks =
                    List.generate(_selectedMilks.length, (index) => false);
                _selectedMilks[index] = true;
                if (DateTime.now().hour > 12) {
                  _selectedMilks[0] = false;
                  _selectedMilks[2] = false;
                }
                if (index == 0 && _selectedMilks[0]) {
                  _counter = double.parse(
                      widget.customer.myproduct![0]["morningQ"].toString());
                } else if (index == 1 && _selectedMilks[1]) {
                  _counter = double.parse(
                      widget.customer.myproduct![0]["eveningQ"].toString());
                } else if (index == 2 && _selectedMilks[2]) {
                  _counter = 0.0;
                }
              });
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.screenHeight! * 0.025),
            child: const TaskTitle(text: labelQuentityInLiters),
          ),
          AddTask(
              increment: increment, decrement: decrement, text: "$_counter"),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.screenHeight! * 0.035),
            child: TotalTask(ltr: _counter),
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth! * 0.1),
            child: BtnMaterial(
                onPressed: () async {
                  final updatedMorningMyProduct = SelectedProductModel(
                      price: widget.customer.myproduct![0]["price"],
                      product: widget.customer.myproduct![0]["product"],
                      morningQ: _counter,
                      eveningQ: _counter,
                      type: widget.customer.myproduct![0]["type"]);
                  final updatedEveningMyProduct = SelectedProductModel(
                      price: widget.customer.myproduct![0]["price"],
                      product: widget.customer.myproduct![0]["product"],
                      morningQ: widget.customer.myproduct![0]["morningQ"],
                      eveningQ: _counter,
                      type: widget.customer.myproduct![0]["type"]);
                  // final updatedBothMyProduct=SelectedProductModel(
                  //     price:widget.customer.myproduct![0]["price"] ,
                  //     product:widget.customer.myproduct![0]["product"] , morningQ:_counter , eveningQ:
                  // _counter , type: widget.customer.myproduct![0]["type"]);
                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(widget.customer.cid)
                      .update({
                    "myproduct": [
                      _selectedMilks[0]
                          ? updatedMorningMyProduct.toMap()
                          : _selectedMilks[1]
                              ? updatedEveningMyProduct.toMap()
                              : _selectedMilks[2]
                                  ? updatedMorningMyProduct.toMap()
                                  : ""
                    ]
                  });

                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop(widget.customer);
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Your Quentity Updated Succsessfully")));
                },
                child: const Text(
                  btnAddExtraMilk,
                  style: TextStyle(color: white),
                )),
          )
        ],
      ),
    );
  }
}
