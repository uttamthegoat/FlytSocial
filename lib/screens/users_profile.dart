import 'package:flutter/material.dart';
import 'package:flytsocial/screens/post_item.dart';

class UserProfile extends StatefulWidget {
  final Map<String, String> user;

  const UserProfile({super.key, required this.user});
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfile> {
  bool isFollowing = false;
  int followersCount = 120;
  int postsCount = 8;

  void toggleFollow() {
    setState(() {
      if (isFollowing) {
        followersCount--;
      } else {
        followersCount++;
      }
      isFollowing = !isFollowing;
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
                            _buildStatColumn(200, 'Following'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: toggleFollow,
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
          'https://via.placeholder.com/152',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Column _buildStatColumn(int count, String label) {
    return Column(
      children: <Widget>[
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
