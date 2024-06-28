import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yt_clone/providers/auth_provider.dart';
import 'package:yt_clone/providers/home_provider.dart';
import 'package:yt_clone/yt_clone.dart';

void main() async {
  // Ensure widgets are initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase with the URL and anon key
  await Supabase.initialize(
    url: "https://ecnhjcjgdmwawtyymuuw.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVjbmhqY2pnZG13YXd0eXltdXV3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTkzMzcyNTUsImV4cCI6MjAzNDkxMzI1NX0.3sfQX1W7LBM6SnJtXE2d_sPT5-TPv9dCQuiJPFc6yAk",
  );

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of the application
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provide HomeProvider and AuthProvider using ChangeNotifierProvider
        ChangeNotifierProvider(create: (context) => HomeProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Youtube Clone',
        theme: lightTheme, // Light theme configuration
        darkTheme: darkTheme, // Dark theme configuration
        themeMode: ThemeMode.system, // Use system theme mode
        home: const YTClone(), // The main entry widget of the app
        debugShowCheckedModeBanner: false, // Hide debug banner
      ),
    );
  }
}

// Light theme settings
ThemeData lightTheme = ThemeData(
  primaryColor: Colors.red,
  scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
  focusColor: Colors.black,
  unselectedWidgetColor: const Color.fromARGB(255, 45, 45, 45),
  dialogBackgroundColor: const Color.fromARGB(255, 206, 206, 206),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Colors.red,
    selectionColor: Color.fromARGB(135, 244, 67, 54),
    selectionHandleColor: Colors.red,
  ),
);

// Dark theme settings
ThemeData darkTheme = ThemeData(
  primaryColor: Colors.red,
  scaffoldBackgroundColor: const Color.fromARGB(255, 24, 24, 24),
  focusColor: Colors.white,
  unselectedWidgetColor: const Color.fromARGB(255, 197, 197, 197),
  dialogBackgroundColor: const Color.fromARGB(255, 42, 42, 42),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Colors.red,
    selectionColor: Color.fromARGB(135, 244, 67, 54),
    selectionHandleColor: Colors.red,
  ),
);
