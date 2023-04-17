class CustomerModel {
  String? cid;
  String? id;
  String? pass;
  String? cName;
  String? cProfilePic;
  String? cContactNumber;
  String? cEmail;
  String? cAddress;
  List? myproduct;
  bool? useNotDeleted;
  bool? delivered;
  bool? verified;

  CustomerModel(
      {required this.id,
      required this.pass,
      required this.cid,
      required this.cName,
      required this.cProfilePic,
      required this.cContactNumber,
      required this.cEmail,
      required this.cAddress,
      required this.myproduct,
      required this.delivered,
      this.verified,
      required this.useNotDeleted});

  factory CustomerModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return CustomerModel(
        id: json["id"],
        pass: json["pass"],
        cid: json['cid'],
        cName: json['cName'],
        cProfilePic: json['cProfilePic'],
        cContactNumber: json['cContactNumber'],
        cEmail: json['cEmail'],
        cAddress: json['cAddress'],
        useNotDeleted: json["useNotDeleted"],
        myproduct: json["myproduct"],
        verified: json["verified"],
        delivered: false);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "pass": pass,
      'cid': cid,
      'cName': cName,
      'cProfilePic': cProfilePic,
      'cContactNumber': cContactNumber,
      'cEmail': cEmail,
      'cAddress': cAddress,
      "myproduct": myproduct,
      "delivered": delivered,
      "useNotDeleted": useNotDeleted,
      "verified": verified
    };
  }
}
