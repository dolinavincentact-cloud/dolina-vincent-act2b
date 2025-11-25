// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:kwiki/screens/user_side/buyer_product_details.dart';

// class SellerProfile extends StatefulWidget {
//   final String sellerId;
//   final String sellerName;
//   final String? sellerImage;
//   final String description;
//   const SellerProfile(
//       {super.key,
//       required this.sellerId,
//       required this.sellerName,
//       required this.description,
//       required this.sellerImage});

//   @override
//   State<SellerProfile> createState() => _SellerProfileState();
// }

// class _SellerProfileState extends State<SellerProfile> {
//   String selectedCategory = "All";
//   final List<String> catigories = [
//     "All",
//     'Pizza',
//     'Burger',
//     'Pasta',
//     'Drinks',
//     'Desserts',
//     'Snacks'
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text(
//           widget.sellerName,
//           style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                 fontSize: 20,
//               ),
//         ),
//         actions: [],
//       ),
//       body: SingleChildScrollView(
//           child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(
//               height: 150,
//               width: double.infinity,
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(20),
//                 child: Image.file(
//                   File(widget.sellerImage!),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 30,
//             ),
//             Text(
//               widget.sellerName,
//               style: Theme.of(context)
//                   .textTheme
//                   .titleMedium
//                   ?.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Text(
//               widget.description,
//               style: Theme.of(context)
//                   .textTheme
//                   .titleMedium
//                   ?.copyWith(color: Color(0xFFA0A5BA)),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Row(mainAxisAlignment: MainAxisAlignment.start, children: [
//               Row(
//                 children: [
//                   Icon(Icons.star_border, size: 22, color: Color(0xFFF67224)),
//                   SizedBox(
//                     width: 5,
//                   ),
//                   Text(
//                     "4.7",
//                     style: Theme.of(context)
//                         .textTheme
//                         .titleMedium
//                         ?.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
//                   )
//                 ],
//               ),
//               SizedBox(
//                 width: 25,
//               ),
//               Row(
//                 children: [
//                   Icon(Icons.local_shipping,
//                       size: 22, color: Color(0xFFF67224)),
//                   SizedBox(
//                     width: 5,
//                   ),
//                   Text(
//                     "FREE",
//                     style: Theme.of(context)
//                         .textTheme
//                         .titleMedium
//                         ?.copyWith(fontSize: 14),
//                   )
//                 ],
//               ),
//               SizedBox(
//                 width: 25,
//               ),
//               Row(
//                 children: [
//                   Icon(Icons.access_time_rounded,
//                       size: 22, color: Color(0xFFF67224)),
//                   SizedBox(
//                     width: 5,
//                   ),
//                   Text(
//                     "20 Min",
//                     style: Theme.of(context)
//                         .textTheme
//                         .titleMedium
//                         ?.copyWith(fontSize: 14),
//                   )
//                 ],
//               ),
//             ]),
//             SizedBox(
//               height: 10,
//             ),
//             Container(
//               height: 50,
//               margin: EdgeInsets.symmetric(vertical: 10),
//               child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: catigories.length,
//                   itemBuilder: (context, index) {
//                     final selectedBa = selectedCategory == catigories[index];
//                     return GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           selectedCategory = catigories[index];
//                         });
//                       },
//                       child: Container(
//                         margin: EdgeInsets.only(right: 20),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Container(
//                                 width: 80,
//                                 height: 40,
//                                 decoration: BoxDecoration(
//                                     color: selectedBa
//                                         ? Color(0xFFF58D1D)
//                                         : Colors.white,
//                                     border: Border.all(
//                                         color: selectedBa
//                                             ? Colors.white
//                                             : Color(0xFFEDEDED)),
//                                     borderRadius: BorderRadius.circular(20)),
//                                 child: Center(
//                                   child: Text(
//                                     catigories[index],
//                                     style: TextStyle(
//                                         color: selectedBa
//                                             ? Colors.white
//                                             : Colors.black,
//                                         fontWeight: selectedBa
//                                             ? FontWeight.bold
//                                             : FontWeight.w500),
//                                   ),
//                                 )),
//                           ],
//                         ),
//                       ),
//                     );
//                   }),
//             ),
//             SizedBox(
//               height: 40,
//             ),
//             StreamBuilder<QuerySnapshot>(
//                 stream: selectedCategory == "All"
//                     ? FirebaseFirestore.instance
//                         .collection('products')
//                         .where('userId', isEqualTo: widget.sellerId)
//                         .snapshots()
//                     : FirebaseFirestore.instance
//                         .collection('products')
//                         .where('category', isEqualTo: selectedCategory)
//                         .snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(
//                       child: CircularProgressIndicator(
//                         color: Color(0xFFFF6722),
//                       ),
//                     );
//                   }
//                   final products = snapshot.data?.docs ?? [];
//                   return GridView.builder(
//                     shrinkWrap: true,
//                     physics: NeverScrollableScrollPhysics(),
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2,
//                         crossAxisSpacing: 10,
//                         mainAxisSpacing: 10,
//                         childAspectRatio: 0.82),
//                     itemCount: products.length,
//                     itemBuilder: (context, index) {
//                       final product =
//                           products[index].data() as Map<String, dynamic>;
//                       final images =
//                           List<String>.from(product['imagePath'] ?? []);

//                       return StreamBuilder(
//                           stream: FirebaseFirestore.instance
//                               .collection('profile')
//                               .where('userId', isEqualTo: product['userId'])
//                               .snapshots(),
//                           builder: (context, seller) {
//                             if (seller.connectionState ==
//                                 ConnectionState.waiting) {
//                               return Card(
//                                 child: Center(
//                                   child: CircularProgressIndicator(
//                                     color: Color(0xFFFF6722),
//                                   ),
//                                 ),
//                               );
//                             }
//                             final sellerData = seller.data?.docs.first.data();
//                             final sellerBio = sellerData?['bio'];
//                             final storeName = sellerData?['fullname'];
//                             final sellerImage = sellerData?['image'];
//                             final sellerProduct = {
//                               ...product,
//                               'sellerName': storeName,
//                               'sellerImage': sellerImage,
//                               'sellerBio': sellerBio,
//                             };
//                             return GestureDetector(
//                               onTap: () {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) =>
//                                             BuyerProductDetails(
//                                               product: sellerProduct,
//                                             )));
//                               },
//                               child: Card(
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(30),
//                                   ),
//                                   elevation: 2,
//                                   child: Stack(
//                                     clipBehavior: Clip.none,
//                                     children: [
//                                       Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           SizedBox(height: 89),
//                                           Padding(
//                                             padding: EdgeInsets.all(8),
//                                             child: Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
                                               
//                                                 Text(
//                                                   product['name'],
//                                                   style: Theme.of(context)
//                                                       .textTheme
//                                                       .titleMedium
//                                                       ?.copyWith(
//                                                         fontWeight:
//                                                             FontWeight.w700,
//                                                         fontSize: 16,
//                                                       ),
//                                                 ),
//                                                 SizedBox(
//                                                   height: 1,
//                                                 ),
//                                                 Text(
//                                                   'Meat-free ${product['category']}',
//                                                   maxLines: 1,
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                   style: Theme.of(context)
//                                                       .textTheme
//                                                       .bodyMedium
//                                                       ?.copyWith(
//                                                           color:
//                                                               Color(0xFF646982),
//                                                           fontSize: 13),
//                                                 ),
//                                                 Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceBetween,
//                                                   children: [
//                                                     Text(
//                                                       '₱${product['price'].toString()}',
//                                                       style: Theme.of(context)
//                                                           .textTheme
//                                                           .titleMedium
//                                                           ?.copyWith(
//                                                             fontWeight:
//                                                                 FontWeight.bold,
//                                                             fontSize: 16,
//                                                           ),
//                                                     ),
                                                    
//                                                   ],
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Positioned(
//                                         top: -35,
//                                         left: 10,
//                                         right: 10,
//                                         child: Container(
//                                           decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(12),
//                                             boxShadow: [
//                                               BoxShadow(
//                                                 color: Colors.black
//                                                     .withOpacity(0.1),
//                                                 spreadRadius: 1,
//                                                 blurRadius: 4,
//                                               ),
//                                             ],
//                                           ),
//                                           child: ClipRRect(
//                                             borderRadius:
//                                                 BorderRadius.circular(30),
//                                             child: Image.file(
//                                               File(images[0]),
//                                               height: 130,
//                                               width: double.infinity,
//                                               fit: BoxFit.cover,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   )),
//                             );
//                           });
//                     },
//                   );
//                 })
//           ],
//         ),
//       )),
//     );
//   }
// }
