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

    setState(() {
      followersCount = followersSnapshot.docs.length;
      followingCount = followingSnapshot.docs.length;
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

  final List<Map<String, dynamic>> _allPosts = [
    {
      'id': '1',
      'postImageUrl':
          'https://via.placeholder.com/150/0000FF/808080?Text=Post1',
      'caption': 'I am the goat',
      'userId': '1',
      'tags': ['goat', 'nature', 'man'],
    },
    {
      'id': '2',
      'postImageUrl':
          'https://via.placeholder.com/150/FF0000/FFFFFF?Text=Post2',
      'caption': 'Beautiful sunset',
      'userId': '2',
      'tags': ['sunset', 'nature', 'sky'],
    },
    {
      'id': '3',
      'postImageUrl':
          'https://via.placeholder.com/150/FFFF00/000000?Text=Post3',
      'caption': 'Delicious food',
      'userId': '3',
      'tags': ['food', 'delicious', 'meal'],
    },
    {
      'id': '4',
      'postImageUrl':
          'https://via.placeholder.com/150/00FF00/0000FF?Text=Post4',
      'caption': 'At the beach',
      'userId': '4',
      'tags': ['beach', 'sea', 'sand'],
    },
    {
      'id': '5',
      'postImageUrl':
          'https://via.placeholder.com/150/800080/FFFFFF?Text=Post5',
      'caption': 'Mountain hike',
      'userId': '5',
      'tags': ['hiking', 'mountains', 'adventure'],
    },
    {
      'id': '6',
      'postImageUrl':
          'https://via.placeholder.com/150/FFA500/000000?Text=Post6',
      'caption': 'City lights',
      'userId': '6',
      'tags': ['city', 'lights', 'night'],
    },
    {
      'id': '7',
      'postImageUrl':
          'https://via.placeholder.com/150/FFC0CB/000000?Text=Post7',
      'caption': 'Chilling with friends',
      'userId': '7',
      'tags': ['friends', 'chill', 'fun'],
    },
    {
      'id': '8',
      'postImageUrl':
          'https://via.placeholder.com/150/000000/FFFFFF?Text=Post8',
      'caption': 'Exploring the forest',
      'userId': '8',
      'tags': ['forest', 'exploration', 'nature'],
    },
  ];

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
              itemCount: _allPosts.length,
              itemBuilder: (context, index) {
                final post = _allPosts[index];
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
