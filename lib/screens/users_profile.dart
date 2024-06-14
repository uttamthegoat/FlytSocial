import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flytsocial/screens/post_item.dart';

class UserProfile extends StatefulWidget {
  final Map<String, String> user;
  final String curUser;

  const UserProfile({super.key, required this.user, required this.curUser});
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfile> {
  late bool isFollowing = false;
  late int followersCount = 0;
  late int followingCount = 0;
  late int postsCount = 8;
  late List<Map<String, dynamic>> postResults = [];

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future<void> checkIfFollowing() async {
    final userProfile = widget.user['userId'];
    final curUser = widget.curUser;
    print(userProfile);
    print(curUser);
    final docSnapshot = await FirebaseFirestore.instance
        .collection('follow')
        .where('follower', isEqualTo: curUser)
        .where('following', isEqualTo: userProfile)
        .get();
    setState(() {
      isFollowing = docSnapshot.docs.isNotEmpty;
    });
  }

  Future<void> getUserInfo() async {
    final userProfile = widget.user['userId'];

    // Fetch followers count
    final followersSnapshot = await FirebaseFirestore.instance
        .collection('follow')
        .where('following', isEqualTo: userProfile)
        .get();

    // Fetch following count
    final followingSnapshot = await FirebaseFirestore.instance
        .collection('follow')
        .where('follower', isEqualTo: userProfile)
        .get();

    // Query to find posts where the userId matches curUserId
    final querySnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .where('userId', isEqualTo: userProfile)
        .get();

    // Map the documents to a list of maps
    var posts = querySnapshot.docs.map((doc) {
      var data = doc.data();
      data['postId'] = doc.id;
      return data;
    }).toList();

    setState(() {
      followersCount = followersSnapshot.docs.length;
      followingCount = followingSnapshot.docs.length;
      postResults = posts;
    });
    // check if the loggedin user follows this profile
    await checkIfFollowing();
  }

  void toggleFollow(BuildContext context, Map<String, String> user) async {
    final String curUser = widget.curUser;
    final String userProfile = user['userId']!;

    if (isFollowing) {
      final snapshot = await FirebaseFirestore.instance
          .collection('follow')
          .where('follower', isEqualTo: curUser)
          .where('following', isEqualTo: userProfile)
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
      setState(() {
        followersCount--;
        isFollowing = false;
      });
    } else {
      await FirebaseFirestore.instance.collection('follow').add({
        'follower': curUser,
        'following': userProfile,
      });
      setState(() {
        followersCount++;
        isFollowing = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    return Scaffold(
      appBar: AppBar(
        title: Text(user['username'] ?? 'Unknown User'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 45,
                    backgroundImage: NetworkImage(
                        user['imageUrl'] ?? 'https://via.placeholder.com/150'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            _buildStatColumn(postsCount, 'Posts'),
                            _buildStatColumn(followersCount, 'Followers'),
                            _buildStatColumn(followingCount, 'Following'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => toggleFollow(context, user),
                          child: Text(isFollowing ? 'Following' : 'Follow'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: AlignmentDirectional.centerStart,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      '${user['name']}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        '${user['bio']}',
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Divider(thickness: 1),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              itemCount: postResults.length,
              itemBuilder: (context, index) {
                final post = postResults[index];
                return IndividualPost(post: post);
              },
            ),
          ],
        ),
      ),
    );
  }

  Column _buildStatColumn(int count, String label) {
    return Column(
      children: <Widget>[
        Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class IndividualPost extends StatelessWidget {
  final Map<String, dynamic> post;

  IndividualPost({required this.post});

  @override
  Widget build(BuildContext context) {
    print(post['imageUrl']);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostItem(post: post),
          ),
        );
      },
      child: Container(
        color: Colors.grey[300],
        child: Image.network(
          post['postImageUrl'],
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
