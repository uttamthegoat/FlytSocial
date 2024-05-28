import 'package:flutter/material.dart';

class AppSearch extends StatelessWidget {
  const AppSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(
              Icons.search,
              size: 30, // Adjust the size as needed
            ),
            SizedBox(width: 10), // Add some space between the icon and the text
            Text(
              'Search',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
          ],
        ),
      ),
      body: Container(
        child: const SearchScreen(),
      ),
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Sample user data
  final List<Map<String, String>> _users = [
    {
      'id': '1',
      'image': 'https://via.placeholder.com/150',
      'username': 'username1',
      'name': 'name',
    },
    {
      'id': '2',
      'image': 'https://via.placeholder.com/150',
      'username': 'username2',
      'name': 'name',
    },
    {
      'id': '3',
      'image': 'https://via.placeholder.com/150',
      'username': 'username3',
      'name': 'name',
    },
    {
      'id': '4',
      'image': 'https://via.placeholder.com/150',
      'username': 'username4',
      'name': 'name',
    },
    // Add more user data as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search here...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white, fontSize: 18),
          ),
          style: const TextStyle(color: Colors.white, fontSize: 18.0),
          cursorColor: Colors.white,
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1, // Number of columns in grid
            childAspectRatio: 5 / 1, // Aspect ratio for each tile
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: _users.length,
          itemBuilder: (context, index) {
            final user = _users[index];
            return UserTile(
              imageUrl: user['image']!,
              username: user['username']!,
              name: user['name']!,
            );
          },
        ),
      ),
    );
  }
}

class UserTile extends StatelessWidget {
  final String imageUrl;
  final String username;
  final String name;

  UserTile({
    required this.imageUrl,
    required this.username,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: const Color.fromARGB(255, 186, 183, 183)),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/userprofile');
        },
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: Image.network(
                imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
