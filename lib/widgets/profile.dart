// import 'dart:io';


// import 'package:flutter/material.dart';
// import 'package:kwiki/models/profile_item.dart';
// import 'package:kwiki/widgets/navigation.dart';
// import 'package:kwiki/widgets/save/edit_profile.dart';

// class Profile extends StatefulWidget {
//   const Profile({
//     super.key,
//   });

//   @override
//   State<Profile> createState() => _ProfileState();
// }

// Widget builProfiledetail(
//     BuildContext context, Map<String, dynamic> profileData) {
//   final List<ProfileItem> profileItems = [
//     ProfileItem(
//       title: "FULL NAME",
//       value: profileData['fullname']?.toString() ?? 'Not set',
//       icon: Icons.person_2_outlined,
//       iconColor: Color(0xFFFF6722),
//     ),
//     ProfileItem(
//       title: "FULL NAME",
//       value: profileData['email']?.toString() ?? 'Not set',
//       icon: Icons.email_outlined,
//       iconColor: Color(0xFF413DFB),
//     ),
//     ProfileItem(
//       title: "Number",
//       value: profileData['number']?.toString() ?? 'Not set',
//       icon: Icons.person_2_outlined,
//       iconColor: Color(0xFFFF6722),
//     ),
//   ];

//   return Card(
//     child: Padding(
//       padding: EdgeInsets.all(20),
//       child: Column(
//           children: profileItems
//               .map((item) => Column(
//                     children: [
//                       Row(
//                         children: [
//                           Container(
//                             height: 50,
//                             width: 50,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(50),
//                               color: Colors.white,
//                             ),
//                             child: Icon(
//                               item.icon,
//                               size: 25,
//                               color: item.iconColor,
//                             ),
//                           ),
//                           SizedBox(
//                             width: 10,
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 item.title,
//                                 style: Theme.of(context).textTheme.titleMedium,
//                               ),
//                               Text(
//                                 item.value,
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .titleMedium
//                                     ?.copyWith(
//                                       fontSize: 15,
//                                       color: Color(0xFF6B6E82),
//                                     ),
//                               )
//                             ],
//                           )
//                         ],
//                       ),
//                       SizedBox(
//                         height: 20,
//                       )
//                     ],
//                   ))
//               .toList()),
//     ),
//   );
// }

// class _ProfileState extends State<Profile> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Personal Info",
//           style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                 fontSize: 21,
//               ),
//         ),
//         actions: [
//           StreamBuilder<QuerySnapshot>(
//             stream: FirebaseFirestore.instance
//                 .collection('profile')
//                 .where('userId',
//                     isEqualTo: FirebaseAuth.instance.currentUser!.uid)
//                 .snapshots(),
//             builder: (context, snapshot) {
//               return GestureDetector(
//                 onTap: () {
//                   if (snapshot.hasData) {
//                     final profileData = snapshot.data!.docs.first.data()
//                         as Map<String, dynamic>;
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => EditProfile(
//                                   profileData: profileData,
//                                 )));
//                   }
//                 },
//                 child: Padding(
//                   padding: EdgeInsets.only(right: 20),
//                   child: Text(
//                     "Edit",
//                     style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                           color: Color(0xFFFF7622),
//                           fontSize: 18,
//                         ),
//                   ),
//                 ),
//               );
//             },
//           )
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection('profile')
//               .where('userId',
//                   isEqualTo: FirebaseAuth.instance.currentUser!.uid)
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(
//                 child: CircularProgressIndicator(
//                   color: Color(0xFFFF7622),
//                 ),
//               );
//             }
//             final profileData =
//                 snapshot.data!.docs.first.data() as Map<String, dynamic>;

//             final imagePath = profileData['image'] as String?;
//             return Padding(
//                 padding: EdgeInsets.all(16),
//                 child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 16),
//                         child: Row(
//                           children: [
//                             Card(
//                               elevation: 1,
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(75)),
//                               child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(75),
//                                   child:
//                                       imagePath != null && imagePath.isNotEmpty
//                                           ? Image.file(
//                                               File(imagePath),
//                                               width: 120,
//                                               height: 120,
//                                               fit: BoxFit.cover,
//                                             )
//                                           : Container(
//                                               width: 120,
//                                               height: 120,
//                                               color: Colors.grey[200],
//                                               child: Icon(
//                                                 Icons.person,
//                                                 size: 80,
//                                                 color: Colors.grey[400],
//                                               ),
//                                             )),
//                             ),
//                             SizedBox(
//                               width: 30,
//                             ),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   profileData['fullname'],
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .titleMedium
//                                       ?.copyWith(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 25,
//                                       ),
//                                 ),
//                                 Wrap(
//                                   children: [
//                                     Text(
//                                       maxLines: 4,
//                                       profileData['bio'],
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .titleSmall
//                                           ?.copyWith(color: Color(0xFFA0A5BA)),
//                                     )
//                                   ],
//                                 )
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(
//                         height: 50,
//                       ),
//                       builProfiledetail(context, profileData)
//                     ]));
//           },
//         ),
//       ),
//       bottomNavigationBar: StreamBuilder<DocumentSnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('users')
//             .doc(FirebaseAuth.instance.currentUser?.uid)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return SizedBox.shrink();
//           }

//           if (!snapshot.hasData || !snapshot.data!.exists) {
//             return SizedBox.shrink();
//           }

//           final userData = snapshot.data!.data() as Map<String, dynamic>;
//           final userRole = userData['role'] as String?;

//           if (userRole == 'seller') {
//             return Navigation(initialIndex: 4);
//           }

//           return SizedBox.shrink();
//         },
//       ),
//     );
//   }
// }
