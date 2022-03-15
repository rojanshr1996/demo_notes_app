import 'package:demo_app_bloc/model/model.dart';
import 'package:demo_app_bloc/services/cloud/cloud_note.dart';
import 'package:demo_app_bloc/view/auth/forgot_password_view.dart';
import 'package:demo_app_bloc/view/auth/login_screen.dart';
import 'package:demo_app_bloc/view/auth/signup_screen.dart';
import 'package:demo_app_bloc/view/auth/email_verify_screen.dart';
import 'package:demo_app_bloc/view/index_screen.dart';
import 'package:demo_app_bloc/view/notes/create_update_notes_screen.dart';
import 'package:demo_app_bloc/view/notes/notes_screen.dart';
import 'package:demo_app_bloc/view/posts/post_detail_screen.dart';
import 'package:demo_app_bloc/view/posts/posts_bloc_screen.dart';
import 'package:demo_app_bloc/view/profile/profile_screen.dart';

import 'package:demo_app_bloc/view/route/routes.dart';
import 'package:demo_app_bloc/view/settings.dart';
import 'package:demo_app_bloc/widgets/enlarge_image.dart';
import 'package:flutter/material.dart';

class AppRouter {
  AppRouter._();
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Routes.login:
        return MaterialPageRoute(builder: (_) => LoginScreen(message: (args is String ? args : "")));

      case Routes.index:
        return MaterialPageRoute(builder: (_) => const IndexScreen());

      case Routes.register:
        return MaterialPageRoute(builder: (_) => const SingupScreen());

      case Routes.post:
        return MaterialPageRoute(builder: (_) => const PostsBlocScreen(title: "Flutter Bloc"));

      case Routes.notes:
        return MaterialPageRoute(builder: (_) => const NotesScreen());

      case Routes.verifyEmail:
        return MaterialPageRoute(builder: (_) => const EmailVerifyScreen());

      case Routes.settings:
        return MaterialPageRoute(builder: (_) => const Settings());

      case Routes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordView());

      case Routes.createUpdateNote:
        if (args is CloudNote) {
          return MaterialPageRoute(builder: (_) => CreateUpdateNotesScreen(note: args));
        } else {
          return MaterialPageRoute(builder: (_) => const CreateUpdateNotesScreen());
        }

      case Routes.postDetail:
        if (args is Posts) {
          return MaterialPageRoute(builder: (_) => PostDetailScreen(post: args));
        }
        return errorRoute(settings);

      case Routes.notesImage:
        if (args is ImageArgs) {
          return MaterialPageRoute(builder: (_) => EnlargeImage(imageArgs: args));
        }
        return errorRoute(settings);

      case Routes.profile:
        if (args is UserModel) {
          return MaterialPageRoute(builder: (_) => ProfileScreen(profileData: args));
        } else {
          return MaterialPageRoute(builder: (_) => const ProfileScreen());
        }

      default:
        return errorRoute(settings);
    }
  }

  static Route<dynamic> errorRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text('No Route defined for ${settings.name}'),
        ),
      ),
    );
  }
}
