class TransactionMonthModel{
  String? monthName;
  List<TransactionModel>? transactionModels;

  TransactionMonthModel({required this.monthName,required this.transactionModels});


}

class TransactionModel {
  String? title;
  String? isPaymentMethod;
  String? transactionDate;
  String? isPaymentStatus;
  String? transactionId;

  TransactionModel(
      {required this.title,
      required this.isPaymentMethod,
      required this.isPaymentStatus,
        required this.transactionDate,
      required this.transactionId});

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
        title: json["title"],
        transactionDate:json["transactionDate"],
        isPaymentMethod: json["isPaymentMethod"],
        isPaymentStatus: json["isPaymentStatus"],
        transactionId: json["transactionId"]);
  }
  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "transactionDate":transactionDate,
      "isPaymentMethod": isPaymentMethod,
      "isPaymentStatus": isPaymentStatus,
      "transactionId": transactionId
    };
  }
}
