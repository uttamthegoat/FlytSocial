import 'package:flytsocial/screens/edit_post.dart';
import 'package:flytsocial/screens/edit_profile.dart';
import 'package:flytsocial/screens/post_item.dart';
import 'package:flytsocial/screens/users_profile.dart';

dynamic allRoutes = {
  '/editprofile': (context) => const EditProfile(),
  '/postitem': (context) => const PostItem(post: {}),
  '/userprofile': (context) => const UserProfile(
        user: {},
      ),
  '/editpost': (context) => const EditPost(
        post: {},
      ),
};
