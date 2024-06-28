import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yt_clone/providers/auth_provider.dart';
import 'package:yt_clone/utils/images.dart';
import 'package:yt_clone/widgets/custom_elevated_button.dart';
import 'package:yt_clone/widgets/custom_form_field.dart';
import 'package:yt_clone/widgets/custom_text.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;  // State variable to toggle between login and signup

  final _formKey = GlobalKey<FormState>();  // Form key for form validation

  // Method to toggle between login and signup
  void toggleLogin() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        title: CustomText(
          text: _isLogin ? "Login" : "Sign Up",
          fontSize: 28,
          color: Theme.of(context).focusColor,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, state, child) => Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (!_isLogin)
                    Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: state.setProfile,  // Set profile picture
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: state.profilePicPath != null
                              ? FileImage(File(state.profilePicPath!))
                              : AssetImage(Images.userPlaceholder)
                                  as ImageProvider,
                        ),
                      ),
                    ),
                  if (!_isLogin && state.profilePicError)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: CustomText(
                        text: "Please select a Profile Pic",
                        color: Colors.red,
                      ),
                    ),
                  if (!_isLogin)
                    Align(
                      alignment: Alignment.topLeft,
                      child: CustomText(
                        text: "Name",
                        color: Theme.of(context).focusColor,
                      ),
                    ),
                  if (!_isLogin)
                    CustomFormField(
                      labelText: "",
                      hintText: "Name",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a name";
                        }
                        return null;
                      },
                      onSaved: state.setName,
                    ),
                  if (!_isLogin) const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.topLeft,
                    child: CustomText(
                      text: "Email",
                      color: Theme.of(context).focusColor,
                    ),
                  ),
                  CustomFormField(
                    labelText: "",
                    hintText: "Email",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter an email";
                      } else if (!value.contains("@")) {
                        return "Please enter a valid email";
                      }
                      return null;
                    },
                    onSaved: state.setEmail,
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.topLeft,
                    child: CustomText(
                      text: "Password",
                      color: Theme.of(context).focusColor,
                    ),
                  ),
                  CustomFormField(
                    labelText: "",
                    hintText: "Password",
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a password";
                      }
                    },
                    onChanged: state.setPassword,
                  ),
                  if (!_isLogin) const SizedBox(height: 20),
                  if (!_isLogin)
                    Align(
                      alignment: Alignment.topLeft,
                      child: CustomText(
                        text: "Confirm Password",
                        color: Theme.of(context).focusColor,
                      ),
                    ),
                  if (!_isLogin)
                    CustomFormField(
                      labelText: "",
                      hintText: "Confirm Password",
                      isPassword: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter confirm password";
                        } else if (value != state.password) {
                          return "Password and Confirm Password do not match";
                        }
                        return null;
                      },
                    ),
                  const SizedBox(height: 30),
                  CustomTextButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        if (!_isLogin) {
                          if (state.validateProfilePic()) {
                            await state.signup();
                          }
                        } else {
                          final resp = await state.login();
                          if (resp != '') {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: CustomText(text: resp),
                              ),
                            );
                          }
                        }
                      }
                    },
                    child: CustomText(
                      text: _isLogin ? "Login" : "Sign Up",
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: "Don't have an account?",
                        color: Theme.of(context).focusColor,
                      ),
                      TextButton(
                        onPressed: toggleLogin,  // Toggle between login and signup
                        child: CustomText(
                          text: _isLogin ? "Sign Up" : "Login",
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
