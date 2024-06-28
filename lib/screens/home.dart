import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yt_clone/providers/auth_provider.dart';
import 'package:yt_clone/providers/home_provider.dart';
import 'package:yt_clone/widgets/custom_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, state, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
          title: CustomText(
            text: "YouTube Clone",
            fontSize: 18,
            color: Theme.of(context).focusColor,
          ),
          centerTitle: true,
          actions: [
            // Logout button
            Consumer<AuthProvider>(
              builder: (context, value, child) => IconButton(
                onPressed: () {
                  value.logout();  // Call logout method from AuthProvider
                },
                icon: const Icon(Icons.logout_rounded),
                color: Theme.of(context).focusColor,
              ),
            )
          ],
        ),
        // Display the currently selected tab
        body: state.tabs[state.currentTabIdx],
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: "Profile",
            ),
          ],
          currentIndex: state.currentTabIdx,  // Current tab index
          onTap: state.changeTab,  // Change tab on tap
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          selectedItemColor: Theme.of(context).focusColor,
          unselectedItemColor: Theme.of(context).unselectedWidgetColor,
        ),
      ),
    );
  }
}
