import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:milk_user/comman/widgets.dart';
import 'package:milk_user/screens/contact_us/contact_us_widget.dart';
import 'package:milk_user/size_config.dart';
import 'package:milk_user/utils/constants.dart';

class ContectUs extends StatefulWidget {
  const ContectUs({super.key});

  @override
  State<ContectUs> createState() => _ContectUsState();
}

class _ContectUsState extends State<ContectUs> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        appBar: appBar(title: labelDrawerContactUs),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("admin")
              .doc("profile")
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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
            final admin = snapshot.data!.data() as Map<String, dynamic>;
            return ListView(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.screenHeight! * 0.025,
              ),
              children: [
                ContactUsHeader(
                  admin: admin,
                ),
                SizedBox(
                  height: SizeConfig.screenHeight! * 0.03,
                ),
                ContactUsData(
                    icon: icPhone,
                    title: labelMobileNumber,
                    subTitle: admin["contactNumber"]),
                ContactUsData(
                    icon: icEmail, title: labelEmail, subTitle: admin["email"]),
                ContactUsData(
                    icon: icAddress,
                    title: labelAddress,
                    subTitle: admin["address"]),
              ],
            );
          },
        ));
  }
}


// Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Stack(
//               children: [
//                 Container(
//                   margin: EdgeInsets.only(
//                     top: 70,
//                     bottom: 50,
//                     left: 15,
//                     right: 15,
//                   ),
//                   height: 300,
//                   width: 350,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.all(Radius.circular(20)),
//                     color: indigo700,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey,
//                         blurRadius: 15.0, // soften the shadow
//                         spreadRadius: 5.0, //extend the shadow
//                         offset: Offset(
//                           5.0, // Move to right 5  horizontally
//                           5.0, // Move to bottom 5 Vertically
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//                 // Padding(
//                 //   padding: const EdgeInsets.only(left: 140, top: 20),
//                 //   child:
//                 Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(left: 10, top: 20),
//                       child: CircleAvatar(
//                         backgroundImage: AssetImage(logo),
//                         radius: 70,
//                       ),
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Text(
//                       "Admin",
//                       style: TextStyle(fontSize: 20, color: white),
//                     ),
//                     Text(
//                       "Admin@gmail.com",
//                       style: TextStyle(color: white),
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     // commenSizedbox(height: 20),
//                     // commonText(text: "Admin", fontSize: 20, color: white),
//                     // commonText(text: 'admin@gmail.com', color: white),
//                     // commenSizedbox(height: 50),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         CircleAvatar(
//                           radius: 25,
//                           backgroundColor: white,
//                           foregroundColor: Colors.red.shade400,
//                           child: IconButton(
//                               onPressed: () {}, icon: Icon(Icons.email)),
//                         ),
//                         CircleAvatar(
//                           backgroundColor: white,
//                           foregroundColor: Colors.blue,
//                           radius: 25,
//                           child: IconButton(
//                               onPressed: () {}, icon: Icon(Icons.message)),
//                         ),
//                         CircleAvatar(
//                           radius: 25,
//                           foregroundColor: Colors.green,
//                           backgroundColor: white,
//                           child: IconButton(
//                               onPressed: () {}, icon: Icon(Icons.call)),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               ],
//             ),
//             Text(
//               "Name",
//               style: TextStyle(color: grey),
//             ),
//             Text(
//               "Admin",
//               style: TextStyle(fontSize: 17),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Text(
//               "Mobile No",
//               style: TextStyle(color: grey),
//             ),
//             Text(
//               "1234567890",
//               style: TextStyle(fontSize: 17),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Text(
//               "Address",
//               style: TextStyle(color: grey),
//             ),
//             Text(
//               "1-3 golden plazaa,near DMart Mall ,Mota Varachha, Surat",
//               style: TextStyle(fontSize: 17),
//             ),

//             // commonText(text: 'Name', color: grey),
//             // commonText(text: 'Admin', fontSize: 17),
//             // commenSizedbox(height: 20),
//             // commonText(text: 'Mobile No', color: grey),
//             // commonText(text: '9910238976', fontSize: 17),
//             // commenSizedbox(height: 20),
//             // commonText(text: 'Address', color: grey),
//             // commonText(
//             //     text:
//             //         '1-3 golden plazaa,near DMart Mall ,Mota Varachha, Surat',
//             //     fontSize: 17),
//           ],
//         ),
//       )