import 'package:demo_app_bloc/model/model.dart';
import 'package:demo_app_bloc/services/crud/notes_service.dart';
import 'package:demo_app_bloc/view/another_page.dart';
import 'package:demo_app_bloc/view/auth/login_screen.dart';
import 'package:demo_app_bloc/view/auth/signup_screen.dart';
import 'package:demo_app_bloc/view/index_screen.dart';
import 'package:demo_app_bloc/view/notes/create_update_notes_screen.dart';
import 'package:demo_app_bloc/view/notes/notes_screen.dart';
import 'package:demo_app_bloc/view/posts/post_detail_screen.dart';
import 'package:demo_app_bloc/view/posts/posts_bloc_screen.dart';

import 'package:demo_app_bloc/view/route/routes.dart';
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

      case Routes.createUpdateNote:
        if (args is DatabaseNote) {
          return MaterialPageRoute(builder: (_) => CreateUpdateNotesScreen(note: args));
        } else {
          return MaterialPageRoute(builder: (_) => const CreateUpdateNotesScreen());
        }

      case Routes.postDetail:
        if (args is Posts) {
          return MaterialPageRoute(builder: (_) => PostDetailScreen(post: args));
        }
        return errorRoute(settings);

      case Routes.anotherPage:
        if (args is ScreenArguments) {
          return MaterialPageRoute(builder: (_) => AnotherPage(data: args.id, title: args.title));
        }
        return errorRoute(settings);

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
