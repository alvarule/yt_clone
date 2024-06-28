import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yt_clone/screens/home.dart';
import 'package:yt_clone/screens/auth.dart';

class YTClone extends StatelessWidget {
  const YTClone({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // Listen to the authentication state changes
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        // Show a loading indicator while waiting for connection
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        } else {
          // Check if there is an active session
          if (snapshot.data!.session != null) {
            // If the user is authenticated, show the HomeScreen
            return const HomeScreen();
          } else {
            // If the user is not authenticated, show the AuthScreen
            return const AuthScreen();
          }
        }
      },
    );
  }
}
