import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flytsocial/screens/edit_profile.dart';
import 'package:flytsocial/screens/post_item.dart';
import 'package:flytsocial/screens/user_connections.dart';
import 'package:flytsocial/state/user_provider.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  final dynamic user;
  const Profile({super.key, required this.user});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late var postResults = [];
  late int followersCount = 0;
  late int followingCount = 0;
  late int postsCount = 0;

  @override
  void initState() {
    super.initState();
    getProfileInfo();
  }

  Future<void> getProfileInfo() async {
    try {
      final curUserId = widget.user['userId'];
      print(widget.user);
      // Fetch followers count
      final followersSnapshot = await FirebaseFirestore.instance
          .collection('follow')
          .where('following', isEqualTo: curUserId)
          .get();

      // Fetch following count
      final followingSnapshot = await FirebaseFirestore.instance
          .collection('follow')
          .where('follower', isEqualTo: curUserId)
          .get();

      // Query to find posts where the userId matches curUserId
      final querySnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('userId', isEqualTo: curUserId)
          .get();

      // Map the documents to a list of maps
      var posts = querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['postId'] = doc.id;
        return data;
      }).toList();

      // Update the state with the fetched posts
      setState(() {
        followersCount = followersSnapshot.docs.length;
        followingCount = followingSnapshot.docs.length;
        postResults = posts;
        postsCount = posts.length;
      });
    } catch (e) {
      print('Error fetching profile info: $e');
    }
  }

  Future<void> _refreshProfile() async {
    // Simulate network request or any data fetching logic
    await Future.delayed(const Duration(seconds: 2));
    await getProfileInfo();
  }

  @override
  Widget build(BuildContext context) {
    final curUser = widget.user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.deepPurple,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshProfile,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildProfileHeader(
                  curUser, postsCount, followersCount, followingCount),
              _buildProfileDetails(curUser),
              _buildProfileActions(),
              _buildTabs(curUser),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(Map<String, dynamic> curUser, int postsCount,
      int followersCount, int followingCount) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(curUser['imageUrl'] == ''
                ? 'https://via.placeholder.com/150'
                : curUser['imageUrl']), // Replace with your image URL
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 23),
                  child: Text(
                    curUser['username'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatColumn('Posts', '$postsCount', curUser),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return UserConnections(
                                currentUserId: curUser['userId'],
                              );
                            },
                          ),
                        );
                      },
                      child: _buildStatColumn(
                          'Followers', '$followersCount', curUser),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return UserConnections(
                                currentUserId: curUser['userId'],
                              );
                            },
                          ),
                        );
                      },
                      child: _buildStatColumn(
                          'Following', '$followingCount', curUser),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildButton('Edit Profile'),
                    _buildButton('Sign Out'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetails(Map<String, dynamic> curUser) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          alignment: AlignmentDirectional.centerStart,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Text(
                  curUser['name'],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
              // const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Text(
                  curUser['email'],
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Text(
                  curUser['bio'],
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildProfileActions() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // _buildButton('Message'),
        ],
      ),
    );
  }

  Widget _buildTabs(dynamic curUser) {
    return DefaultTabController(
      length: 1,
      child: Column(
        children: [
          const TabBar(
            indicatorColor: Colors.deepPurple,
            tabs: [
              Tab(icon: Icon(Icons.grid_on, color: Colors.deepPurple)),
            ],
          ),
          _buildGridPosts(curUser)
        ],
      ),
    );
  }

  Widget _buildGridPosts(dynamic curUser) {
    return GridView.builder(
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
        return GestureDetector(
          onTap: () async {
            final deletedPostId = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PostItem(post: post, curUserId: curUser['userId']),
              ),
            );
            if (deletedPostId != null) {
              setState(() {
                postResults
                    .removeWhere((post) => post['postId'] == deletedPostId);
              });
            }
          },
          child: Container(
            color: Colors.grey[300],
            child: Image.network(
              post['postImageUrl'],
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatColumn(
      String label, String count, Map<String, dynamic> curUser) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text(label),
      ],
    );
  }

  Widget _buildButton(String text) {
    return OutlinedButton(
      onPressed: () async {
        // Handle button press
        if (text == 'Sign Out') {
          // Implement sign out functionality here
          await Provider.of<UserProvider>(context, listen: false).signOut();
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditProfile(user: widget.user),
            ),
          );
        }
      },
      style: OutlinedButton.styleFrom(
        foregroundColor:
            text == "Sign Out" ? Colors.red[800] : Colors.deepPurple,
        side: BorderSide(
            color: text == "Sign Out" ? Colors.red : Colors.deepPurple),
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
