import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flytsocial/screens/edit_post.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Home extends StatefulWidget {
  final dynamic currentUser;
  const Home({super.key, required this.currentUser});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<Map<String, dynamic>> postResults = [];
  late String currentUserId = '';

  @override
  void initState() {
    super.initState();
    currentUserId = widget.currentUser['userId'];
    fetchFollowingPosts();
  }

  Future<void> fetchFollowingPosts() async {
    List<Map<String, dynamic>> posts = [];
    currentUserId = widget.currentUser['userId'];
    // print(currentUserId);
    try {
      // Step 1: Get the list of user IDs that the current user follows
      QuerySnapshot followSnapshot = await FirebaseFirestore.instance
          .collection('follow')
          .where('follower', isEqualTo: currentUserId)
          .get();

      List<String> followingIds =
          followSnapshot.docs.map((doc) => doc['following'] as String).toList();

      // Step 2: Get the posts from these following users
      if (followingIds.isNotEmpty) {
        QuerySnapshot postSnapshot = await FirebaseFirestore.instance
            .collection('posts')
            .where('userId', whereIn: followingIds)
            .get();

        posts = postSnapshot.docs.map((doc) {
          Map<String, dynamic> postData = doc.data() as Map<String, dynamic>;
          postData['postId'] = doc.id; // Add postId to the post data
          return postData;
        }).toList();

        setState(() {
          postResults = posts;
        });
        print(posts);
      }
    } catch (e) {
      print('Error fetching following posts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Home',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 23, color: Colors.white),
          ),
          backgroundColor: Colors.black,
        ),
        body: Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: SingleChildScrollView(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: postResults.length,
                itemBuilder: (context, index) {
                  return PostWidget(
                    post: postResults[index],
                    curUserId: currentUserId,
                  );
                },
              ),
            )));
  }
}

class PostWidget extends StatefulWidget {
  final Map<String, dynamic> post;
  final String curUserId;
  const PostWidget({super.key, required this.post, required this.curUserId});

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostWidget> {
  bool _isLiked = false;
  int _likeCount = 0;
  late String curUserId = "";
  final TextEditingController _commentController = TextEditingController();
  final List<String> _comments = [];
  late Map<String, dynamic> postItem = {};
  late Map<String, String> postOwner = {};
  late bool loading = false;
  late bool postLoading = false;

  @override
  void initState() {
    super.initState();
    setPostInfo();
  }

  void setPostInfo() async {
    setState(() {
      postItem = widget.post;
      curUserId = widget.curUserId;
    });
    final currentPostId = postItem['postId'];
    await getLikeInfo(currentPostId, curUserId);
    await setPostOwner();
    setState(() {
      postLoading = true;
    });
  }

  Future<void> getLikeInfo(String currentPostId, String curUserId) async {
    try {
      // Get the count of likes for the post
      final likeQuerySnapshot = await FirebaseFirestore.instance
          .collection('likes')
          .where('postId', isEqualTo: currentPostId)
          .get();
      int likeCount = likeQuerySnapshot.docs.length;

      // Check if the current user has liked the post
      final userLikeQuerySnapshot = await FirebaseFirestore.instance
          .collection('likes')
          .where('postId', isEqualTo: currentPostId)
          .where('userId', isEqualTo: curUserId)
          .get();
      bool isLiked = userLikeQuerySnapshot.docs.isNotEmpty;

      // Use likeCount and _isLiked as needed in your widget's state
      setState(() {
        _likeCount = likeCount;
        _isLiked = isLiked;
      });
    } catch (e) {
      print('Error fetching like info: $e');
    }
  }

  Future<void> setPostOwner() async {
    final userId = postItem['userId'];
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      Map<String, dynamic> userDetails =
          userSnapshot.data() as Map<String, dynamic>;
      userDetails['userId'] = userId;

      // Convert all values to strings
      Map<String, String> userInfo =
          userDetails.map((key, value) => MapEntry(key, value.toString()));
      setState(() {
        postOwner = userInfo;
        loading = true;
      });
      print(" this is the postOwner $postOwner");
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }

  void _likePost() async {
    try {
      if (!_isLiked) {
        await FirebaseFirestore.instance.collection('likes').add({
          'postId': postItem['postId'],
          'userId': curUserId,
        });
        setState(() {
          _isLiked = true;
          _likeCount = _likeCount + 1;
        });
      } else {
        final likeDocSnapshot = await FirebaseFirestore.instance
            .collection('likes')
            .where('postId', isEqualTo: postItem['postId'])
            .where('userId', isEqualTo: curUserId)
            .get();
        if (likeDocSnapshot.docs.isNotEmpty) {
          // Remove the like document
          await FirebaseFirestore.instance
              .collection('likes')
              .doc(likeDocSnapshot.docs.first.id)
              .delete();
          // Update the state
          setState(() {
            _isLiked = false;
            _likeCount -= 1;
          });
        }
      }
    } catch (e) {
      print('Error liking post: $e');
    }
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
        const SnackBar(content: Text('Post deleted successfully')),
      );
      return true;
    } catch (e) {
      print('Error deleting post: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete post')),
      );
      return false;
    }
  }

  // open comments
  void _showComments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.9,
          child: CommentSection(post: postItem, currentUser: postOwner),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 30),
      child: postLoading
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // user info
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(loading
                                ? (postOwner['imageUrl'] == ''
                                    ? 'https://via.placeholder.com/150'
                                    : postOwner['imageUrl']!)
                                : 'https://via.placeholder.com/150'),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            loading ? postOwner['username'] ?? '' : 'Username',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ]),
                        // show this only if the user owns the post
                        // curUserId == post.userid ==> show
                        if (curUserId == postItem['userId'])
                          GestureDetector(
                            onTap: () => _showBottomSheet(context, postItem),
                            child: const Icon(Icons.more_vert_sharp),
                          )
                      ],
                    )),
                // Post Image
                Container(
                  width: double.infinity, // Full width of the device
                  // color: Colors.black,
                  child: CachedNetworkImage(
                    imageUrl: postItem['postImageUrl'],
                    fit: BoxFit
                        .fitWidth, // Ensure the image fits the device width
                    placeholder: (context, url) => const Center(
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: SizedBox(
                          height: 60,
                          width: 60,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                // Like and Comment Buttons
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              _isLiked ? Icons.favorite : Icons.favorite_border,
                              color: _isLiked ? Colors.red : Colors.black,
                            ),
                            onPressed: _likePost,
                          ),
                          Text('$_likeCount')
                        ],
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.comment),
                        onPressed: () => _showComments(context),
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
                                  right:
                                      8.0), // Adjust the padding value as needed
                              child: Text(
                                '#$tag',
                                style: const TextStyle(color: Colors.blue),
                              ),
                            );
                          }).toList(),
                        )
                      ],
                    )),
              ],
            )
          : const Center(
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 200),
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(),
                  )),
            ),
    );
  }
}

// comment section
class CommentSection extends StatefulWidget {
  final Map<String, dynamic> post;
  final Map<String, String> currentUser;

  CommentSection({required this.post, required this.currentUser});

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final TextEditingController _commentController = TextEditingController();
  late int commentCount = 0;
  late List<Map<String, String>> _postComments = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late bool loading = false;

  @override
  void initState() {
    super.initState();
    // fetch the comments from the database based on the postId
    getComments();
  }

  Future<void> getComments() async {
    final String postId = widget.post['postId'];
    try {
      // Fetch all comments for the given postId
      QuerySnapshot commentSnapshot = await FirebaseFirestore.instance
          .collection('comments')
          .where('postId', isEqualTo: postId)
          .get();
      // Iterate over each comment document
      for (var commentDoc in commentSnapshot.docs) {
        String commentText = commentDoc['comment'];
        String userId = commentDoc['userId'];
        // Fetch username from the users collection based on userId
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
        if (userSnapshot.exists) {
          String username = userSnapshot['username'];
          // Create a map with the comment details
          Map<String, String> commentDetails = {
            'comment': commentText,
            'postId': postId,
            'userId': userId,
            'username': username,
          };
          // Add the map to the comments list
          setState(() {
            _postComments.add(commentDetails);
          });
        }
      }
      setState(() {
        loading = true;
      });
    } catch (e) {
      print('Error fetching comments: $e');
    }
  }

  void addComment(String commentText) async {
    if (commentText.isNotEmpty) {
      final String postId = widget.post['postId'];
      final Map<String, String> currentUser = widget.currentUser;
      try {
        Map<String, String> newComment = {
          'comment': commentText,
          'postId': postId,
          'userId': currentUser['userId']!,
          'username': currentUser['username']!,
        };
        await _firestore.collection('comments').add({
          'comment': newComment['comment'],
          'postId': newComment['postId'],
          'userId': newComment['userId'],
        });
        setState(() {
          _postComments.add(newComment);
          print(_postComments);
          _commentController.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comment succesfully posted.')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding comment: $e')),
        );
      }
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
                  loading
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _postComments.length,
                          itemBuilder: (context, index) {
                            final comment = _postComments[index];
                            return ListTile(
                              title: Text(
                                comment['username'] ?? '',
                                style: const TextStyle(
                                    fontSize: 16.0), // Adjust font size here
                              ),
                              subtitle: Text(
                                comment['comment']!,
                                style: const TextStyle(
                                    fontSize: 16.0), // Adjust font size here
                              ),
                            );
                          },
                        )
                      : Container(
                          child: const Center(
                            child: Text('Loading...'),
                          ),
                        ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Comment here...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      hintStyle:
                          const TextStyle(color: Colors.black, fontSize: 18),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear, color: Colors.black),
                        onPressed: () {
                          setState(() {
                            _commentController.clear();
                          });
                        },
                      ),
                    ),
                    style: const TextStyle(color: Colors.black, fontSize: 18.0),
                    cursorColor: Colors.black,
                    onSubmitted: (String value) => addComment(value),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
