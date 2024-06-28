import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yt_clone/providers/auth_provider.dart';
import 'package:yt_clone/widgets/custom_elevated_button.dart';
import 'package:yt_clone/widgets/custom_form_field.dart';
import 'package:yt_clone/widgets/custom_text.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final _formKey = GlobalKey<FormState>();
  String _nameInp = '';
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, state, child) => FutureBuilder(
        future: state.getProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading spinner while waiting for the profile data
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          } else if (snapshot.hasError) {
            // Show an error message if something goes wrong
            print(snapshot);
            return Center(
              child: CustomText(
                text: "Some error occurred",
              ),
            );
          } else {
            // Display the profile information
            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Profile picture
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(state.profilePicPath!),
                      ),
                      const SizedBox(height: 20),
                      // Email address
                      CustomText(
                        text: state.email!,
                        fontSize: 16,
                        color: Theme.of(context).unselectedWidgetColor,
                      ),
                      const SizedBox(height: 30),
                      Align(
                        alignment: Alignment.topLeft,
                        child: CustomText(
                          text: "Name",
                        ),
                      ),
                      // Name input field
                      CustomFormField(
                        labelText: "",
                        initialValue: state.name!,
                        enabled: _isEditing,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter a name";
                          }
                          return null;
                        },
                        onSaved: (newValue) => _nameInp = newValue!,
                      ),
                      const SizedBox(height: 30),
                      // Save or Edit button
                      CustomTextButton(
                        onPressed: () async {
                          if (_isEditing) {
                            // Save the updated name
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              final resp = await state.updateName(_nameInp);
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: CustomText(text: resp),
                                ),
                              );
                              setState(() {
                                _isEditing = false;
                              });
                            }
                          } else {
                            // Enable editing
                            setState(() {
                              _isEditing = true;
                            });
                          }
                        },
                        child: CustomText(
                          text: _isEditing ? "Save" : "Edit",
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
