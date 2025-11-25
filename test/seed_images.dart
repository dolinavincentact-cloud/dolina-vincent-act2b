import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  test('Seed specific product images', () async {
    // Initialize Supabase Client
    final supabase = SupabaseClient(
      'https://ykwwsqicqogcytvuiicp.supabase.co',
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inlrd3dzcWljcW9nY3l0dnVpaWNwIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NDA1NjM4OSwiZXhwIjoyMDc5NjMyMzg5fQ.GJPFZmvULCdHIpH2sl4RCYhtN8ilXUsPQfVTuxDEXKo',
    );

    // Fetch all products
    final response = await supabase.from('products').select();
    final products = List<Map<String, dynamic>>.from(response as List);

    print('Found ${products.length} products.');
    print('Please ensure your images are in "assets/images/products/" and named as follows:');

    for (final product in products) {
      final productId = product['id'];
      final productName = product['name'] as String;
      
      // Create a slug from the product name (e.g., "Margherita Pizza" -> "margherita_pizza")
      final slug = productName.toLowerCase().replaceAll(' ', '_');
      
      print('Processing $productName...');
      print('  Looking for: assets/images/products/$slug.png (or .jpg, .jpeg)');

      File? imageFile;
      String? extension;

      // Check for common image extensions
      for (final ext in ['png', 'jpg', 'jpeg']) {
        final path = 'assets/images/products/$slug.$ext';
        final file = File(path);
        if (await file.exists()) {
          imageFile = file;
          extension = ext;
          break;
        }
      }

      if (imageFile == null) {
        print('  [MISSING] No image found for $productName at assets/images/products/$slug.png');
        continue;
      }

      final fileName = '${slug}_${DateTime.now().millisecondsSinceEpoch}.$extension';
      final storagePath = 'images/$fileName';

      try {
        print('  [UPLOADING] Found image! Uploading...');
        // Upload image
        await supabase.storage.from('products').upload(
              storagePath,
              imageFile,
              fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
            );
        
        // Get public URL
        final publicUrl = supabase.storage.from('products').getPublicUrl(storagePath);
        
        // Update product record
        await supabase.from('products').update({
          'image_url': publicUrl
        }).eq('id', productId);

        print('  [SUCCESS] Updated image for $productName: $publicUrl');
      } catch (e) {
        print('  [ERROR] Failed to process $productName: $e');
      }
    }
  });
}
