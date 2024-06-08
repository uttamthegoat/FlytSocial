import 'package:flutter/material.dart';

class PostItem extends StatefulWidget {
  final Map<String, dynamic> post;
  const PostItem({super.key, required this.post});

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  bool _isExpanded = false;
  bool _isLiked = false;
  final TextEditingController _commentController = TextEditingController();
  final List<String> _comments = [];

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  void _incrementCommentCount() {
    setState(() {
      _isExpanded =
          true; // Show the comment section when the comment button is pressed
    });
  }

  void _addComment() {
    if (_commentController.text.isNotEmpty) {
      setState(() {
        _comments.add('Username: ${_commentController.text}');
        _commentController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        backgroundColor: const Color.fromARGB(255, 119, 76, 175),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info Row
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage:
                        NetworkImage('https://via.placeholder.com/150/'),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Username',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            // Post Image
            Container(
              height: 500,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(post['postImageUrl'] ??
                      'https://via.placeholder.com/150/'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Like and Comment Buttons
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _isLiked ? Icons.favorite : Icons.favorite_border,
                      color: _isLiked ? Colors.red : Colors.black,
                    ),
                    onPressed: _toggleLike,
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.comment),
                    onPressed: _toggleExpand,
                  ),
                ],
              ),
            ),
            // Post Description
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post['caption'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    Row(
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
                )),
            // Comment Section

            if (_isExpanded)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display comments
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          labelText: 'Comment',
                          hintText: 'Add a comment...',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: _addComment,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 10, 0, 5),
                          child: Text(
                            _comments.isNotEmpty
                                ? 'All comments'
                                : 'No comments',
                            style: const TextStyle(
                              color: Colors.black, // Darker font color
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.bold, // Increased font weight
                            ),
                          ),
                        ),
                        for (var comment in _comments)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 8.0),
                            child: Text(
                              comment,
                              style: const TextStyle(
                                color: Colors.black, // Darker font color
                                fontSize: 14,
                                fontWeight:
                                    FontWeight.normal, // Increased font weight
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
