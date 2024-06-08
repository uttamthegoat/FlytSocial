import 'package:flutter/material.dart';
import 'package:flytsocial/screens/users_profile.dart';

class AppSearch extends StatefulWidget {
  const AppSearch({super.key});
  final int pageIndex = 2;
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<AppSearch> {
  final TextEditingController _searchController = TextEditingController();

  // Sample user data
  final List<Map<String, String>> _users = [
    {
      'id': '1',
      'imageUrl': 'https://via.placeholder.com/150',
      'username': 'username1',
      'name': 'Name 1',
      'email': 'user1@mail.com',
      'bio': 'I am user 1'
    },
    {
      'id': '2',
      'imageUrl': 'https://via.placeholder.com/150',
      'username': 'username2',
      'name': 'Name 2',
      'email': 'user2@mail.com',
      'bio': 'I am user 2'
    },
    {
      'id': '3',
      'imageUrl': 'https://via.placeholder.com/150',
      'username': 'username3',
      'name': 'Name 3',
      'email': 'user3@mail.com',
      'bio': 'I am user 3'
    },
    {
      'id': '4',
      'imageUrl': 'https://via.placeholder.com/150',
      'username': 'username4',
      'name': 'Name 4',
      'email': 'user4@mail.com',
      'bio': 'I am user 4'
    },
    {
      'id': '5',
      'imageUrl': 'https://via.placeholder.com/150',
      'username': 'username5',
      'name': 'Name 5',
      'email': 'user5@mail.com',
      'bio': 'I am user 5'
    },
    {
      'id': '6',
      'imageUrl': 'https://via.placeholder.com/150',
      'username': 'username6',
      'name': 'Name 6',
      'email': 'user6@mail.com',
      'bio': 'I am user 6'
    },
    {
      'id': '7',
      'imageUrl': 'https://via.placeholder.com/150',
      'username': 'username7',
      'name': 'Name 7',
      'email': 'user7@mail.com',
      'bio': 'I am user 7'
    },
    {
      'id': '8',
      'imageUrl': 'https://via.placeholder.com/150',
      'username': 'username8',
      'name': 'Name 8',
      'email': 'user8@mail.com',
      'bio': 'I am user 8'
    },
    {
      'id': '9',
      'imageUrl': 'https://via.placeholder.com/150',
      'username': 'username9',
      'name': 'Name 9',
      'email': 'user9@mail.com',
      'bio': 'I am user 9'
    },
    {
      'id': '10',
      'imageUrl': 'https://via.placeholder.com/150',
      'username': 'username10',
      'name': 'Name 10',
      'email': 'user10@mail.com',
      'bio': 'I am user 10'
    },
    {
      'id': '11',
      'imageUrl': 'https://via.placeholder.com/150',
      'username': 'username11',
      'name': 'Name 11',
      'email': 'user11@mail.com',
      'bio': 'I am user 11'
    },
    {
      'id': '12',
      'imageUrl': 'https://via.placeholder.com/150',
      'username': 'username12',
      'name': 'Name 12',
      'email': 'user12@mail.com',
      'bio': 'I am user 12'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.black,
          title: const Row(
            children: [
              Icon(
                Icons.search,
                size: 30, // Adjust the size as needed
              ),
              SizedBox(
                  width: 10), // Add some space between the icon and the text
              Text(
                'Search',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ],
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                // Use Expanded or Flexible to allow GridView to expand
                child: GridView.builder(
                  // This ensures the GridView can scroll if items exceed the screen size
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 5 / 1,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: _users.length,
                  itemBuilder: (context, index) {
                    final user = _users[index];
                    return UserTile(user: user);
                  },
                ),
              ),
            ],
          ),
        ));
  }
}

class UserTile extends StatelessWidget {
  final Map<String, String> user;
  final defaultName = 'John Doe';
  final defaultusername = 'ligmaBalls';
  final defaultImage =
      'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png';

  UserTile({required this.user});

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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfile(user: user),
            ),
          );
        },
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: Image.network(
                user['imageUrl'] ?? defaultImage,
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
                    user['username'] ?? defaultusername,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    user['name'] ?? defaultName,
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
