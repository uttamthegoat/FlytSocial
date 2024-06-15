import 'package:flutter/material.dart';
import 'package:flytsocial/state/user_provider.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  final dynamic currentUser;
  const Home({super.key, required this.currentUser});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Map<String, dynamic>> postResults = [
    {
      'postId': '1',
      'caption': 'Nature is lovely',
      'tags': ['nature', 'hills'],
      'postImageUrl': 'https://via.placeholder.com/152',
      'userId': '12'
    },
    {
      'postId': '2',
      'caption': 'Adventure awaits',
      'tags': ['adventure', 'travel'],
      'postImageUrl': 'https://via.placeholder.com/153',
      'userId': '13'
    },
    {
      'postId': '3',
      'caption': 'City life',
      'tags': ['city', 'urban'],
      'postImageUrl': 'https://via.placeholder.com/154',
      'userId': '14'
    }
  ];

  @override
  Widget build(BuildContext context) {
    print(Provider.of<UserProvider>(context).currentUser);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: ListView.builder(
        itemCount: postResults.length,
        itemBuilder: (context, index) {
          return PostWidget(post: postResults[index]);
        },
      ),
    );
  }
}

class Comment {
  final String username;
  final String content;

  Comment({
    required this.username,
    required this.content,
  });
}

class PostWidget extends StatefulWidget {
  final Map<String, dynamic> post;

  PostWidget({required this.post});

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  final String currentUser = 'current_user';
  late bool isLiked = false;
  late int likeCount = 0;
  late Map<String, dynamic> postItem = {};

  @override
  void initState() {
    super.initState();
    postItem = widget.post;
  }

  void _likePost() {}

  void _showComments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return CommentSection(post: widget.post, currentUser: currentUser);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // Removes the border radius
      ),
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(postItem['postImageUrl']),
            ),
            title: const Text(
              'Username',
              style: TextStyle(fontSize: 16.0), // Adjust font size here
            ),
          ),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : null,
                      ),
                      onPressed: _likePost,
                    ),
                    Text('$likeCount'),
                    const SizedBox(width: 16.0),
                    IconButton(
                      icon: const Icon(Icons.comment),
                      onPressed: () => _showComments(context),
                    ),
                  ],
                ),
                Text(
                  postItem['caption'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
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
            ),
          ),
        ],
      ),
    );
  }
}

// comment section
class CommentSection extends StatefulWidget {
  final Map<String, dynamic> post;
  final String currentUser;

  CommentSection({required this.post, required this.currentUser});

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final TextEditingController _commentController = TextEditingController();
  late int commentCount = 0;
  late List<Map<String, dynamic>> _postComments = [];

  @override
  void initState() {
    super.initState();
    // fetch the comments from the database based on the postId
  }

  void _addComment() {
    if (_commentController.text.isNotEmpty) {
      setState(() {
        _commentController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: commentCount,
                    itemBuilder: (context, index) {
                      final comment = _postComments[index];
                      return ListTile(
                        title: const Text(
                          'username',
                          style: TextStyle(
                              fontSize: 16.0), // Adjust font size here
                        ),
                        subtitle: Text(
                          comment['comment'],
                          style: const TextStyle(
                              fontSize: 16.0), // Adjust font size here
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration:
                        const InputDecoration(hintText: 'Add a comment...'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _addComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
