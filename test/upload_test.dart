import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  test('Upload image to Supabase', () async {
    // Initialize Supabase Client directly
    final supabase = SupabaseClient(
      'https://ykwwsqicqogcytvuiicp.supabase.co',
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inlrd3dzcWljcW9nY3l0dnVpaWNwIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NDA1NjM4OSwiZXhwIjoyMDc5NjMyMzg5fQ.GJPFZmvULCdHIpH2sl4RCYhtN8ilXUsPQfVTuxDEXKo',
    );

    // User's image path
    final imagePath = r'C:/Users/klarins/.gemini/antigravity/brain/14cde68a-a0f2-4d67-a850-0263eacd7a9c/uploaded_image_1764077989729.png';
    final file = File(imagePath);

    if (!await file.exists()) {
      print('Error: File not found at $imagePath');
      return;
    }

    final fileName = 'uploaded_image_${DateTime.now().millisecondsSinceEpoch}.png';

    print('Uploading image...');
    try {
      await supabase.storage.from('products').upload(
            'images/$fileName',
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );
      
      final publicUrl = supabase.storage.from('products').getPublicUrl('images/$fileName');
      print('Image uploaded successfully!');
      print('Public URL: $publicUrl');
    } catch (e) {
      print('Error uploading image: $e');
      fail('Upload failed: $e');
    }
  });
}
