import 'package:flutter/material.dart';
import 'package:flytsocial/screens/users_profile.dart';

class AppSearch extends StatefulWidget {
  const AppSearch({super.key});
  final int pageIndex = 2;
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<AppSearch>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _searchSubmit(String query) {
    print('Search query: $query');

    setState(() {
      if (query.startsWith("#")) {
        _tabController?.animateTo(1);
      } else {
        _tabController?.animateTo(0);
      }
      searchPosts = _allPosts;
      searchUsers = _users;
    });
  }

  void _clearSearch() {
    _searchController.clear();
  }

  dynamic searchPosts = {};
  dynamic searchUsers = {};

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
    return Scaffold(
        appBar: AppBar(
          title: const Row(
            children: [
              Icon(
                Icons.search,
                size: 30,
              ),
              SizedBox(width: 10),
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
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search here...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    hintStyle:
                        const TextStyle(color: Colors.white, fontSize: 18),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear, color: Colors.white),
                      onPressed: _clearSearch,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 18.0),
                  cursorColor: Colors.white,
                  onSubmitted: _searchSubmit,
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height -
                    kToolbarHeight -
                    120, // Adjust this as per your layout
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _users.isEmpty ? _notFound() : _usersGrid(_users),
                    _allPosts.isEmpty ? _notFound() : _tagsGrid(_allPosts),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _usersGrid(dynamic users) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 5 / 1,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return UserTile(user: user);
        },
      ),
    );
  }

  Widget _tagsGrid(dynamic allPosts) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
          ),
          itemCount: allPosts.length,
          itemBuilder: (context, index) {
            final post = allPosts[index];
            return IndividualPost(post: post);
          },
        ));
  }

  Widget _notFound() {
    return const Center(
      child: Text(
        'Not Found!',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
    );
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
