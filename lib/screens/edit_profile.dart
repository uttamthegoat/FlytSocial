import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flytsocial/state/user_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  final Map<String, dynamic> user;

  const EditProfile({super.key, required this.user});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfile> {
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _bioController;
  File? _image;
  String? _imageUrl;
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  late List<String> usedUsernames = [];
  late bool hasEdited = false;

  @override
  void initState() {
    super.initState();
    setUserInfo();
    getAllUserNames();
  }

  Future<void> getAllUserNames() async {
    try {
      final String curUserId = widget.user['userId'];
      final snapshot =
          await FirebaseFirestore.instance.collection('users').get();
      final List<String> usernames = [];

      for (var doc in snapshot.docs) {
        if (doc.id != curUserId) {
          usernames.add(doc['username']);
        }
      }

      setState(() {
        usedUsernames = usernames;
      });
    } catch (e) {
      print('Error fetching usernames: $e');
    }
  }

  void setUserInfo() {
    setState(() {
      _nameController = TextEditingController(text: widget.user['name']);
      _usernameController =
          TextEditingController(text: widget.user['username']);
      _bioController = TextEditingController(text: widget.user['bio']);
      _imageUrl = widget.user['imageUrl'];
    });
  }

  void _resetForm() {
    setState(() {
      _nameController.text = widget.user['name'] ?? '';
      _usernameController.text = widget.user['username'] ?? '';
      _bioController.text = widget.user['bio'] ?? '';
      _image = null;
    });
  }

  void _clearForm() {
    setState(() {
      _nameController.clear();
      _usernameController.clear();
      _bioController.clear();
      _image = null;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _saveProfile() async {
    final String curUserId = widget.user['userId'];
    bool shouldUpdate = false;
    String? newImageUrl;

    // Check if a new image is selected and upload it
    if (_image != null) {
      newImageUrl = await replaceImage(_image!);
      shouldUpdate = true;
    }

    // Check if name, username, or bio have changed
    if (_nameController.text != widget.user['name'] ||
        _usernameController.text != widget.user['username'] ||
        _bioController.text != widget.user['bio']) {
      shouldUpdate = true;
    }

    if (shouldUpdate) {
      try {
        // Prepare the data to be updated
        Map<String, dynamic> updatedData = {};

        if (newImageUrl != null) {
          updatedData['imageUrl'] = newImageUrl;
        }
        if (_nameController.text != widget.user['name']) {
          updatedData['name'] = _nameController.text;
        }
        if (_usernameController.text != widget.user['username']) {
          updatedData['username'] = _usernameController.text;
        }
        if (_bioController.text != widget.user['bio']) {
          updatedData['bio'] = _bioController.text;
        }

        // Update the user document in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(curUserId)
            .update(updatedData);

        // Fetch the updated document
        DocumentSnapshot updatedDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(curUserId)
            .get();

        Map<String, dynamic> updatedUser =
            updatedDoc.data() as Map<String, dynamic>;
        updatedUser['userId'] = widget.user['userId'];

        setState(() {
          hasEdited = true;
        });
        await updateUser(updatedUser);

        // Clear the form
        _clearForm();
        Navigator.pop(context, updatedUser);

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      } catch (e) {
        print('Error updating profile: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile')),
        );
      }
    }
  }

  Future<String?> replaceImage(File image) async {
    try {
      final String imageUrl = widget.user['imageUrl'];
      final String userId = widget.user['userId'];
      // deleting the imageUrl
      if (imageUrl != '') {
        final existingImageRef = FirebaseStorage.instance.refFromURL(imageUrl);
        await existingImageRef.delete();
      }
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref('users/$userId/$fileName')
          .putFile(image);
      String downloadURL = await snapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload image')),
      );
      return null;
    }
  }

  Future<void> updateUser(Map<String, dynamic> updatedUser) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonUser = jsonEncode(updatedUser);
    await prefs.setString("curuser", jsonUser);
    await Provider.of<UserProvider>(context, listen: false).setUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile',
        style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 23, color: Colors.white),),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: GestureDetector(
              onTap: _resetForm,
              child: const Text(
                'Reset',
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: _saveProfile,
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.blue, fontSize: 18),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: _image == null
                      ? Image.network(
                          _imageUrl == ''
                              ? 'https://via.placeholder.com/150'
                              : _imageUrl!,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          _image!,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: TextEditingController(text: widget.user['email']),
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter name...',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    hintText: 'Enter username...',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    if (usedUsernames.contains(value)) {
                      return 'This username is already taken';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _bioController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Bio',
                    hintText: 'Enter bio...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
