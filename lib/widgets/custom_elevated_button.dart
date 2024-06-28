import 'package:flutter/material.dart';

class CustomTextButton extends StatefulWidget {
  const CustomTextButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  final Future<void> Function()? onPressed; // Function to be called when the button is pressed
  final Widget child; // Child widget to be displayed inside the button

  @override
  State<CustomTextButton> createState() => _CustomTextButtonState();
}

class _CustomTextButtonState extends State<CustomTextButton> {
  bool _isLoading = false; // Tracks the loading state

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Full width button
      height: 60, // Fixed height for the button
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8), // Rounded corners for the container
      ),
      child: TextButton(
        onPressed: () async {
          setState(() {
            _isLoading = true; // Set loading state to true when the button is pressed
          });
          
          await widget.onPressed!(); // Execute the passed function

          setState(() {
            _isLoading = false; // Set loading state to false after the function is executed
          });
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), // Rounded corners for the button
          ),
          backgroundColor: _isLoading
              ? Theme.of(context).scaffoldBackgroundColor // Background color when loading
              : Theme.of(context).primaryColor, // Background color when not loading
          splashFactory: NoSplash.splashFactory, // No splash effect on button press
        ),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor, // Spinner color when loading
                ),
              )
            : widget.child, // Display the child widget when not loading
      ),
    );
  }
}
