// import 'dart:io';

// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:kwiki/screens/user_side/address.dart';
// import 'package:kwiki/screens/user_side/dashboard.dart';
// import 'package:kwiki/screens/user_side/seller_Profile.dart';
// import 'package:kwiki/services/query_firebase.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// class BuyerProductDetails extends StatefulWidget {
//   final Map<String, dynamic> product;
//   const BuyerProductDetails({super.key, required this.product});

//   @override
//   State<BuyerProductDetails> createState() => _BuyerProductState();
// }

// class _BuyerProductState extends State<BuyerProductDetails> {
//   final CarouselSliderController carouselController =
//       CarouselSliderController();
//   int currentImageIndex = 0;
//   bool favorate = false;
//   String? selectedSize;
//   bool loadingPa = false;
//   int counter = 1;
//   Map<String, bool> selectedProducts = {};
//   final Map<String, List<Map<String, dynamic>>> categoryAddOns = {
//     'Pizza': [
//       {
//         'id': 'p1',
//         'name': 'Extra Cheese',
//         'price': 20.0,
//         'description': 'Add more mozzarella cheese'
//       },
//       {
//         'id': 'p2',
//         'name': 'Extra Toppings',
//         'price': 30.0,
//         'description': 'Additional pizza toppings'
//       }
//     ],
//     'Burger': [
//       {
//         'id': 'b1',
//         'name': 'Extra Patty',
//         'price': 45.0,
//         'description': 'Add one more patty'
//       },
//       {
//         'id': 'b2',
//         'name': 'Bacon',
//         'price': 35.0,
//         'description': 'Add crispy bacon strips'
//       }
//     ],
//     'Pasta': [
//       {
//         'id': 'pa1',
//         'name': 'Extra Sauce',
//         'price': 25.0,
//         'description': 'More pasta sauce'
//       },
//       {
//         'id': 'pa2',
//         'name': 'Extra Cheese',
//         'price': 20.0,
//         'description': 'Additional cheese topping'
//       }
//     ],
//     'Desserts': [
//       {
//         'id': 'pa1',
//         'name': 'Pink Cocaine',
//         'price': 25.0,
//         'description': 'More Color'
//       },
//       {
//         'id': 'pa2',
//         'name': 'Extra plastic',
//         'price': 20.0,
//         'description': 'Additional cheese topping'
//       }
//     ],
//   };
//   Map<String, bool> selectedAddOns = {};
//   String textpo = "DIpwedi yan plss";
//   Widget sizeSelector() {
//     final List<String> productSizes =
//         List<String>.from(widget.product['sizes']);
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(
//           height: 10,
//         ),
//         Wrap(
//           spacing: 23,
//           runSpacing: 10,
//           children: productSizes.map((size) {
//             final bool isSelected = selectedSize == size;
//             return GestureDetector(
//               onTap: () {
//                 setState(() {
//                   selectedSize = isSelected ? null : size;
//                 });
//               },
//               child: CircleAvatar(
//                 radius: 25,
//                 backgroundColor:
//                     isSelected ? Color(0xFFFF6722) : Colors.grey[200],
//                 child: Text(
//                   size,
//                   style: TextStyle(
//                       color: isSelected ? Colors.white : Colors.black),
//                 ),
//               ),
//             );
//           }).toList(),
//         )
//       ],
//     );
//   }

//   Widget buildAddOns() {
//     final productCategory = widget.product['category'] as String;
//     final addOns = categoryAddOns[productCategory] ?? [];
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       itemCount: addOns.length,
//       itemBuilder: (context, index) {
//         final addon = addOns[index];
//         return Card(
//           elevation: 1,
//           margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//           child: Padding(
//             padding: EdgeInsets.all(8),
//             child: Row(
//               children: [
//                 Checkbox(
//                   value: selectedAddOns[addon['id']] ?? false,
//                   onChanged: (bool? value) {
//                     setState(() {
//                       selectedAddOns[addon['id']] = value ?? false;
//                     });
//                   },
//                   activeColor: Color(0xFFFF6722),
//                 ),
//                 SizedBox(width: 8),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         addon['name'],
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       Text(
//                         addon['description'],
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Text(
//                   '₱${addon['price']}',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFFFF6722),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   double calculateTax(double amount) => amount * 0.12;

//   double subtotal() {
//     double basePrice = (widget.product['price']).toDouble();
//     double addOnsPrice = 0.0;
//     final productCategory = widget.product['category'] as String;
//     final availableAddson = categoryAddOns[productCategory] ?? [];

//     for (var addon in availableAddson) {
//       if (selectedAddOns[addon['id']] == true) {
//         addOnsPrice += (addon['price']).toDouble();
//       }
//     }
//     return (basePrice + addOnsPrice) * counter;
//   }

//   double totalPrice() {
//     double subTotal = subtotal();
//     double tax = calculateTax(subTotal);
//     int deleveryFee = 50;
//     double total = subTotal + tax + deleveryFee;
//     return double.parse(total.toStringAsFixed(2));
//   }

//   Future<void> _save() async {
//     try {
//       if (selectedSize == null) {
//         Fluttertoast.showToast(
//           msg: "Please select size",
//           toastLength: Toast.LENGTH_LONG,
//           gravity: ToastGravity.BOTTOM,
//           backgroundColor: Color(0xFFFF7622),
//           textColor: Colors.white,
//           fontSize: 14.0,
//         );
//       } else {
//         final selectedAddson = categoryAddOns[widget.product['category']]
//                 ?.where((addon) => selectedAddOns[addon['id']] == true)
//                 .map((addon) => {
//                       'id': addon['id'],
//                       'name': addon['name'],
//                       'price': addon['price'],
//                     })
//                 .toList() ??
//             [];
//         final List<String> imagePath =
//             List<String>.from(widget.product['imagePath']);
//         final success = await QueryFirebase().addtoCart(
//           productId: widget.product['id'],
//           productName: widget.product['name'] ?? '',
//           basePrice: widget.product['price'] ?? 0.0,
//           quantity: counter,
//           selectedSize: selectedSize,
//           addOns: selectedAddson,
//           totalPrice: totalPrice(),
//           subTotal: subtotal(),
//           tax: calculateTax(subtotal()),
//           sellerId: widget.product['userId'] ?? '',
//           sellerName: widget.product['sellerName'] ?? '',
//           userId: FirebaseAuth.instance.currentUser!.uid,
//           imagePath: imagePath,
//         );
//         if (!success) {
//           throw Exception('Failed to add to cart');
//         }
//       }
//     } catch (e) {
//       throw Exception("Hakdog");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final List<String> imagePaths =
//         List<String>.from(widget.product['imagePath']);
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             expandedHeight: 270,
//             pinned: true,
//             backgroundColor: Colors.white,
//             leading: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: CircleAvatar(
//                 backgroundColor: Colors.white,
//                 child: IconButton(
//                   icon: Icon(Icons.arrow_back, color: Colors.black),
//                   onPressed: () => Navigator.pushReplacement(context,
//                       MaterialPageRoute(builder: (context) => Dashboard())),
//                 ),
//               ),
//             ),
//             actions: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: CircleAvatar(
//                   backgroundColor: Colors.white,
//                   child: IconButton(
//                     icon: Icon(
//                       favorate ? Icons.favorite : Icons.favorite_border,
//                       color: favorate ? Color(0xFFFF6722) : Colors.black,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         favorate = !favorate;
//                       });
//                     },
//                   ),
//                 ),
//               ),
//             ],
//             flexibleSpace: FlexibleSpaceBar(
//               background: Stack(
//                 children: [
//                   CarouselSlider(
//                     carouselController: carouselController,
//                     options: CarouselOptions(
//                       height: 300,
//                       autoPlay: true,
//                       viewportFraction: 1.0,
//                       enlargeCenterPage: false,
//                       onPageChanged: (index, reason) {
//                         setState(() {
//                           currentImageIndex = index;
//                         });
//                       },
//                     ),
//                     items: imagePaths.map((path) {
//                       return SizedBox(
//                           width: MediaQuery.of(context).size.width,
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(30),
//                             child: Image.file(
//                               File(path),
//                               fit: BoxFit.cover,
//                             ),
//                           ));
//                     }).toList(),
//                   ),
//                   Positioned(
//                       // bottom: 10,
//                       left: 0,
//                       right: 0,
//                       child: Center(
//                         child: AnimatedSmoothIndicator(
//                           activeIndex: currentImageIndex,
//                           count: imagePaths.length,
//                           effect: ExpandingDotsEffect(
//                             dotWidth: 10,
//                             dotHeight: 10,
//                             activeDotColor: Color(0xFFFF7622),
//                             dotColor: Colors.white,
//                             expansionFactor: 2,
//                           ),
//                           onDotClicked: (index) {
//                             carouselController.animateToPage(index);
//                           },
//                         ),
//                       ))
//                 ],
//               ),
//             ),
//           ),
//           SliverToBoxAdapter(
//               child: Container(
//             decoration: BoxDecoration(color: Colors.white),
//             child: Padding(
//               padding: EdgeInsets.all(16),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => SellerProfile(
//                                       sellerId: widget.product['userId'],
//                                       sellerName: widget.product['sellerName'],
//                                       sellerImage:
//                                           widget.product['sellerImage'],
//                                       description: widget.product['sellerBio'],
//                                     )));
//                       },
//                       child: Container(
//                         height: 60,
//                         constraints: BoxConstraints(
//                           minWidth: 120,
//                           maxWidth: 150,
//                         ),
//                         decoration: BoxDecoration(
//                             border: Border.all(color: Color(0xFFE9E9E9)),
//                             borderRadius: BorderRadius.circular(20)),
//                         child: Row(
//                           children: [
//                             SizedBox(
//                               width: 15,
//                             ),
//                             CircleAvatar(
//                               radius: 20,
//                               backgroundColor: Colors.grey[200],
//                               backgroundImage:
//                                   widget.product['sellerImage'] != null
//                                       ? FileImage(
//                                           File(widget.product['sellerImage']))
//                                       : null,
//                               child: widget.product['sellerImage'] == null
//                                   ? Icon(Icons.person, color: Colors.grey[400])
//                                   : null,
//                             ),
//                             SizedBox(width: 10),
//                             Text(
//                               widget.product['sellerName'],
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .titleMedium
//                                   ?.copyWith(
//                                     color: Color(0xFF6B6E82),
//                                     fontSize: 16,
//                                   ),
//                             ),
//                           ],
//                         ),
//                       )),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                     widget.product['name'],
//                     style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 25,
//                         ),
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   Text(
//                     widget.product['description'],
//                     style: Theme.of(context)
//                         .textTheme
//                         .titleMedium
//                         ?.copyWith(color: Color(0xFFA0A5BA), fontSize: 18),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Icon(Icons.star_border,
//                               size: 19, color: Color(0xFFF67224)),
//                           SizedBox(
//                             width: 5,
//                           ),
//                           Text(
//                             "4.7",
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .titleMedium
//                                 ?.copyWith(
//                                     fontSize: 12, fontWeight: FontWeight.bold),
//                           )
//                         ],
//                       ),
//                       SizedBox(
//                         width: 20,
//                       ),
//                       Row(
//                         children: [
//                           Icon(Icons.local_shipping,
//                               size: 19, color: Color(0xFFF67224)),
//                           SizedBox(
//                             width: 5,
//                           ),
//                           Text(
//                             "50",
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .titleMedium
//                                 ?.copyWith(fontSize: 12),
//                           )
//                         ],
//                       ),
//                       SizedBox(
//                         width: 20,
//                       ),
//                       Row(
//                         children: [
//                           Icon(Icons.access_time_rounded,
//                               size: 19, color: Color(0xFFF67224)),
//                           SizedBox(
//                             width: 5,
//                           ),
//                           Text(
//                             "20 Min",
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .titleMedium
//                                 ?.copyWith(fontSize: 13),
//                           )
//                         ],
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Text(
//                         "SIZE:",
//                         style:
//                             Theme.of(context).textTheme.titleMedium?.copyWith(
//                                   fontSize: 17,
//                                 ),
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       sizeSelector()
//                     ],
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Adds-On",
//                         style:
//                             Theme.of(context).textTheme.titleMedium?.copyWith(
//                                   fontWeight: FontWeight.w700,
//                                 ),
//                       ),
//                       Container(
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                         decoration: BoxDecoration(
//                           color: Color(0xFFECF0F4),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Text("Optional"),
//                       )
//                     ],
//                   ),
//                   buildAddOns()
//                 ],
//               ),
//             ),
//           ))
//         ],
//       ),
//       bottomNavigationBar: Container(
//         padding: EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.transparent,
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 IconButton(
//                   onPressed: counter <= 1
//                       ? null
//                       : () {
//                           setState(() {
//                             if (counter > 0) {
//                               counter--;
//                             }
//                           });
//                         },
//                   icon: Icon(
//                     Icons.remove_circle,
//                     size: 30,
//                   ),
//                 ),
//                 SizedBox(
//                   width: 10,
//                 ),
//                 Text(
//                   counter.toString(),
//                   style: Theme.of(context)
//                       .textTheme
//                       .titleMedium
//                       ?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
//                 ),
//                 SizedBox(
//                   width: 10,
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     setState(() {
//                       counter++;
//                     });
//                   },
//                   icon: Icon(
//                     Icons.add_circle,
//                     size: 30,
//                   ),
//                 )
//               ],
//             ),
//             SizedBox(
//               height: 50,
//               width: 170,
//               child: ElevatedButton(
//                 onPressed: () async {
//                   try {
//                     setState(() {
//                       loadingPa = true;
//                     });
//                     final userProfile = await FirebaseFirestore.instance
//                         .collection('adddress')
//                         .where('userId',
//                             isEqualTo: FirebaseAuth.instance.currentUser?.uid)
//                         .get();

//                     if (userProfile.docs.isEmpty) {
//                       showDialog(
//                         context: context,
//                         builder: (context) => AlertDialog(
//                           title: Text('Address Required'),
//                           content: Text(
//                               'Please complete your Address before adding items to cart'),
//                           actions: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 TextButton(
//                                   onPressed: () => Navigator.pop(context),
//                                   style: TextButton.styleFrom(
//                                     foregroundColor: Colors.grey,
//                                   ),
//                                   child: Text('Cancel'),
//                                 ),
//                                SizedBox(width: 5,),
//                                TextButton(
//                                   onPressed: () {
//                                     Navigator.push(context, MaterialPageRoute(builder: (context)=>Address()));
//                                   },
//                                   style: TextButton.styleFrom(
//                                     foregroundColor: Colors.white,
//                                     backgroundColor: Color(0xFFFF6722)
//                                   ),
//                                   child: Text('Create Addres'),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       );
//                       return;
//                     }
//                     if (selectedSize == null) {
//                       Fluttertoast.showToast(
//                         msg: "Please select size",
//                         toastLength: Toast.LENGTH_LONG,
//                         gravity: ToastGravity.BOTTOM,
//                         backgroundColor: Color(0xFFFF7622),
//                         textColor: Colors.white,
//                         fontSize: 14.0,
//                       );
//                     } else {
//                       await _save();
//                       Navigator.push(context,
//                           MaterialPageRoute(builder: (context) => Dashboard()));
//                     }
//                   } catch (e) {
//                     throw ("dad");
//                   } finally {
//                     loadingPa = false;
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xFFFF6722),
//                   foregroundColor: Colors.white,
//                   padding: EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(50),
//                   ),
//                 ),
//                 child: loadingPa
//                     ? SizedBox(
//                         height: 20,
//                         width: 20,
//                         child: CircularProgressIndicator(
//                           color: Colors.white,
//                         ),
//                       )
//                     : Text(
//                         '₱${subtotal()}',
//                         style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
