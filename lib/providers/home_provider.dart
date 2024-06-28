import 'package:flutter/material.dart';

import 'package:yt_clone/screens/tabs/home.dart';
import 'package:yt_clone/screens/tabs/profile.dart';

class HomeProvider extends ChangeNotifier {
  // List of tabs to be displayed in the app
  final List<Widget> tabs = [
    const HomeTab(),   // Home tab widget
    const ProfileTab(),  // Profile tab widget
  ];

  // Index of the currently selected tab
  int currentTabIdx = 0;

  // Method to change the current tab index
  void changeTab(int index) {
    currentTabIdx = index;  // Update the current tab index
    notifyListeners();      // Notify listeners (typically widgets) of the change
  }
}
