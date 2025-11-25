import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Simple script to upload products with images to Supabase
/// Run with: dart run test/upload_products.dart
void main() async {
  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://ykwwsqicqogcytvuiicp.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inlrd3dzcWljcW9nY3l0dnVpaWNwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQwNTYzODksImV4cCI6MjA3OTYzMjM4OX0.4-Y3zLQxR_cJvWHUmRGLfQVjX5J7K8dv4mJXN_QXxH4',
  );

  final supabase = Supabase.instance.client;

  final products = [
    {
      'name': 'Margherita Pizza',
      'description': 'Classic pizza with tomato sauce and mozzarella',
      'price': 250.0,
      'category': 'Pizza',
      'imagePath': 'assets/images/products/margherita_pizza.png',
    },
    {
      'name': 'Cheeseburger',
      'description': 'Juicy beef patty with cheese',
      'price': 180.0,
      'category': 'Burger',
      'imagePath': 'assets/images/products/cheeseburger.png',
    },
    {
      'name': 'Iced Coffee',
      'description': 'Cold brewed coffee',
      'price': 120.0,
      'category': 'Drinks',
      'imagePath': 'assets/images/products/iced_coffee.png',
    },
    {
      'name': 'Carbonara Pasta',
      'description': 'Creamy pasta with bacon and parmesan',
      'price': 200.0,
      'category': 'Pasta',
      'imagePath': 'assets/images/products/carbonara_pasta.png',
    },
    {
      'name': 'Chocolate Cake',
      'description': 'Rich chocolate layer cake',
      'price': 150.0,
      'category': 'Desserts',
      'imagePath': 'assets/images/products/chocolate_cake.png',
    },
  ];

  print('Starting to upload products with images...\n');

  for (final productData in products) {
    final name = productData['name'] as String;
    final description = productData['description'] as String;
    final price = productData['price'] as double;
    final category = productData['category'] as String;
    final imagePath = productData['imagePath'] as String;

    try {
      final imageFile = File(imagePath);
      
      if (!await imageFile.exists()) {
        print('✗ Image not found for $name at $imagePath');
        continue;
      }

      print('Processing $name...');
      
      // Upload image to Supabase storage
      final fileName = '${name.toLowerCase().replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.png';
      final storagePath = 'images/$fileName';
      
      await supabase.storage.from('products').upload(
        storagePath,
        imageFile,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
      );

      // Get public URL
      final publicUrl = supabase.storage.from('products').getPublicUrl(storagePath);
      print('  ✓ Uploaded image: $publicUrl');

      // Insert product
      await supabase.from('products').insert({
        'name': name,
        'description': description,
        'price': price,
        'category': category,
        'image_url': publicUrl,
      });

      print('  ✓ Added product to database\n');
    } catch (e) {
      print('  ✗ Error: $e\n');
    }
  }

  print('✓ Done! Products with images have been uploaded to Supabase.');
  print('Images are in storage bucket: products/images/');
  exit(0);
}
