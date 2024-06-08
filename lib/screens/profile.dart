import 'package:flutter/material.dart';
import 'package:flytsocial/screens/users_profile.dart';
import 'package:flytsocial/state/user_provider.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<void> _refreshProfile() async {
    // Simulate network request or any data fetching logic
    await Future.delayed(const Duration(seconds: 2));

    // After fetching new data, update the state if necessary
    setState(() {
      // Update your profile data here
    });
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
      'id': '4',
      'postImageUrl':
          'https://via.placeholder.com/150/00FF00/0000FF?Text=Post4',
      'caption': 'At the beach',
      'userId': '4',
      'tags': ['beach', 'sea', 'sand'],
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
      'id': '4',
      'postImageUrl':
          'https://via.placeholder.com/150/00FF00/0000FF?Text=Post4',
      'caption': 'At the beach',
      'userId': '4',
      'tags': ['beach', 'sea', 'sand'],
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
    // final user = Provider.of<UserProvider>(context).user;
    final curUser = Provider.of<UserProvider>(context).currentUser;
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
            children: [
              _buildProfileHeader(curUser),
              _buildProfileDetails(curUser),
              _buildProfileActions(),
              _buildTabs(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(Map<String, dynamic> curUser) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(
                curUser['imageUrl']), // Replace with your image URL
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  curUser['username'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatColumn('Posts', '100'),
                    _buildStatColumn('Followers', '1K'),
                    _buildStatColumn('Following', '500'),
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
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          Text(
            curUser['bio'],
            style: const TextStyle(
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
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

  Widget _buildTabs() {
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
          _buildGridPosts()
        ],
      ),
    );
  }

  Widget _buildGridPosts() {
    return GridView.builder(
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
    );
  }

  Widget _buildStatColumn(String label, String count) {
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
