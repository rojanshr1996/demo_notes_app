import 'dart:developer' as devtools show log;
import 'dart:math';

import 'package:custom_widgets/custom_widgets.dart';
import 'package:demo_app_bloc/bloc/authBloc/auth_bloc.dart';
import 'package:demo_app_bloc/bloc/authBloc/auth_event.dart';
import 'package:demo_app_bloc/bloc/authBloc/auth_state.dart';
import 'package:demo_app_bloc/helpers/loading/loading_screen.dart';
import 'package:demo_app_bloc/utils/app_colors.dart';
import 'package:demo_app_bloc/view/auth/login_screen.dart';
import 'package:demo_app_bloc/view/route/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IndexScreen extends StatelessWidget {
  const IndexScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    devtools.log("${FirebaseAuth.instance.currentUser}");
    return Scaffold(
      appBar: AppBar(title: const Text("Index"), actions: [
        IconButton(
          onPressed: () {
            BlocProvider.of<AuthBloc>(context).add(const AuthEventLogout());
          },
          icon: const Icon(Icons.restart_alt),
        ),
        IconButton(
          onPressed: () {
            BlocProvider.of<AuthBloc>(context).add(const AuthEventLogout());
          },
          icon: const Icon(Icons.logout),
        ),
      ]),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.isLoading) {
            LoadingScreen().show(context: context, text: state.loadingText ?? "Please wait a moment");
          } else {
            LoadingScreen().hide();
          }
          if (state is AuthStateEmailVerified) {
            // Navigating to the post screen if the user is authenticated
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Email verified successfully")));
          }

          if (state is AuthStateLoggedOut) {
            Utilities.removeStackActivity(context, const LoginScreen());
          }
        },
        builder: (context, state) {
          if (state is AuthStateEmailVerified) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text("Current Logged in user: ${FirebaseAuth.instance.currentUser?.email} "),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: CustomButton(
                    title: "Open Posts",
                    borderRadius: BorderRadius.circular(5),
                    splashBorderRadius: BorderRadius.circular(5),
                    buttonColor: AppColors.cBlue,
                    shadowColor: AppColors.cBlueShadow,
                    onPressed: () => Utilities.openNamedActivity(context, Routes.post),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: CustomButton(
                    title: "Open Notes Screen",
                    borderRadius: BorderRadius.circular(5),
                    splashBorderRadius: BorderRadius.circular(5),
                    buttonColor: AppColors.cBlue,
                    shadowColor: AppColors.cBlueShadow,
                    onPressed: () => Utilities.openNamedActivity(context, Routes.notes),
                  ),
                ),
              ],
            );
          }

          return SizedBox(
            width: Utilities.screenWidth(context),
            height: Utilities.screenHeight(context),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: FirebaseAuth.instance.currentUser?.emailVerified ?? false
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text("Current Logged in user: ${FirebaseAuth.instance.currentUser?.email} "),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: CustomButton(
                            title: "Open Posts Screen",
                            borderRadius: BorderRadius.circular(5),
                            splashBorderRadius: BorderRadius.circular(5),
                            buttonColor: AppColors.cBlue,
                            shadowColor: AppColors.cBlueShadow,
                            onPressed: () => Utilities.openNamedActivity(context, Routes.post),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: CustomButton(
                            title: "Open Notes Screen",
                            borderRadius: BorderRadius.circular(5),
                            splashBorderRadius: BorderRadius.circular(5),
                            buttonColor: AppColors.cBlue,
                            shadowColor: AppColors.cBlueShadow,
                            onPressed: () => Utilities.openNamedActivity(context, Routes.notes),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text("${FirebaseAuth.instance.currentUser?.email} is not verified"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: CustomButton(
                            title: "Verify Email",
                            borderRadius: BorderRadius.circular(5),
                            splashBorderRadius: BorderRadius.circular(5),
                            buttonColor: AppColors.cBlue,
                            shadowColor: AppColors.cBlueShadow,
                            onPressed: () => _sendEmailVerification(context),
                          ),
                        ),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }

  void _sendEmailVerification(context) {
    BlocProvider.of<AuthBloc>(context).add(const AuthEventSendEmailVerification());
  }
}
