import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kwiki/screens/onboarding/onboarding1.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://ykwwsqicqogcytvuiicp.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inlrd3dzcWljcW9nY3l0dnVpaWNwIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NDA1NjM4OSwiZXhwIjoyMDc5NjMyMzg5fQ.GJPFZmvULCdHIpH2sl4RCYhtN8ilXUsPQfVTuxDEXKo',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)),
      home: Onboardong1(),
    );
  }
}
