
// import 'package:flutter/material.dart';
// import 'package:kwiki/screens/user_side/address.dart';

// class ShowAddress extends StatefulWidget {
//   const ShowAddress({super.key});

//   @override
//   State<ShowAddress> createState() => _ShowAddressState();
// }

// class _ShowAddressState extends State<ShowAddress> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "My Addresses",
//           style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                 fontSize: 17,
//               ),
//         ),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('addresses')
//             .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator(color: Color(0xFFFF6722)));
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.location_off, size: 64, color: Colors.grey),
//                   SizedBox(height: 16),
//                   Text('No addresses saved yet'),
//                 ],
//               ),
//             );
//           }

//           return ListView.builder(
//             padding: EdgeInsets.all(16),
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (context, index) {
//               final address = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              
//               return Card(
//                 margin: EdgeInsets.only(bottom: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: ListTile(
//                   contentPadding: EdgeInsets.all(16),
//                   leading: CircleAvatar(
//                     backgroundColor: Color(0xFFFF6722),
//                     child: Icon(
//                       address['label'] == 'Home' ? Icons.home :
//                       address['label'] == 'Work' ? Icons.work :
//                       Icons.school,
//                       color: Colors.white,
//                     ),
//                   ),
//                   title: Text(
//                     address['label'],
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(height: 8),
//                       Text(address['address']),
//                       Text('${address['street']}, ${address['barangay']}'),
//                       if (address['landmark']?.isNotEmpty)
//                         Text('Landmark: ${address['landmark']}'),
//                     ],
//                   ),
//                   trailing: PopupMenuButton(
//                     itemBuilder: (context) => [
//                       PopupMenuItem(
//                         value: 'edit',
//                         child: Text('Edit'),
//                       ),
//                       PopupMenuItem(
//                         value: 'delete',
//                         child: Text('Delete'),
//                       ),
//                     ],
//                     onSelected: (value) {
//                       // Handle edit/delete
//                     },
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => Address()),
//           );
//         },
//         backgroundColor: Color(0xFFFF6722),
//         child: Icon(Icons.add, color: Colors.white),
//       ),
//     );
//   }
// }