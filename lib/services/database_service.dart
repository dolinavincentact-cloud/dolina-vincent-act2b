import 'package:kwiki/models/cart_model.dart';
import 'package:kwiki/models/order_model.dart';
import 'package:kwiki/models/product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

class DatabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Storage
  Future<String?> uploadProductImage(File file, String fileName) async {
    try {
      final String path = await _supabase.storage.from('products').upload(
            'images/$fileName',
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );
      
      // Get the public URL
      final String publicUrl = _supabase.storage.from('products').getPublicUrl('images/$fileName');
      return publicUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // Add Product with Image
  Future<String?> addProduct({
    required String name,
    required String description,
    required double price,
    required String category,
    File? imageFile,
  }) async {
    try {
      String? imageUrl;
      
      // Upload image if provided
      if (imageFile != null) {
        final fileName = '${name.toLowerCase().replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.${imageFile.path.split('.').last}';
        imageUrl = await uploadProductImage(imageFile, fileName);
        
        if (imageUrl == null) {
          throw Exception('Failed to upload image');
        }
      }
      
      // Insert product
      final response = await _supabase.from('products').insert({
        'name': name,
        'description': description,
        'price': price,
        'category': category,
        'image_url': imageUrl,
      }).select().single();
      
      return response['id'] as String;
    } catch (e) {
      print('Error adding product: $e');
      return null;
    }
  }


  // Products
  Future<List<Product>> getProducts({String? category, String? searchQuery}) async {
    var query = _supabase.from('products').select();

    if (category != null && category != 'All') {
      query = query.eq('category', category);
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query.ilike('name', '%$searchQuery%');
    }

    final response = await query;
    return (response as List).map((e) => Product.fromJson(e)).toList();
  }

  // Cart
  Future<void> addToCart(String productId, int quantity) async {
    final userId = _supabase.auth.currentUser!.id;
    
    // Check if item already exists in cart
    final existingItems = await _supabase
        .from('cart')
        .select()
        .eq('user_id', userId)
        .eq('product_id', productId);

    if (existingItems.isNotEmpty) {
      // Update quantity
      final currentQuantity = existingItems[0]['quantity'] as int;
      await _supabase
          .from('cart')
          .update({'quantity': currentQuantity + quantity})
          .eq('id', existingItems[0]['id']);
    } else {
      // Insert new item
      await _supabase.from('cart').insert({
        'user_id': userId,
        'product_id': productId,
        'quantity': quantity,
      });
    }
  }

  Future<List<CartItem>> getCartItems() async {
    final userId = _supabase.auth.currentUser!.id;
    final response = await _supabase
        .from('cart')
        .select('*, products(*)')
        .eq('user_id', userId);

    return (response as List).map((e) => CartItem.fromJson(e)).toList();
  }

  Future<void> updateCartItemQuantity(String cartId, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(cartId);
    } else {
      await _supabase
          .from('cart')
          .update({'quantity': quantity})
          .eq('id', cartId);
    }
  }

  Future<void> removeFromCart(String cartId) async {
    await _supabase.from('cart').delete().eq('id', cartId);
  }

  // Orders
  Future<void> checkout() async {
    final userId = _supabase.auth.currentUser!.id;
    final cartItems = await getCartItems();

    if (cartItems.isEmpty) return;

    final totalAmount = cartItems.fold(
        0.0, (sum, item) => sum + (item.product!.price * item.quantity));

    // Create Order
    final orderResponse = await _supabase
        .from('orders')
        .insert({
          'user_id': userId,
          'total_amount': totalAmount,
          'status': 'pending',
        })
        .select()
        .single();

    final orderId = orderResponse['id'];

    // Create Order Items
    final orderItemsData = cartItems.map((item) => {
          'order_id': orderId,
          'product_id': item.productId,
          'quantity': item.quantity,
          'price': item.product!.price,
        }).toList();

    await _supabase.from('order_items').insert(orderItemsData);

    // Clear Cart
    await _supabase.from('cart').delete().eq('user_id', userId);
  }

  Future<List<Order>> getOrders() async {
    final userId = _supabase.auth.currentUser!.id;
    final response = await _supabase
        .from('orders')
        .select('*, order_items(*, products(*))')
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List).map((e) => Order.fromJson(e)).toList();
  }
}
