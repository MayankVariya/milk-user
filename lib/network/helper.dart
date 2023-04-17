import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:milk_user/models/customer.dart';

class FirebaseHelper {
  static Future<CustomerModel?> getUserModelByProfile(String cUser) async {
    CustomerModel? userModel;

    DocumentSnapshot docSnap =
        await FirebaseFirestore.instance.collection("users").doc(cUser).get();
    if (docSnap.data() != null) {
      userModel = CustomerModel.fromJson(docSnap.data() as Map<String, dynamic>);
    }
    return userModel;
  }
}
