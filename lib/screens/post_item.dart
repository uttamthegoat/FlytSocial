import 'package:flutter/material.dart';

class PostItem extends StatefulWidget {
  const PostItem({Key? key}) : super(key: key);

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  bool _isExpanded = false;
  bool _isLiked = false;
  int _commentCount = 0;
  TextEditingController _commentController = TextEditingController();

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
      _commentCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    backgroundImage: NetworkImage(
                      'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse3.mm.bing.net%2Fth%3Fid%3DOIP.NKmW4Br5F_PRJzZtLUJAcQHaEK%26pid%3DApi&f=1&ipt=9197b404c87ed115200584a4945895e2efe69a66e76f21b1caaf4b79c2898ef2&ipo=images',
                    ),
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
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse3.mm.bing.net%2Fth%3Fid%3DOIP.NKmW4Br5F_PRJzZtLUJAcQHaEK%26pid%3DApi&f=1&ipt=9197b404c87ed115200584a4945895e2efe69a66e76f21b1caaf4b79c2898ef2&ipo=images'),
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
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.comment),
                        onPressed: _incrementCommentCount,
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: _commentCount > 0
                            ? Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  '$_commentCount',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : Container(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Post Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: 'Username ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: ' #dbz #vegeta',
                    ),
                  ],
                ),
              ),
            ),
            // Comment Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: _toggleExpand,
                child: Text(
                  _isExpanded ? 'Hide comments' : 'View all comments',
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            ),
            if (_isExpanded)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dummy comments, replace with actual data
                    const ListTile(
                      title: Text('Comment 1: This is a great post!'),
                    ),
                    const ListTile(
                      title: Text('Comment 2: Love this!'),
                    ),
                    const ListTile(
                      title: Text('Comment 3: Amazing!'),
                    ),
                    // Text Field for Adding Comments
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: 'Add a comment...',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () {
                              // Handle comment sending
                              // For demonstration, just increment comment count
                              _incrementCommentCount();
                              _commentController.clear();
                            },
                          ),
                        ),
                      ),
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
