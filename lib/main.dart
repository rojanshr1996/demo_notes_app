import 'dart:developer';

import 'package:demo_app_bloc/bloc/authBloc/auth_bloc.dart';
import 'package:demo_app_bloc/bloc/postBloc/post_bloc.dart';
import 'package:demo_app_bloc/bloc/postBloc/post_event.dart';
import 'package:demo_app_bloc/cubit/post_cubit.dart';
import 'package:demo_app_bloc/provider/dark_theme_provider.dart';
import 'package:demo_app_bloc/services/auth_services.dart';
import 'package:demo_app_bloc/services/fcm_services.dart';
import 'package:demo_app_bloc/services/post_service.dart';
import 'package:demo_app_bloc/utils/app_colors.dart';
import 'package:demo_app_bloc/view/route/app_router.dart';
import 'package:demo_app_bloc/view/route/routes.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme = await themeChangeProvider.darkThemePreference.getTheme();
    log("Dark Theme activated: ${themeChangeProvider.darkTheme}");
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthServices()),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => themeChangeProvider),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<PostsBloc>(create: (_) => PostsBloc(PostService())..add(LoadPostEvent())),
            BlocProvider<PostCubit>(create: (_) => PostCubit()),
            BlocProvider(create: (context) => AuthBloc(authServices: RepositoryProvider.of<AuthServices>(context)))
          ],
          child: ScreenUtilInit(
            designSize: const Size(411.428, 820.5),
            builder: () => Consumer<DarkThemeProvider>(
              builder: (context, value, child) {
                return MaterialApp(
                  useInheritedMediaQuery: true,
                  debugShowCheckedModeBanner: false,
                  // builder: DevicePreview.appBuilder,
                  title: 'Notes App',
                  onGenerateRoute: AppRouter.onGenerateRoute,
                  themeMode: ThemeMode.light,
                  theme: value.darkTheme ? ThemeClass.darkTheme : ThemeClass.lightTheme,

                  // theme: value.darkTheme ? ThemeClass.darkTheme : ThemeClass.lightTheme,
                  darkTheme: value.darkTheme ? ThemeClass.darkTheme : ThemeClass.darkTheme,
                  initialRoute: Routes.login,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
