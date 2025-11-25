import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:kwiki/services/database_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// This script demonstrates how to add products with images to Supabase.
/// 
/// To use this:
/// 1. Place product images in assets/images/products/
/// 2. Run: flutter test test/add_products_with_images.dart
/// 
void main() {
  test('Add products with images to Supabase', () async {
    // Initialize Supabase
    await Supabase.initialize(
      url: 'https://ykwwsqicqogcytvuiicp.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inlrd3dzcWljcW9nY3l0dnVpaWNwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQwNTYzODksImV4cCI6MjA3OTYzMjM4OX0.4-Y3zLQxR_cJvWHUmRGLfQVjX5J7K8dv4mJXN_QXxH4',
    );

    final databaseService = DatabaseService();

    // Sample products to add
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

    print('Starting to add products with images...\n');

    for (final productData in products) {
      final name = productData['name'] as String;
      final description = productData['description'] as String;
      final price = productData['price'] as double;
      final category = productData['category'] as String;
      final imagePath = productData['imagePath'] as String?;

      File? imageFile;
      if (imagePath != null) {
        final file = File(imagePath);
        if (await file.exists()) {
          imageFile = file;
          print('✓ Found image for $name');
        } else {
          print('⚠ Image not found for $name at $imagePath (will add without image)');
        }
      }

      try {
        final productId = await databaseService.addProduct(
          name: name,
          description: description,
          price: price,
          category: category,
          imageFile: imageFile,
        );

        if (productId != null) {
          print('✓ Successfully added: $name (ID: $productId)');
          if (imageFile != null) {
            print('  Image uploaded to Supabase storage');
          }
        } else {
          print('✗ Failed to add: $name');
        }
      } catch (e) {
        print('✗ Error adding $name: $e');
      }
      print('');
    }

    print('Done! Products have been added to Supabase.');
    print('Images are stored in Supabase storage bucket: products/images/');
  });
}

