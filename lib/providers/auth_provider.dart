import 'dart:io';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider() {
    _loadCurrentUser();
  }

  User? _user; // Holds the current authenticated user
  User? get user => _user; // Getter for _user

  String? _profilePicPath; // Path to the selected profile picture
  String? get profilePicPath => _profilePicPath; // Getter for _profilePicPath

  bool _profilePicError = false; // Flag to indicate if there's an error with the profile picture
  bool get profilePicError => _profilePicError; // Getter for _profilePicError

  String? _name; // User's name
  String? get name => _name; // Getter for _name

  String? _email; // User's email
  String? get email => _email; // Getter for _email

  String? _password; // User's password
  String? get password => _password; // Getter for _password

  final SupabaseClient supabaseClient = Supabase.instance.client; // Supabase client instance

  // Loads the current user from Supabase session
  Future<void> _loadCurrentUser() async {
    final session = supabaseClient.auth.currentSession;
    if (session != null) {
      _user = session.user;
    }
    notifyListeners();
  }

  // Sets the user's name
  void setName(String? name) {
    _name = name;
  }

  // Sets the user's email
  void setEmail(String? email) {
    _email = email;
  }

  // Sets the user's password
  void setPassword(String? password) {
    _password = password;
  }

  // Sets the profile picture by picking from gallery and cropping
  void setProfile() async {
    final ImagePicker picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final cropper = ImageCropper();
      final croppedImage = await cropper.cropImage(
        sourcePath: pickedImage.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: "Crop Image",
            activeControlsWidgetColor: Colors.red,
          ),
        ],
      );

      if (croppedImage != null) {
        _profilePicPath = croppedImage.path;
        _profilePicError = false;
        notifyListeners();
      }
    }
  }

  // Validates if a profile picture has been selected
  bool validateProfilePic() {
    if (_profilePicPath == null) {
      _profilePicError = true;
    } else {
      _profilePicError = false;
    }
    notifyListeners();
    return !_profilePicError;
  }

  // Signs up a new user
  Future<String> signup() async {
    try {
      final response = await supabaseClient.auth.signUp(email: _email!, password: _password!);

      // Uploads profile picture to Supabase storage
      await supabaseClient.storage.from("profile_pics").upload("${response.user!.id}.jpg", File(_profilePicPath!));

      // Gets public URL for the uploaded profile picture
      _profilePicPath = supabaseClient.storage.from("profile_pics").getPublicUrl("${response.user!.id}.jpg");

      // Inserts user data into the 'user' table
      await supabaseClient.from("user").insert({
        "email": _email,
        "name": _name,
        "profile": _profilePicPath,
        "user_id": response.user!.id,
      });

      return ''; // Successful signup
    } catch (e) {
      print(e.toString());
      return 'Something went wrong'; // Error during signup
    }
  }

  // Logs in an existing user
  Future<String> login() async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(email: _email!, password: _password!);

      _user = response.user;

      // Retrieves user profile data
      await getProfile();

      notifyListeners();
      return ''; // Successful login
    } on AuthException catch (e) {
      print(e.message.toString());
      return e.message; // Auth exception (e.g., wrong credentials)
    } catch (e) {
      return 'Something went wrong'; // Other errors during login
    }
  }

  // Logs out the current user
  Future<void> logout() async {
    await supabaseClient.auth.signOut();
    _user = null;
    notifyListeners();
  }

  // Retrieves and sets user profile data
  Future<void> getProfile() async {
    final userResponse = await supabaseClient.from("user").select().match({"user_id": _user!.id});

    _name = userResponse.first["name"];
    _email = userResponse.first["email"];
    _profilePicPath = userResponse.first["profile"];
    notifyListeners();
  }

  // Updates the user's name
  Future<String> updateName(String name) async {
    try {
      await supabaseClient.from("user").update({"name": name}).eq("user_id", _user!.id);

      // Retrieves updated profile data
      await getProfile();

      notifyListeners();
      return 'Name changed successfully'; // Successful name update
    } catch (e) {
      return 'Something went wrong'; // Error during name update
    }
  }
}
