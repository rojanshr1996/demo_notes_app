import 'package:demo_app_bloc/bloc/authBloc/auth_bloc.dart';
import 'package:demo_app_bloc/bloc/postBloc/post_bloc.dart';
import 'package:demo_app_bloc/bloc/postBloc/post_event.dart';
import 'package:demo_app_bloc/cubit/post_cubit.dart';
import 'package:demo_app_bloc/services/auth_services.dart';
import 'package:demo_app_bloc/services/post_service.dart';
import 'package:demo_app_bloc/view/auth/login_screen.dart';
import 'package:demo_app_bloc/view/route/app_router.dart';
import 'package:demo_app_bloc/view/route/routes.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(DevicePreview(
    builder: (context) => const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthServices _auth = AuthServices();

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthServices()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<PostsBloc>(create: (_) => PostsBloc(PostService())..add(LoadPostEvent())),
          BlocProvider<PostCubit>(create: (_) => PostCubit()),
          BlocProvider(create: (context) => AuthBloc(authServices: RepositoryProvider.of<AuthServices>(context)))
        ],
        child: ScreenUtilInit(
          designSize: const Size(411.42857142857144, 820.5714285714286),
          builder: () => MaterialApp(
            useInheritedMediaQuery: true,
            debugShowCheckedModeBanner: false,
            builder: DevicePreview.appBuilder,
            title: 'Bloc Demo',
            onGenerateRoute: AppRouter.onGenerateRoute,
            theme: ThemeData(primarySwatch: Colors.blue),
            // initialRoute: Routes.post,
            home: const LoginScreen(),
            // initialRoute: _auth.currentUser != null ? Routes.index : Routes.login,
          ),
        ),
      ),
    );
  }
}
