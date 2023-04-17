import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:milk_user/models/customer.dart';
import 'package:milk_user/models/reports.dart';
import 'package:milk_user/screens/myproducts/myproduct.dart';
import 'package:milk_user/screens/payment/payment.dart';
import 'package:milk_user/size_config.dart';
import 'package:milk_user/utils/constants.dart';
import 'package:provider/provider.dart';

import '../../dark_theme_provider.dart';

// ignore: must_be_immutable
class HomePageBodyWidget extends StatefulWidget {
  final CustomerModel customer;
  VoidCallback function;

  HomePageBodyWidget(
      {super.key, required this.customer, required this.function});

  @override
  State<HomePageBodyWidget> createState() => _HomePageBodyWidgetState();
}

class _HomePageBodyWidgetState extends State<HomePageBodyWidget> {
  int currantYear = DateTime.now().year;
  int currantMonth = DateTime.now().month;
  int currantDate = DateTime.now().day;
  int cuMonth = DateTime.now().month;
  bool isPaymentStatus = false;

  isMonthComplitedTotal() async {
    double morningTotal = 0.0;
    double eveningTotal = 0.0;
    double total = 0.0;
    double totalAmount = 0.0;

    final ref = FirebaseDatabase.instance.ref(
        "AdminName/${widget.customer.cid}/$currantYear/${currantMonth - 1}");

    if (currantDate == 1) {
      final event = await ref.once();

      if (event.snapshot.value != null) {
        final jsonString = json.encode(event.snapshot.value);
        final values = json.decode(jsonString) as Map<String, dynamic>;
        morningTotal = 0.0;
        eveningTotal = 0.0;
        values.forEach((key, value) {
          if (key != "totalMilk" && key != "totalAmount" && key != "payment") {
            morningTotal += double.parse(value["morning"].toString());
            eveningTotal += double.parse(value["evening"].toString());
          }
        });
        total = morningTotal + eveningTotal;
        totalAmount =
            total * double.parse(widget.customer.myproduct![0]["price"]);
        await ref.child("totalMilk").update({
          "Date": "TotalMilk",
          "morning": morningTotal.toString(),
          "evening": eveningTotal.toString(),
        });
        await ref.child("totalAmount").update({
          "Date": "TotalAmount",
          "morning":
              "$total * ${double.parse(widget.customer.myproduct![0]["price"])}",
          "evening": totalAmount.toString(),
        });
        await ref.child("payment").update({
          "title": "Payment",
          "isPaymentMethod": "",
          "isPaymentStatus": "pending",
          "transactionId": "",
          "transactionDate": ""
        });
      }
    }
  }

  getTransaction() async {
    final event = await FirebaseDatabase.instance
        .ref("AdminName/${widget.customer.cid}/$currantYear")
        .once();
    if (event.snapshot.value != null) {
      final jsonString = json.encode(event.snapshot.value);
      final values = json.decode(jsonString) as Map<String, dynamic>;
      values.forEach((key, value) {
        if (value["payment"] != null &&
            value["payment"]["isPaymentStatus"] != null) {
          isPaymentStatus =
              value["payment"]["isPaymentStatus"] == "pending" ? true : false;
        }
      });
    }
  }

  @override
  void initState() {
    isMonthComplitedTotal();
    getTransaction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    SizeConfig().init(context);

    return RefreshIndicator(
      onRefresh: () {
        return Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            getTransaction();
          });
        });
      },
      child: StreamBuilder(
          stream: FirebaseDatabase.instance
              .ref(
                  "AdminName/${widget.customer.cid}/$currantYear/$currantMonth")
              .onValue,
          builder: (context, snapshot) {
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

            List<MyData> myDatas = [];
            if (snapshot.hasData && snapshot.data != null) {
              final jsonString = json.encode(snapshot.data!.snapshot.value);
              final values = json.decode(jsonString);

              if (values != null) {
                values.forEach((key, value) {
                  myDatas.add(MyData(
                      day: value["Date"].toString(),
                      morning: value["morning"].toString(),
                      evening: value["evening"].toString()));
                  myDatas.sort(
                    (a, b) => a.day!.compareTo(b.day.toString()),
                  );
                });
              }
            }

            return widget.customer.myproduct!.isNotEmpty
                ? ListView(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.screenWidth! * 0.05,
                        vertical: SizeConfig.screenHeight! * 0.02),
                    children: [
                      isPaymentStatus
                          ? Container(
                              padding: const EdgeInsets.all(10),
                              margin: EdgeInsets.only(
                                  bottom: SizeConfig.screenHeight! * 0.01),
                              height: SizeConfig.screenHeight! * 0.10,
                              decoration: BoxDecoration(
                                  color: red,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          "Payment Alert ",
                                          style: TextStyle(
                                              color: white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text("Remaining Status : pending",
                                            style: TextStyle(
                                                color: white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                  MaterialButton(
                                    color: white,
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MyPayment(
                                              user: widget.customer,
                                            ),
                                          ));
                                    },
                                    child: const Text(
                                      "PAY NOW",
                                      style: TextStyle(color: red),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : const SizedBox(),
                      Text(
                        "Selected Milk : ${widget.customer.myproduct![0]["type"]}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      myDatas.isNotEmpty
                          ? DataTable(
                              dataRowHeight: SizeConfig.screenHeight! * 0.05,
                              showBottomBorder: true,
                              headingRowColor:
                                  MaterialStateProperty.all(indigo700),
                              headingTextStyle: const TextStyle(
                                  color: white, fontWeight: FontWeight.bold),
                              columnSpacing: 60,
                              columns: const [
                                DataColumn(label: Text("Date")),
                                DataColumn(label: Text("Morning")),
                                DataColumn(label: Text("Evening")),
                              ],
                              rows: List.generate(
                                myDatas.length,
                                (index) => DataRow(
                                  cells: [
                                    DataCell(Center(
                                      child: Text(
                                        myDatas[index].day.toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                                    DataCell(Center(
                                        child: Text(
                                            myDatas[index].morning ?? ""))),
                                    DataCell(Center(
                                        child:
                                            Text(myDatas[index].evening ?? "")))
                                  ],
                                ),
                              ),
                              dividerThickness:
                                  themeChange.darkTheme ? 2.5 : 0.5,
                            )
                          : const SizedBox(),
                    ],
                  )
                : Center(
                    child: GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MyProduct(customer: widget.customer),
                        )).then(
                      (value) => widget.function(),
                    ),
                    child: const Text(
                      "Please select Product",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ));
          }),
    );
  }
}
