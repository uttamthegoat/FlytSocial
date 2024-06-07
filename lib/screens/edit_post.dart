import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EditPost extends StatefulWidget {
  final Map<String, dynamic> post;
  const EditPost({super.key, required this.post});

  @override
  State<EditPost> createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Post'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(post['caption']?? 'post caption'),
            Text(post['postImageUrl']?? 'post caption'),
            Text(post['userId']?? 'post caption'),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
                      children: post['tags'].map<Widget>((tag) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              right: 8.0), // Adjust the padding value as needed
                          child: Text(
                            '#$tag',
                            style: const TextStyle(color: Colors.blue),
                          ),
                        );
                      }).toList(),
                    )
          ],
        ),
      ),
    );
  }
}
