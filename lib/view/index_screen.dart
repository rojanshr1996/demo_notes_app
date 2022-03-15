import 'dart:developer' as devtools show log;
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_widgets/custom_widgets.dart';
import 'package:demo_app_bloc/bloc/authBloc/auth_bloc.dart';
import 'package:demo_app_bloc/bloc/authBloc/auth_state.dart';
import 'package:demo_app_bloc/helpers/loading/loading_screen.dart';
import 'package:demo_app_bloc/provider/dark_theme_provider.dart';
import 'package:demo_app_bloc/services/auth_services.dart';
import 'package:demo_app_bloc/services/cloud/cloud_note.dart';
import 'package:demo_app_bloc/services/cloud/firebase_cloud_storage.dart';
import 'package:demo_app_bloc/utils/app_colors.dart';
import 'package:demo_app_bloc/utils/custom_text_style.dart';
import 'package:demo_app_bloc/view/auth/login_screen.dart';
import 'package:demo_app_bloc/view/route/routes.dart';
import 'package:demo_app_bloc/widgets/simple_circular_loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class IndexScreen extends StatefulWidget {
  const IndexScreen({Key? key}) : super(key: key);

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  late final FirebaseCloudStorage _notesService;
  final AuthServices _auth = AuthServices();
  String? get userId => _auth.currentUser == null ? "" : _auth.currentUser!.id;

  @override
  void initState() {
    debugPrint(userId);
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    devtools.log("${FirebaseAuth.instance.currentUser}");
    final AuthServices _auth = AuthServices();
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text((_auth.currentUser?.isEmailVerified ?? false) ? "Welcome" : ""),
        actions: [
          IconButton(
            onPressed: () {
              Utilities.openNamedActivity(context, Routes.settings);
            },
            icon: const Icon(
              Icons.settings,
            ),
          ),
        ],
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.isLoading) {
            LoadingScreen().show(context: context, text: state.loadingText ?? "Please wait a moment");
          } else {
            LoadingScreen().hide();
          }

          if (state is AuthStateLoggedOut) {
            Utilities.removeStackActivity(context, const LoginScreen());
          }
        },
        builder: (context, state) {
          debugPrint("$state");

          return Consumer<DarkThemeProvider>(
            builder: (context, value, child) {
              return SizedBox(
                width: Utilities.screenWidth(context),
                height: Utilities.screenHeight(context),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      StreamBuilder(
                        stream: _notesService.userData(ownerUserId: userId!),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                            case ConnectionState.active:
                              if (snapshot.hasData) {
                                final userData = snapshot.data as Iterable<UserModel>;
                                log("User: " + userData.toString());
                                return Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Utilities.openNamedActivity(context, Routes.profile, arguments: userData.first);
                                      },
                                      child: userData.first.profileImage == ""
                                          ? Container(
                                              height: 70,
                                              width: 70,
                                              decoration: const BoxDecoration(
                                                  color: AppColors.cDarkBlue, shape: BoxShape.circle),
                                              child: const Icon(Icons.person_outline_outlined,
                                                  color: AppColors.cLight, size: 38),
                                            )
                                          : Container(
                                              height: 70,
                                              width: 70,
                                              decoration: const BoxDecoration(
                                                  color: AppColors.cDarkBlueAccent, shape: BoxShape.circle),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(100),
                                                child: CachedNetworkImage(
                                                  imageUrl: userData.first.profileImage!,
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
                                                      const Center(child: SimpleCircularLoader()),
                                                  errorWidget: (context, url, error) => const Icon(
                                                    Icons.image,
                                                    color: AppColors.cLight,
                                                    size: 48,
                                                  ),
                                                ),
                                              ),
                                            ),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      " ${userData.first.name}",
                                      style: Theme.of(context).textTheme.displayMedium,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                );
                              } else {
                                return const SizedBox();
                              }

                            default:
                              return const Center(
                                child: SimpleCircularLoader(),
                              );
                          }
                        },
                      ),
                      const SizedBox(height: 35),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: IndexButtons(
                            title: "VIEW NOTES",
                            prefixIcon: const Icon(Icons.note_rounded, size: 55, color: AppColors.cLightShade),
                            textStyle: CustomTextStyle.headerText.copyWith(color: AppColors.cLightShade),
                            borderRadius: BorderRadius.circular(15),
                            splashBorderRadius: BorderRadius.circular(15),
                            imagePath: value.darkTheme ? "assets/notesImage.png" : "assets/notesImageLight.png",
                            buttonColor: Theme.of(context).buttonTheme.colorScheme?.primary,
                            onPressed: () => Utilities.openNamedActivity(context, Routes.notes),
                          ),
                        ),
                      ),
                      const SizedBox(height: 35),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: IndexButtons(
                            title: "VIEW POSTS",
                            prefixIcon: const Icon(Icons.file_copy_rounded, size: 55, color: AppColors.cLightShade),
                            textStyle: CustomTextStyle.headerText.copyWith(color: AppColors.cLightShade),
                            borderRadius: BorderRadius.circular(15),
                            splashBorderRadius: BorderRadius.circular(15),
                            imagePath: value.darkTheme ? "assets/postImage.png" : "assets/postImageLight.png",
                            buttonColor: AppColors.cDarkBlue,
                            shadowColor: AppColors.cDarkBlue,
                            onPressed: () => Utilities.openNamedActivity(context, Routes.post),
                          ),
                        ),
                      ),
                      const SizedBox(height: 45),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class IndexButtons extends StatelessWidget {
  final String title;
  final Color? buttonColor;
  final TextStyle? textStyle;

  final VoidCallback? onPressed;
  final BorderRadiusGeometry? borderRadius;
  final BorderRadius? splashBorderRadius;
  final Widget? prefixIcon;
  final double? buttonWidth;
  final Color? shadowColor;
  final double elevation;
  final String imagePath;

  const IndexButtons({
    Key? key,
    required this.title,
    this.buttonColor,
    this.onPressed,
    this.textStyle = const TextStyle(color: AppColors.cDarkBlueLight),
    this.borderRadius,
    this.prefixIcon,
    this.splashBorderRadius,
    this.buttonWidth,
    this.elevation = 4.0,
    this.shadowColor,
    this.imagePath = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      color: buttonColor ?? ButtonTheme.of(context).colorScheme!.primary,
      borderRadius: borderRadius,
      shadowColor: shadowColor,
      child: InkWell(
        borderRadius: splashBorderRadius,
        highlightColor: Colors.transparent,
        onTap: onPressed,
        child: ClipRRect(
          borderRadius: splashBorderRadius,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
            ),
            width: buttonWidth ?? Utilities.screenWidth(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                prefixIcon == null
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.only(right: 12, left: 12),
                        child: prefixIcon,
                      ),
                const SizedBox(height: 8),
                CustomTextBorder(
                  text: title,
                  textStyle: textStyle,
                  textBorderColor: AppColors.cDarkBlue.withOpacity(0.7),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
