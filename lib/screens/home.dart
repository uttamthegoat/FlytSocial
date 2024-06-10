import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  final List<Post> posts = [
    Post(
      username: 'vipul',
      userImage: 'assets/applogo.png',
      postImage: 'assets/applogo.png',
      caption: 'Enjoying the sunshine!',
      tags: '#summer',
      likes: 0,
      isLiked: false,
      comments: [],
    ),
    Post(
      username: 'vipul nayak',
      userImage: 'assets/applogo.png',
      postImage: 'assets/applogo.png',
      caption: 'Had a great time hiking today.',
      tags: '#hiking #outdoors',
      likes: 0,
      isLiked: false,
      comments: [],
    ),
    Post(
      username: 'vipul nayak11',
      userImage: 'assets/applogo.png',
      postImage: 'assets/applogo.png',
      caption: 'Lovely view from the top!',
      tags: '#view #mountains',
      likes: 0,
      isLiked: false,
      comments: [],
    ),
    Post(
      username: 'susan_l',
      userImage: 'assets/applogo.png',
      postImage: 'assets/applogo.png',
      caption: 'Delicious brunch with friends.',
      tags: '#brunch #friends',
      likes: 0,
      isLiked: false,
      comments: [],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instagram'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return PostWidget(post: posts[index]);
        },
      ),
    );
  }
}

class Post {
  final String username;
  final String userImage;
  final String postImage;
  final String caption;
  final String tags;
  int likes;
  bool isLiked;
  List<Comment> comments;

  Post({
    required this.username,
    required this.userImage,
    required this.postImage,
    required this.caption,
    required this.tags,
    this.likes = 0,
    this.isLiked = false,
    required this.comments,
  });
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
  final Post post;

  PostWidget({required this.post});

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  final String currentUser = 'current_user';

  void _toggleLike() {
    setState(() {
      if (widget.post.isLiked) {
        widget.post.likes--;
        widget.post.isLiked = false;
      } else {
        widget.post.likes++;
        widget.post.isLiked = true;
      }
    });
  }

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
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(widget.post.userImage),
            ),
            title: Text(
              widget.post.username,
              style: TextStyle(fontSize: 16.0), // Adjust font size here
            ),
          ),
          Image.asset(widget.post.postImage),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        widget.post.isLiked ? Icons.favorite : Icons.favorite_border,
                        color: widget.post.isLiked ? Colors.red : null,
                      ),
                      onPressed: _toggleLike,
                    ),
                    Text('${widget.post.likes}'),
                    SizedBox(width: 16.0),
                    IconButton(
                      icon: Icon(Icons.comment),
                      onPressed: () => _showComments(context),
                    ),
                  ],
                ),
                Text(
                  widget.post.caption,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.post.tags,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CommentSection extends StatefulWidget {
  final Post post;
  final String currentUser;

  CommentSection({required this.post, required this.currentUser});

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final TextEditingController _commentController = TextEditingController();

  void _addComment() {
    if (_commentController.text.isNotEmpty) {
      setState(() {
        widget.post.comments.add(Comment(
          username: widget.currentUser,
          content: _commentController.text,
        ));
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
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.post.comments.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          widget.post.comments[index].username,
                          style: TextStyle(fontSize: 16.0), // Adjust font size here
                        ),
                        subtitle: Text(
                          widget.post.comments[index].content,
                          style: TextStyle(fontSize: 16.0), // Adjust font size here
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
                    decoration: InputDecoration(hintText: 'Add a comment...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
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
