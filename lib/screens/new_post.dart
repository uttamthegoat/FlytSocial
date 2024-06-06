import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class NewPost extends StatefulWidget {
  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final _formKey = GlobalKey<FormState>();
  final _captionController = TextEditingController();
  final List<String> _tagsController = [];
  final TextEditingController _tagInputController = TextEditingController();

  File? _image;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _image != null) {
      // Form is valid and image is selected, process the data.
      print("Caption: ${_captionController.text}");
      print("Tags: $_tagsController");
      print("Image Path: ${_image!.path}");
      // You can now send the data to your backend or further process it.
    } else {
      // Show an error message if the form is not valid or no image is selected.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete the form')),
      );
    }
    _clearForm();
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

  Future<dynamic> uploadImageToFirebase(File imageFile) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create a new post')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _image == null
                  ? Container(
                      width: double.infinity,
                      height: 200,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
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
                    onPressed: _submitForm,
                    child: const Text('Create post'),
                  ),
                  ElevatedButton(
                    onPressed: _clearForm,
                    style: ElevatedButton.styleFrom(iconColor: Colors.red),
                    child: const Text('Reset'),
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



// inputs
// image
// caption
// tags