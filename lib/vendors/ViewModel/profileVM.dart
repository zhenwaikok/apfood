import 'dart:io';
import 'package:apfood/vendors/model/profile_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileViewModel extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = true;
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _image;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  File? get image => _image;

  ProfileViewModel() {
    fetchUserData();
  }

  //fetch user details
  Future<void> fetchUserData() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        final doc = await FirebaseFirestore.instance
            .collection("users")
            .doc(currentUser.uid)
            .get();
        _user = UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //sign out
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  //change password
  Future<bool> changePassword(
      String email, String oldPassword, String newPassword) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    try {
      if (currentUser != null) {
        final credential =
            EmailAuthProvider.credential(email: email, password: oldPassword);

        await currentUser.reauthenticateWithCredential(credential);
        currentUser.updatePassword(newPassword);
        notifyListeners();

        return true;
      }
    } catch (e) {
      //check if error
      print('Error updating password: $e');
    }

    return false;
  }

  //pick image for profile pic
  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      //convert the picked image file to a file object
      _image = File(pickedFile.path);
      notifyListeners();
    }
  }

  //save picture to firestore storage and database
  Future<void> saveProfilePic() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      //create unique file name for the image
      final fileName =
          "${currentUser.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg";
      final storageRef =
          FirebaseStorage.instance.ref().child("ProfileImage").child(fileName);

      try {
        //upload image to storage and get its url
        await storageRef.putFile(_image!);
        final imageURL = await storageRef.getDownloadURL();

        //update the firestore with the url
        await FirebaseFirestore.instance
            .collection("users")
            .doc(currentUser.uid)
            .update({
          "image_url": imageURL,
        });

        _user!.image_url = imageURL;
        await fetchUserData();
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }
}
