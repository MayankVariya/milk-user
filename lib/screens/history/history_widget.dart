import 'package:flutter/material.dart';
import 'package:milk_user/comman/appbar.dart';
import 'package:milk_user/models/history.dart';
import 'package:milk_user/size_config.dart';
import 'package:milk_user/utils/colors.dart';
import 'package:provider/provider.dart';

import '../../dark_theme_provider.dart';

class MonthData extends StatefulWidget {
  final MonthDataModel month;
  const MonthData({super.key, required this.month});

  @override
  State<MonthData> createState() => _MonthDataState();
}

class _MonthDataState extends State<MonthData> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    // print("");
    SizeConfig().init(context);
    return Scaffold(
      appBar: appBar(title: widget.month.monthName.toString()),
      body: ListView(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.screenWidth! * 0.07,
            vertical: SizeConfig.screenHeight! * 0.02),
        children: [
          DataTable(
            dataRowHeight: SizeConfig.screenHeight! * 0.05,
            showBottomBorder: true,
            headingRowColor: MaterialStateProperty.all(indigo700),
            headingTextStyle:
                const TextStyle(color: white, fontWeight: FontWeight.bold),
            columnSpacing: 30,
            columns: const [
              DataColumn(label: Text("Date")),
              DataColumn(label: Text("Morning")),
              DataColumn(label: Text("Evening")),
            ],
            rows: List.generate(
              widget.month.dates!.length,
              (index) => DataRow(
                color: themeChange.darkTheme
                    ? (MaterialStateColor.resolveWith((states) =>
                        (widget.month.dates![index].day == "TotalMilk") ||
                                (widget.month.dates![index].day ==
                                    "TotalAmount")
                            ? Colors.white12
                            : black))
                    : (MaterialStateColor.resolveWith((states) =>
                        (widget.month.dates![index].day == "TotalMilk") ||
                                (widget.month.dates![index].day ==
                                    "TotalAmount")
                            ? grey300
                            : white)),
                cells: [
                  DataCell(Text(
                    widget.month.dates![index].day ?? "",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: themeChange.darkTheme
                            ? ((widget.month.dates![index].day ==
                                        "TotalMilk") ||
                                    (widget.month.dates![index].day ==
                                        "TotalAmount")
                                ? indigo700
                                : white)
                            : ((widget.month.dates![index].day ==
                                        "TotalMilk") ||
                                    (widget.month.dates![index].day ==
                                        "TotalAmount")
                                ? indigo700
                                : black)),
                  )),
                  DataCell(Center(
                      child: Text(
                    widget.month.dates![index].morning ?? "",
                    style: TextStyle(
                        fontWeight:
                            (widget.month.dates![index].day == "TotalMilk") ||
                                    (widget.month.dates![index].day ==
                                        "TotalAmount")
                                ? FontWeight.bold
                                : FontWeight.normal,
                        color: themeChange.darkTheme
                            ? ((widget.month.dates![index].day ==
                                        "TotalMilk") ||
                                    (widget.month.dates![index].day ==
                                        "TotalAmount")
                                ? indigo700
                                : white)
                            : ((widget.month.dates![index].day ==
                                        "TotalMilk") ||
                                    (widget.month.dates![index].day ==
                                        "TotalAmount")
                                ? indigo700
                                : black)),
                  ))),
                  DataCell(
                    Center(
                      child: Text(
                        widget.month.dates![index].evening ?? "",
                        style: TextStyle(
                            fontWeight: (widget.month.dates![index].day ==
                                        "TotalMilk") ||
                                    (widget.month.dates![index].day ==
                                        "TotalAmount")
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: themeChange.darkTheme?((widget.month.dates![index].day ==
                                        "TotalMilk") ||
                                    (widget.month.dates![index].day ==
                                        "TotalAmount")
                                ? indigo700
                                : (widget.month.dates![index].evening ==
                                        "pending")
                                    ? red
                                    : white):((widget.month.dates![index].day ==
                                        "TotalMilk") ||
                                    (widget.month.dates![index].day ==
                                        "TotalAmount")
                                ? indigo700
                                : (widget.month.dates![index].evening ==
                                        "pending")
                                    ? red
                                    : black)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
