import 'package:custom_widgets/custom_widgets.dart';
import 'package:demo_app_bloc/bloc/authBloc/auth_bloc.dart';
import 'package:demo_app_bloc/bloc/authBloc/auth_event.dart';
import 'package:demo_app_bloc/bloc/authBloc/auth_state.dart';
import 'package:demo_app_bloc/utils/app_colors.dart';
import 'package:demo_app_bloc/utils/constants.dart';
import 'package:demo_app_bloc/utils/custom_text_style.dart';
import 'package:demo_app_bloc/utils/dialogs/error_dialog.dart';
import 'package:demo_app_bloc/utils/dialogs/password_reset_email_sent_dialog.dart';
import 'package:demo_app_bloc/view/route/routes.dart';
import 'package:demo_app_bloc/widgets/custom_text_enter_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    _emailController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RemoveFocus(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) async {
            // if (state.isLoading) {
            //   LoadingScreen().show(context: context, text: state.loadingText ?? "Please wait a moment");
            // } else {
            //   LoadingScreen().hide();
            // }

            if (state is AuthStateForgotPassword) {
              if (state.hasSentEmail) {
                debugPrint("THIS IS THE STATE: ${state.hasSentEmail}");
                _emailController.clear();
                await showPasswordResetDialog(context);
              }
              if (state.exception != null) {
                await showErrorDialog(context, "Request failed. Please try again.");
              }
            }

            if (state is AuthStateLoggedOut) {
              Utilities.removeNamedStackActivity(context, Routes.login);
            }
          },
          builder: (context, state) {
            return SizedBox(
              height: Utilities.screenHeight(context),
              width: Utilities.screenWidth(context),
              child: Container(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 40, 10, 50),
                        child: Text(
                          "FORGOT PASSWORD?",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(30),
                              child: Text(
                                "If you forgot your password, enter your email and we will send you a password reset link.",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 24, right: 24),
                              child: Stack(
                                children: [
                                  Container(
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Theme.of(context).colorScheme.shadow,
                                            blurRadius: 8,
                                            offset: const Offset(0, 3)),
                                      ],
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                  CustomTextEnterField(
                                    textEditingController: _emailController,
                                    label: Text("Email Addresss", style: Theme.of(context).textTheme.bodyText2),
                                    textInputType: TextInputType.emailAddress,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                    hintStyle: CustomTextStyle.hintTextLight,
                                    validator: (value) => validateEmail(context: context, value: value!),
                                    focusedBorder:
                                        const OutlineInputBorder(borderSide: BorderSide(color: AppColors.cBlueShade)),
                                    enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                                    disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(0)),
                                    focusedErrorBorder:
                                        const OutlineInputBorder(borderSide: BorderSide(color: AppColors.cRedAccent)),
                                    errorBorder:
                                        const OutlineInputBorder(borderSide: BorderSide(color: AppColors.cRedAccent)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 35),
                      Padding(
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: CustomButton(
                          title: "SEND RESET LINK",
                          borderRadius: BorderRadius.circular(5),
                          splashBorderRadius: BorderRadius.circular(5),
                          buttonColor: Theme.of(context).buttonTheme.colorScheme?.primary,
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            context.read<AuthBloc>().add(AuthEventForgotPassword(email: _emailController.text));
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 24, right: 24, top: 10),
                        child: Align(
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: () {
                              // context.read<AuthBloc>().add(AuthEventLogout());
                              // Utilities.removeNamedStackActivity(context, Routes.login);
                              context.read<AuthBloc>().add(const AuthEventLogout());
                            },
                            child: Text(
                              "Go Back",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Theme.of(context).colorScheme.background, fontWeight: semibold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
