import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flytsocial/screens/users_profile.dart';
import 'package:flytsocial/state/user_provider.dart';
import 'package:provider/provider.dart';

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
  late List<Map<String, dynamic>> postResults = [];
  late List<Map<String, dynamic>> userResults = [];

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

  void _searchSubmit(BuildContext context, String query) {
    print('Search query: $query');

    if (query.startsWith("#")) {
      _tabController?.animateTo(1);
      String tagQuery = query.substring(1);
      searchPosts(tagQuery);
    } else {
      _tabController?.animateTo(0);
      searchUsers(context, query);
    }
  }

  void searchPosts(String tagQuery) {
    FirebaseFirestore.instance
        .collection('posts')
        .where('tags', arrayContains: tagQuery)
        .get()
        .then((querySnapshot) {
      var posts = querySnapshot.docs.map((doc) => doc.data()).toList();
      setState(() {
        postResults = posts;
        userResults = [];
      });
    }).catchError((e) {
      print('Error fetching posts by tag: $e');
    });
  }

  void searchUsers(BuildContext context, String query) async {
    try {
      // Create a reference to the Firestore users collection
      final usersCollection = FirebaseFirestore.instance.collection('users');

      // Perform queries for both username and name, case-insensitive substring match
      final usernameQuery = await usersCollection
          .where('username', isGreaterThanOrEqualTo: query)
          .where('username', isLessThanOrEqualTo: '$query\uf8ff')
          .get();
      final nameQuery = await usersCollection
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      // Combine the results from both queries
      List<Map<String, dynamic>> results = [];
      // doesnt display the logged in users account
      final String curUserEmail =
          Provider.of<UserProvider>(context, listen: false)
              .currentUser['email'];
      Set<String> seenEmails = {};

      // Process username query results
      for (var doc in usernameQuery.docs) {
        final String userId = doc.id;
        var userData = doc.data();
        userData['userId'] = userId;
        String? userEmail = userData['email'];
        if (userEmail != null && !seenEmails.contains(userEmail)) {
          results.add(userData);
          seenEmails.add(userEmail);
        }
      }

      // Process name query results
      for (var doc in nameQuery.docs) {
        final String userId = doc.id;
        var userData = doc.data();
        userData['userId'] = userId;
        String? userEmail = userData['email'];
        if (userEmail != null && !seenEmails.contains(userEmail)) {
          results.add(userData);
          seenEmails.add(userEmail);
        }
      }

      setState(() {
        userResults = results;
        postResults = [];
      });
    } catch (e) {
      print('Error searching users: $e');
    }
  }

  void _clearSearch() {
    _searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
                'Search',
                // style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
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
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    hintStyle:
                        const TextStyle(color: Colors.white, fontSize: 18),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear, color: Colors.white),
                      onPressed: _clearSearch,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 18.0),
                  cursorColor: Colors.white,
                  onSubmitted: (String value) => _searchSubmit(context, value),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height -
                    kToolbarHeight -
                    120, // Adjust this as per your layout
                child: _searchController.text != ""
                    ? TabBarView(
                        controller: _tabController,
                        children: [
                          userResults.isEmpty
                              ? _notFound('No users found!')
                              : _usersGrid(userResults),
                          postResults.isEmpty
                              ? _notFound('No posts found!')
                              : _tagsGrid(postResults),
                        ],
                      )
                    : Container(
                        child: const Center(
                          child: Text(
                            'Search...',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ));
  }

  Widget _usersGrid(final List<Map<String, dynamic>> users) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 5 / 1,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user =
              users[index].map((key, value) => MapEntry(key, value.toString()));
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

  Widget _notFound(String notFoundText) {
    return Center(
      child: Text(
        notFoundText,
        style: const TextStyle(
            fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
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
              builder: (context) {
                final curUser =
                    Provider.of<UserProvider>(context, listen: false)
                        .currentUser;
                return UserProfile(user: user, curUser: curUser['userId']);
              },
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
