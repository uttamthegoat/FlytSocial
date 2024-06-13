import 'package:flutter/material.dart';

class UserConnections extends StatefulWidget {
  final List<String> followers;
  final List<String> following;

  const UserConnections({
    Key? key,
    required this.followers,
    required this.following,
  }) : super(key: key);

  @override
  _UserConnectionsState createState() => _UserConnectionsState();
}

class _UserConnectionsState extends State<UserConnections> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        title: Text('Connections'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Followers'),
            Tab(text: 'Following'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          UserList(users: widget.followers, type: 'Followers'),
          UserList(users: widget.following, type: 'Following'),
        ],
      ),
    );
  }
}

class UserList extends StatelessWidget {
  final List<String> users;
  final String type;

  const UserList({
    Key? key,
    required this.users,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(users[index]), // Placeholder for user image
          ),
          title: Text(users[index]), // Placeholder for username
          trailing: type == 'Following' ? OutlinedButton(
            onPressed: () {
              // Handle unfollow action
            },
            child: Text('Unfollow'),
          ) : null,
        );
      },
    );
  }
}
