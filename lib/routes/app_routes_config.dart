import 'package:flytsocial/screens/edit_post.dart';
import 'package:flytsocial/screens/edit_profile.dart';
import 'package:flytsocial/screens/home.dart';
import 'package:flytsocial/screens/post_item.dart';
import 'package:flytsocial/screens/profile.dart';
import 'package:flytsocial/screens/user_connections.dart';
import 'package:flytsocial/screens/users_profile.dart';

dynamic allRoutes = {
  '/editprofile': (context) => const EditProfile(user: {}),
  '/postitem': (context) => const PostItem(post: {}, curUserId: ""),
  '/userprofile': (context) => const UserProfile(user: {}, curUserId: ""),
  '/editpost': (context) => const EditPost(
        post: {},
      ),
  '/profile': (context) => const Profile(
        user: {},
      ),
  '/home': (context) => const Home(
        currentUser: {},
      ),
  '/connections': (context) => const UserConnections(
        currentUserId: "",
      ),
};
