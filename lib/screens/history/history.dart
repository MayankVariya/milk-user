import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:milk_user/comman/widgets.dart';
import 'package:milk_user/models/customer.dart';
import 'package:milk_user/models/history.dart';
import 'package:milk_user/models/monthname.dart';
import 'package:milk_user/size_config.dart';
import 'package:milk_user/utils/constants.dart';

import 'history_widget.dart';

class MyHistory extends StatefulWidget {
  final CustomerModel user;
  const MyHistory({super.key, required this.user});

  @override
  State<MyHistory> createState() => _MyHistoryState();
}

class _MyHistoryState extends State<MyHistory> {
  String currantYear = DateTime.now().year.toString();
  String currantMonth = DateFormat('MMMM').format(DateTime.now());
  int currantDate = DateTime.now().day;
  //final ref=FirebaseDatabase.instance.ref("AdminName/${widget.user.cid}/$currantYear");

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: appBar(title: labelDrawerHistory),
      body: StreamBuilder(
        stream: FirebaseDatabase.instance
            .ref("AdminName/${widget.user.cid}/$currantYear")
            .onValue,
        builder: (context, AsyncSnapshot snapshot) {
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
          List<MonthDataModel> months = [];

          if (snapshot.hasData && snapshot.data != null) {
            if (snapshot.data!.snapshot.value != null) {
              final jsonString = json.encode(snapshot.data!.snapshot.value);
              final values = json.decode(jsonString) as Map<String, dynamic>;

              values.forEach((key, value) {
                // print(key);
                //print(value);
                List<DateData> dates = [];
                value.forEach(
                  (key, value) {
                    if (value != "" &&
                        key != "totalMilk" &&
                        key != "totalAmount" &&
                        key != "payment") {
                      dates.insert(
                          dates.length,
                          DateData(
                              day: value["Date"].toString(),
                              morning: value["morning"].toString(),
                              evening: value["evening"].toString()));
                      dates.sort(
                        (a, b) => a.day!.compareTo(b.day.toString()),
                      );
                    }
                  },
                );
                if (value["totalMilk"] != null) {
                  dates.insert(
                      dates.length,
                      DateData(
                          day: value["totalMilk"]["Date"].toString(),
                          morning: value["totalMilk"]["morning"].toString(),
                          evening: value["totalMilk"]["evening"].toString()));
                }
                if (value["totalAmount"] != null) {
                  dates.insert(
                      dates.length,
                      DateData(
                          day: value["totalAmount"]["Date"].toString(),
                          morning: value["totalAmount"]["morning"].toString(),
                          evening: value["totalAmount"]["evening"].toString()));
                }

                if (value["payment"] != null) {
                  dates.insert(
                      dates.length,
                      DateData(
                          day: value["payment"]["title"].toString(),
                          morning:
                              value["payment"]["isPaymentMethod"].toString(),
                          evening:
                              value["payment"]["isPaymentStatus"].toString()));
                }

                if (value != "") {
                  months.add(MonthDataModel(
                      monthName: month(int.parse(key)), dates: dates));
                }
              });
            } else {
              return const Center(
                child: Text("No Any Data"),
              );
            }
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.screenWidth! * 0.036,
                vertical: SizeConfig.screenWidth! * 0.03),
            itemCount: months.length,
            itemBuilder: (context, index) {
              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 3,
                shadowColor: indigo700,
                child: NavListTileWidget(
                    leading: Padding(
                      padding: EdgeInsets.all(SizeConfig.defaultSize! * 0.5),
                      child: Text(
                        "${index + 1}.",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: months[index].monthName.toString(),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MonthData(month: months[index]),
                          ));
                    }),
              );
            },
          );
        },
      ),
    );
  }
}
