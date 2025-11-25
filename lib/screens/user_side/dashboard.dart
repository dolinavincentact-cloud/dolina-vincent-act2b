import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kwiki/authentication/login.dart';
import 'package:kwiki/models/product_model.dart';
import 'package:kwiki/screens/user_side/buyerOrders.dart';
import 'package:kwiki/screens/user_side/cart.dart';
import 'package:kwiki/services/database_service.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class CategoryItem {
  final String name;
  final String image;

  CategoryItem({required this.name, required this.image});
}

class _DashboardState extends State<Dashboard> {
  String selectedCategory = "All";
  String search = "";
  final searchControler = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();
  
  final List<CategoryItem> categories = [
    CategoryItem(name: "All", image: "assets/icons/category_Icons/maloi.png"), // Added All category
    CategoryItem(name: "Coffe", image: "assets/icons/category_Icons/coffe.png"),
    CategoryItem(name: "Pizza", image: "assets/icons/category_Icons/pizza.png"),
    CategoryItem(
        name: "Burger", image: "assets/icons/category_Icons/burger.png"),
    CategoryItem(name: "Pasta", image: "assets/icons/category_Icons/pasta.png"),
    CategoryItem(
        name: "Drinks", image: "assets/icons/category_Icons/drinks.png"),
    CategoryItem(
        name: "Desserts", image: "assets/icons/category_Icons/dessert.png"),
  ];
  Timer? _debounce;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _debounce?.cancel();
    searchControler.dispose();
    super.dispose();
  }

  void _onsearchChange(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        search = query;
      });
    });
  }

  Future<void> _addToCart(Product product) async {
    try {
      await _databaseService.addToCart(product.id, 1);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${product.name} added to cart'),
            backgroundColor: Color(0xFFFF6722),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding to cart: $e')),
        );
      }
    }
  }

  Drawer buildDrawer(BuildContext context) {
    final userData = {
      'fullname': 'User', 
      'email': 'user@example.com', 
      'image': null,
    };

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFFFF6722),
            ),
            accountName: Text(
              userData['fullname'] as String,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              userData['email'] as String,
              style: TextStyle(color: Colors.white),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Color(0xFFFF6722)),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ListTile(
                leading: Icon(Icons.home, color: Color(0xFFFF6722)),
                title: Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Dashboard()),
                  );
                },
              ),
            
              ListTile(
                leading: Icon(Icons.shopping_cart, color: Color(0xFFFF6722)),
                title: Text('Cart'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Cart()));
                },
              ),
              ListTile(
                leading:
                    Icon(Icons.list_alt_outlined, color: Color(0xFFFF6722)),
                title: Text('orders'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => BuyerOrders()));
                },
              ),
              ListTile(
                leading: Icon(Icons.favorite, color: Color(0xFFFF6722)),
                title: Text('Favorites'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/favorites');
                },
              ),
            
            ],
          ),
          Column(
            children: [
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.description_outlined,
                  color: Color(0xFFFF6722),
                ),
                title: Text("Terms & Conditions"),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.logout, color: Color(0xFFFF6722)),
                title: Text('Logout'),
                onTap: () async {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Login()));
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: buildDrawer(context),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (BuildContext context) => IconButton(
            icon: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFFFF6722),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                Icons.menu,
                color: Colors.white,
                size: 20,
              ),
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "DELIVER TO",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Color(0xFFFF6722),
                  ),
            ),
            Text(
              "ACLC",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Color(0xFF676767), fontSize: 13),
            )
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  color: Color(0xFFFF6722),
                  borderRadius: BorderRadius.circular(40)),
              child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Cart()));
                  },
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                    size: 20,
                  )),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: searchControler,
                onChanged: _onsearchChange,
                decoration: InputDecoration(
                  hintText: "Search",
                  hintStyle: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Color(0xFFA0A5BA)),
                  filled: true,
                  fillColor: Colors.grey[100],
                  prefixIcon: Icon(Icons.search, color: Color(0xFFA0A5BA)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "CATEGORY",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Container(
                  height: 100,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final bool selectedNaba =
                          selectedCategory == categories[index].name;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategory = categories[index].name;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 20),
                          child: Column(
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                margin: EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: selectedNaba
                                      ? Color(0xFFFF7622).withOpacity(0.1)
                                      : Colors.grey[100],
                                ),
                                child: Image.asset(
                                  categories[index].image,
                                  height: 30,
                                  width: 30,
                                ),
                              ),
                              Text(
                                categories[index].name,
                                style: TextStyle(
                                    color: selectedNaba
                                        ? Color(0xFFFF7622)
                                        : Colors.grey,
                                    fontWeight: selectedNaba
                                        ? FontWeight.bold
                                        : FontWeight.w500),
                              ),
                              const SizedBox(height: 4),
                              AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                height: 2,
                                width: 30,
                                color: selectedNaba
                                    ? Color(0xFFFF7622)
                                    : Colors.transparent,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  )),
              Text(
                "Recommended for you",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              FutureBuilder<List<Product>>(
                future: _databaseService.getProducts(
                  category: selectedCategory,
                  searchQuery: search,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(color: Color(0xFFFF6722)));
                  }
                  
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final products = snapshot.data ?? [];

                  if (products.isEmpty) {
                    return Center(child: Text('No products found'));
                  }

                  return GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.78),
                      itemCount: products.length,
                      itemBuilder: (contex, index) {
                        final product = products[index];

                        return GestureDetector(
                          onTap: () {
                          
                          },
                          child: Card(
                            color: Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                      height: 130,
                                      width: double.infinity,
                                      color: Colors.grey[300],
                                      child: product.imageUrl != null 
                                        ? Image.network(product.imageUrl!, fit: BoxFit.cover)
                                        : Image.asset("assets/icons/category_Icons/coffe.png", fit: BoxFit.cover)
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style:
                                            Theme.of(context).textTheme.titleMedium,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '\$${product.price.toStringAsFixed(2)}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                    fontWeight: FontWeight.bold),
                                          ),
                                          GestureDetector(
                                            onTap: () => _addToCart(product),
                                            child: Container(
                                              padding: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Color(0xFFFF6722),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                size: 15,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
