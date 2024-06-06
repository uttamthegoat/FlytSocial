import 'package:flytsocial/screens/edit_profile.dart';
import 'package:flytsocial/screens/post_item.dart';
import 'package:flytsocial/screens/users_profile.dart';

dynamic allRoutes = {
  '/editprofile': (context) => const EditProfile(),
  '/postitem': (context) => const PostItem(),
  '/userprofile': (context) => const UserProfile(user: {},),
};
