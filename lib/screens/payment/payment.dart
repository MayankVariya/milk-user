import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:milk_user/comman/appbar.dart';
import 'package:milk_user/comman/dialogs.dart';
import 'package:milk_user/comman/list_tile.dart';
import 'package:milk_user/models/customer.dart';
import 'package:milk_user/models/monthname.dart';
import 'package:milk_user/models/payment.dart';
import 'package:milk_user/size_config.dart';
import 'package:milk_user/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../dark_theme_provider.dart';

class MyPayment extends StatefulWidget {
  final CustomerModel user;
  const MyPayment({
    super.key,
    required this.user,
  });

  @override
  State<MyPayment> createState() => _MyPaymentState();
}

Razorpay _razorpay = Razorpay();

class _MyPaymentState extends State<MyPayment> {
  String currantYear = DateTime.now().year.toString();
  String currantMonth = DateTime.now().month.toString();
  String transactionDate=DateFormat('dd-MM-yyyy').format(DateTime.now());
  double amount = 0.0;
  int monthKey=0;


  @override
  void initState() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }


  void _handlePaymentSuccess(PaymentSuccessResponse response) async{
    // Do something when payment succeeds

  final instance=FirebaseDatabase.instance;
    await instance
        .ref(
        "AdminName/${widget.user.cid}/$currantYear/"
            "$monthKey/payment")
        .update({"isPaymentMethod": "online",
      "isPaymentStatus":"done",
      "transactionId":response.paymentId,
      "transactionDate":transactionDate

    });

  // ignore: use_build_context_synchronously
  showErrorAlertDialog(context, "Succsess", "Payment Succsessfully Complited ");


  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails

    showErrorAlertDialog(context, "Error", response.error.toString());

  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }

  @override
  Widget build(BuildContext context) {
    final themeChange= Provider.of<DarkThemeProvider>(context);
    SizeConfig().init(context);
    return Scaffold(
      appBar: appBar(title: labelDrawerPayment),
      body: StreamBuilder(
        stream: FirebaseDatabase.instance
            .ref("AdminName/${widget.user.cid}/${DateTime.now().year}")
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

          List<TransactionMonthModel> transactionMonthModels=[];
          if (snapshot.hasData && snapshot.data != null) {
            if(snapshot.data!.snapshot.value!=null){
              final jsonString = json.encode(snapshot.data!.snapshot.value);
              final values = json.decode(jsonString) as Map<String, dynamic>;
              transactionMonthModels.clear();
              values.forEach((key, value) {

                List<TransactionModel> transactionModel=[];
                value.forEach(
                      (key, value) {
                    if (value != "" && key == "payment") {
                      transactionModel.add(TransactionModel(title: value["title"],transactionDate:value["transactionDate"],
                          isPaymentMethod: value["isPaymentMethod"],
                          isPaymentStatus: value["isPaymentStatus"],transactionId:value["transactionId"]));
                    }
                    if (value != "" && key == "totalAmount") {
                      amount = double.parse(value["evening"]);
                    }
                  },
                );
                if (value != "" && value["payment"] != null) {
                  transactionMonthModels.add(TransactionMonthModel(monthName: key,transactionModels: transactionModel));
                }
              });
            }else{
              return const Center(child: Text("No Any Data"),);
            }

          }

          return transactionMonthModels.isNotEmpty?ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.screenWidth! * 0.01,
                vertical: SizeConfig.screenWidth! * 0.03),
            itemCount: transactionMonthModels.length,
            itemBuilder: (BuildContext context, int index) {

              return Card(
                shadowColor: indigo700,
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: ListTileWidget(
                  hPadding: SizeConfig.screenWidth! * 0.04,
                  leading: CircleAvatar(
                    backgroundColor: themeChange.darkTheme?white54:indigo700,
                    
                    child: Text("${index + 1}",style: TextStyle(color: themeChange.darkTheme?black:white,fontWeight: FontWeight.bold),),
                  ),
                  title: month(int.parse(transactionMonthModels[index].monthName.toString())),
                  subTitle: transactionMonthModels[index].transactionModels![0].transactionId!.isNotEmpty?
                  "Tra. Id: ${transactionMonthModels[index].transactionModels![0].transactionId}\nDate:${transactionMonthModels[index].transactionModels![0].transactionDate} ":"",
                  subTitleStyle: const TextStyle(
                    fontSize: 12,
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        amount.toString(),
                        style: TextStyle(
                            color: transactionMonthModels[index].transactionModels![0].isPaymentStatus == "pending"
                                ? red
                                : green,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        transactionMonthModels[index].transactionModels![0].isPaymentMethod == "cash"
                            ? "Cash"
                            :transactionMonthModels[index].transactionModels![0].isPaymentMethod ==  "Online"?"Online":"",
                        style: TextStyle(
                            color: transactionMonthModels[index].transactionModels![0].isPaymentStatus == "pending"
                                ? red
                                : green,
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                      ),
                    ],
                  ),
                  onTap: transactionMonthModels[index].transactionModels![0].isPaymentStatus == "pending"
                      ? () {
                    setState(() {
                      monthKey=int.parse(transactionMonthModels[index].monthName.toString());
                    });
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              title: const Text("Payment Options"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.money),
                                    title: const Text(
                                      "Cash",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onTap: () async {
                                      await FirebaseDatabase.instance
                                          .ref(
                                              "AdminName/${widget.user.cid}/$currantYear/"
                                                  "${int.parse(transactionMonthModels[index].monthName.toString())}/payment")
                                          .update({"isPaymentMethod": "cash",

                                      });
                                      // ignore: use_build_context_synchronously
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.money),
                                    title: const Text("Online",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    onTap: () async {

                                      _razorpay.open({
                                        'key': 'rzp_test_ph2OPkthhMURDC',
                                        'amount': amount*100,
                                        'name':
                                        widget.user.cName,
                                        'description': 'KUDOS MILK',
                                        'prefill': {
                                          'contact': widget.user.cContactNumber,
                                          'email': widget.user.cEmail
                                        }
                                      });
                                      Navigator.of(context).pop();

                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      : null,
                ),
              );
            },
          ):const Center(child:Text("Not Any Data Available") ,);
        },
      ),
    );
  }
}
