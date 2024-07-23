import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flytsocial/state/user_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class EditPost extends StatefulWidget {
  final Map<String, dynamic> post;
  const EditPost({super.key, required this.post});
  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  final _formKey = GlobalKey<FormState>();
  var _captionController = TextEditingController();
  var _imageController = TextEditingController();
  List<dynamic> _tagsController = [];
  late Map<String, dynamic> postItem = {};
  final TextEditingController _tagInputController = TextEditingController();

  File? _image;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    getPostInfo();
  }

  Future<void> getPostInfo() async {
    setState(() {
      _captionController = TextEditingController(text: widget.post['caption']);
      _tagsController = List.from(widget.post['tags']);
      _imageController =
          TextEditingController(text: widget.post['postImageUrl']);
      postItem = widget.post;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String?> replaceImage(
      File image, String postImageUrl, String userId) async {
    try {
      // deleting the postImageUrl
      final existingImageRef =
          FirebaseStorage.instance.refFromURL(postImageUrl);
      await existingImageRef.delete();
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref('posts/$userId/$fileName')
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

  // Utility function to compare two lists
  bool _listsEqual(List<dynamic> a, List<dynamic> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  void _submitForm(String userId) async {
    if (_formKey.currentState!.validate()) {
      bool shouldUpdate = false;
      String? newImageUrl;
      // Check if a new image is selected and upload it
      if (_image != null) {
        newImageUrl =
            await replaceImage(_image!, _imageController.text, userId);
        shouldUpdate = true;
      }
      // Check if caption or tags have changed
      if (_captionController.text != postItem['caption'] ||
          !_listsEqual(_tagsController, postItem['tags'])) {
        shouldUpdate = true;
      }
      if (shouldUpdate) {
        try {
          // Prepare the data to be updated
          Map<String, dynamic> updatedData = {};

          if (newImageUrl != null) {
            updatedData['postImageUrl'] = newImageUrl;
          }
          if (_captionController.text != postItem['caption']) {
            updatedData['caption'] = _captionController.text;
          }
          if (_tagsController != postItem['tags']) {
            updatedData['tags'] = _tagsController;
          }
          // Update the post document in Firestore
          final postRef = FirebaseFirestore.instance
              .collection('posts')
              .doc(postItem['postId']);

          await postRef.update(updatedData);

          // Retrieve and print the updated document
          final updatedDoc = await postRef.get();
          print('Updated document: ${updatedDoc.data()}');

          Navigator.pop(context, updatedDoc.data());

          // display the success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('The post has been updated')),
          );
          // Clear the form
          _clearForm();
        } catch (e) {
          print('Error updating post: $e');
        }
      }
      _clearForm();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete the form')),
      );
    }
  }

  void _clearForm() {
    _formKey.currentState!.reset();
    _captionController.clear();
    _tagsController.clear();
    setState(() {
      _image = null;
    });
  }

  @override
  void dispose() {
    // _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postOwner = Provider.of<UserProvider>(context).currentUser;
    final String curUserId = postOwner['userId'];
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit post',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 23, color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _image == null
                  ? Image.network(
                      _imageController.text,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      _image!,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => _pickImage(ImageSource.gallery),
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                        ),
                        child: const Icon(Icons.image),
                      ),
                      const SizedBox(height: 10), // Optional: Add some spacing
                      const Text('Gallery'),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => _pickImage(ImageSource.camera),
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                        ),
                        child: const Icon(Icons.camera),
                      ),
                      const SizedBox(height: 10), // Optional: Add some spacing
                      const Text('Camera'),
                    ],
                  ),
                ],
              ),
              TextFormField(
                controller: _captionController,
                decoration: const InputDecoration(
                    labelText: 'Caption', hintText: 'Enter a caption...'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a caption';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _tagInputController,
                decoration: const InputDecoration(
                    labelText: 'Enter Tag', hintText: 'Enter a tag...'),
                validator: (value) {
                  if (_tagsController.isEmpty) {
                    return 'Please add at least one tag';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  final String tag =
                      _tagInputController.text.trim().toLowerCase();
                  if (tag.isNotEmpty) {
                    setState(() {
                      _tagsController.add(tag);
                      _tagInputController.clear();
                    });
                  }
                },
                child: const Text('Add Tag'),
              ),
              Wrap(
                spacing: 8.0,
                children: _tagsController
                    .map((tag) => Chip(
                          label: Text(tag),
                          onDeleted: () {
                            setState(() {
                              _tagsController.remove(tag);
                            });
                          },
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _submitForm(curUserId),
                    child: const Text('Save changes'),
                  ),
                  ElevatedButton(
                    onPressed: _clearForm,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Cancel changes', style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
