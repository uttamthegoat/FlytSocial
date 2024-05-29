import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<void> _refreshProfile() async {
    // Simulate network request or any data fetching logic
    await Future.delayed(Duration(seconds: 2));

    // After fetching new data, update the state if necessary
    setState(() {
      // Update your profile data here
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.deepPurple,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshProfile,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildProfileHeader(),
              _buildProfileDetails(),
              _buildProfileActions(),
              _buildTabs(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(
                'https://i.pinimg.com/736x/36/7e/39/367e39a52d963b9ac380c9ea3012ca25.jpg'), // Replace with your image URL
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Username',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.deepPurple,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatColumn('Posts', '100'),
                    _buildStatColumn('Followers', '1K'),
                    _buildStatColumn('Following', '500'),
                  ],
                ),
                SizedBox(height: 16),
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

  Widget _buildProfileDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          Text(
            'Vipulnayak-The One piece is real',
            style: TextStyle(
              color: Colors.black87,
            ),
          ),
          Text(
            'Website link goes here',
            style: TextStyle(
              color: Colors.blue,
              // decoration: TextDecoration,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
          TabBar(
            indicatorColor: Colors.deepPurple,
            tabs: [
              Tab(icon: Icon(Icons.grid_on, color: Colors.deepPurple)),
            ],
          ),
          SizedBox(
            height: 400, // Adjust the height as needed
            child: TabBarView(
              children: [
                _buildGridPosts(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridPosts() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemBuilder: (context, index) {
        return Container(
          color: Colors.grey[300],
          child: Image.network(
            'https://i.pinimg.com/736x/36/7e/39/367e39a52d963b9ac380c9ea3012ca25.jpg', // Replace with your image URL
            fit: BoxFit.cover,
          ),
        );
      },
      itemCount: 30,
    );
  }

  Widget _buildStatColumn(String label, String count) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text(label),
      ],
    );
  }

  Widget _buildButton(String text) {
    return OutlinedButton(
      onPressed: () {
        // Handle button press
        if (text == 'Sign Out') {
          // Implement sign out functionality here
        }
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.deepPurple,
        side: BorderSide(color: Colors.deepPurple),
      ),
      child: Text(text),
    );
  }
}
