import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flytsocial/screens/edit_post.dart';
import 'package:flytsocial/state/user_provider.dart';
import 'package:provider/provider.dart';

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
  late Map<String, dynamic> postItem = {};

  @override
  void initState() {
    super.initState();
    setPostInfo();
  }

  void setPostInfo() {
    postItem = widget.post;
  }

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

  _showBottomSheet(BuildContext context, Map<String, dynamic> post) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 150,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 0, 5),
                child: ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Edit Post'),
                  onTap: () async {
                    Navigator.pop(context);
                    var result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditPost(post: post),
                      ),
                    );
                    if (result != null && result is Map<String, dynamic>) {
                      setState(() {
                        postItem = result;
                      });
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                child: ListTile(
                  leading: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  title: const Text(
                    'Delete Post',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () async {
                    final bool isDeleted = await _deletePost(
                        context, postItem['postId'], postItem['postImageUrl']);
                    if (isDeleted) {
                      Navigator.pop(context);
                      Navigator.pop(context, post['postId']);
                    }
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future<bool> _deletePost(
      BuildContext context, String postId, String postImageUrl) async {
    try {
      // delete the image in the firebase storage
      final existingImageRef =
          FirebaseStorage.instance.refFromURL(postImageUrl);
      await existingImageRef.delete();
      // delete the document
      await FirebaseFirestore.instance.collection('posts').doc(postId).delete();
      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post deleted successfully')),
      );
      return true;
    } catch (e) {
      print('Error deleting post: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete post')),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final curUser = Provider.of<UserProvider>(context).currentUser;
    print(postItem['userId']);
    print(curUser['userId']);
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(children: [
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
                  ]),
                  // show this only if the user owns the post
                  // curUser.userid == post.userid ==> show
                  if (curUser['userId'] == postItem['userId'])
                    GestureDetector(
                      onTap: () => _showBottomSheet(context, postItem),
                      child: const Icon(Icons.more_vert_sharp),
                    )
                ],
              ),
            ),
            // Post Image
            Container(
              height: 500,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(postItem['postImageUrl']),
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
                      postItem['caption'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    Row(
                      children: postItem['tags'].map<Widget>((tag) {
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
