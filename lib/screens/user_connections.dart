import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flytsocial/screens/users_profile.dart';

class UserConnections extends StatefulWidget {
  final String currentUserId;

  const UserConnections({
    super.key,
    required this.currentUserId,
  });

  @override
  _UserConnectionsState createState() => _UserConnectionsState();
}

class _UserConnectionsState extends State<UserConnections>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<Map<String, String>> myFollowers = [];
  late List<Map<String, String>> myFollowing = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String currentUserId = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    setFollowInfo();
  }

  void setFollowInfo() async {
    // fetch followers and store in
    currentUserId = widget.currentUserId;
    await fetchFollowers(currentUserId);
    await fetchFollowing(currentUserId);
  }

  Future<void> fetchFollowers(String userId) async {
    try {
      // Query to find all documents where 'following' matches the userId
      final QuerySnapshot snapshot = await _firestore
          .collection('follow')
          .where('following', isEqualTo: userId)
          .get();
      // Extracting follower IDs from the documents
      List<String> followerIds =
          snapshot.docs.map((doc) => doc['follower'] as String).toList();

      // Fetching details for each following ID from the 'users' collection
      List<Map<String, String>> followerUsers = [];
      for (String followerId in followerIds) {
        DocumentSnapshot userSnapshot =
            await _firestore.collection('users').doc(followerId).get();
        if (userSnapshot.exists) {
          Map<String, String> userDetails = convertMapValuesToString({
            'userId': followerId,
            'name': userSnapshot['name'],
            'email': userSnapshot['email'],
            'imageUrl': userSnapshot['imageUrl'],
            'bio': userSnapshot['bio'],
            'username': userSnapshot['username'],
          });
          followerUsers.add(userDetails);
        }
      }
      setState(() {
        myFollowers = followerUsers;
      });
      // You can use this list to update your UI or state management as needed
    } catch (e) {
      print('Error fetching followers: $e');
    }
  }

  Future<void> fetchFollowing(String userId) async {
    try {
      // Query to find all documents where 'follower' matches the userId
      final QuerySnapshot snapshot = await _firestore
          .collection('follow')
          .where('follower', isEqualTo: userId)
          .get();
      // Extracting following IDs from the documents
      List<String> followingIds =
          snapshot.docs.map((doc) => doc['following'] as String).toList();

      // Fetching details for each following ID from the 'users' collection
      List<Map<String, String>> followingUsers = [];
      for (String followingId in followingIds) {
        DocumentSnapshot userSnapshot =
            await _firestore.collection('users').doc(followingId).get();
        if (userSnapshot.exists) {
          Map<String, String> userDetails = convertMapValuesToString({
            'userId': followingId,
            'name': userSnapshot['name'],
            'email': userSnapshot['email'],
            'imageUrl': userSnapshot['imageUrl'],
            'bio': userSnapshot['bio'],
            'username': userSnapshot['username'],
          });
          followingUsers.add(userDetails);
        }
      }
      setState(() {
        myFollowing = followingUsers;
      });
    } catch (e) {
      print('Error fetching following: $e');
    }
  }

  Map<String, String> convertMapValuesToString(
      Map<String, dynamic> originalMap) {
    return originalMap.map((key, value) => MapEntry(key, value.toString()));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connections'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Followers'),
            Tab(text: 'Following'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          UserList(
              users: myFollowers, type: 'Followers', curUserId: currentUserId),
          UserList(
              users: myFollowing, type: 'Following', curUserId: currentUserId),
        ],
      ),
    );
  }
}

class UserList extends StatelessWidget {
  final List users;
  final String type;
  final String curUserId;

  const UserList({
    super.key,
    required this.users,
    required this.type,
    required this.curUserId,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage:
                NetworkImage(user['imageUrl']), // Placeholder for user image
          ),
          title: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return UserProfile(
                      user: user,
                      curUserId: curUserId,
                    );
                  },
                ),
              );
            },
            child: Text(user['username']),
          ), // Placeholder for username
          trailing: type == 'Following'
              ? OutlinedButton(
                  onPressed: () {
                    // Handle unfollow action
                  },
                  child: const Text('Unfollow'),
                )
              : null,
        );
      },
    );
  }
}
