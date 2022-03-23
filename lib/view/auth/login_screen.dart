import 'package:custom_widgets/custom_widgets.dart';
import 'package:demo_app_bloc/bloc/authBloc/auth_bloc.dart';
import 'package:demo_app_bloc/bloc/authBloc/auth_event.dart';
import 'package:demo_app_bloc/bloc/authBloc/auth_state.dart';
import 'package:demo_app_bloc/helpers/loading/loading_screen.dart';
import 'package:demo_app_bloc/services/auth_exceptions.dart';
import 'package:demo_app_bloc/utils/app_colors.dart';
import 'package:demo_app_bloc/utils/constants.dart';
import 'package:demo_app_bloc/utils/custom_text_style.dart';
import 'package:demo_app_bloc/utils/dialogs/error_dialog.dart';
import 'package:demo_app_bloc/utils/utils.dart';
import 'package:demo_app_bloc/view/route/routes.dart';
import 'package:demo_app_bloc/widgets/custom_text_enter_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  final String message;
  const LoginScreen({Key? key, this.message = ""}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late ValueNotifier<bool> _obscureText;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void toggle() {
    _obscureText.value = !_obscureText.value;
  }

  @override
  void initState() {
    _obscureText = ValueNotifier<bool>(true);
    if (widget.message != "") {
      SchedulerBinding.instance
          ?.addPostFrameCallback((_) => Utils.displaySnackbar(context: context, message: widget.message));
    }
    _passwordController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _obscureText.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return RemoveFocus(
      child: WillPopScope(
        onWillPop: () async {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          return true;
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) async {
              if (state.isLoading) {
                LoadingScreen().show(context: context, text: state.loadingText ?? "Please wait a moment");
              } else {
                LoadingScreen().hide();
              }

              if (state is AuthStateLoggedIn) {
                // Navigating to the post screen if the user is authenticated
                Utilities.removeNamedStackActivity(context, Routes.index);
              } else if (state is AuthStateNeedsVerification) {
                Utilities.replaceNamedActivity(context, Routes.verifyEmail);
              }
              if (state is AuthStateLoggedOut) {
                if (state.exception is UserNotFoundException) {
                  await showErrorDialog(context, "Cannot find user with the entered credentials.");
                } else if (state.exception is WrongPasswordAuthException) {
                  await showErrorDialog(context, "Wrong credentials");
                } else if (state.exception is GenericAuthException) {
                  await showErrorDialog(context, "Authentication Error");
                }
              }
            },
            builder: (context, state) {
              if (state is AuthStateLoggedOut) {
                // Showing the sign in form if the user is not authenticated
                return Center(
                  child: SizedBox(
                    height: Utilities.screenHeight(context),
                    width: Utilities.screenWidth(context),
                    child: Container(
                      alignment: Alignment.center,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 40, 10, 70),
                              child: Text("LOGIN", style: Theme.of(context).textTheme.titleLarge),
                            ),
                            Form(
                              key: _formKey,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
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
                                            label: Text("Email Address", style: Theme.of(context).textTheme.bodyText2),
                                            textInputType: TextInputType.emailAddress,
                                            style: Theme.of(context).textTheme.bodyMedium,
                                            hintStyle: CustomTextStyle.hintTextLight,
                                            validator: (value) => validateEmail(context: context, value: value!),
                                            focusedBorder: const OutlineInputBorder(
                                                borderSide: BorderSide(color: AppColors.cBlueShade)),
                                            enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                                            disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(0)),
                                            focusedErrorBorder: const OutlineInputBorder(
                                                borderSide: BorderSide(color: AppColors.cRedAccent)),
                                            errorBorder: const OutlineInputBorder(
                                                borderSide: BorderSide(color: AppColors.cRedAccent)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 15),
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
                                          ValueListenableBuilder(
                                            valueListenable: _obscureText,
                                            builder: (context, value, child) => CustomTextEnterField(
                                              textEditingController: _passwordController,
                                              label: Text("Password", style: Theme.of(context).textTheme.bodyText2),
                                              style: Theme.of(context).textTheme.bodyMedium,
                                              textInputType: TextInputType.visiblePassword,
                                              obscureText: _obscureText.value,
                                              hintStyle: CustomTextStyle.hintTextLight,
                                              validator: (value) => validatePassword(context: context, value: value!),
                                              suffixIcon: _passwordController.text.isEmpty
                                                  ? const SizedBox()
                                                  : IconButton(
                                                      onPressed: toggle,
                                                      icon: _obscureText.value
                                                          ? const Icon(Icons.visibility, color: AppColors.cDarkBlue)
                                                          : const Icon(Icons.visibility_off,
                                                              color: AppColors.cDarkBlue),
                                                    ),
                                              focusedBorder: const OutlineInputBorder(
                                                  borderSide: BorderSide(color: AppColors.cBlueShade)),
                                              enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                                              disabledBorder:
                                                  OutlineInputBorder(borderRadius: BorderRadius.circular(0)),
                                              focusedErrorBorder: const OutlineInputBorder(
                                                  borderSide: BorderSide(color: AppColors.cRed)),
                                              errorBorder: const OutlineInputBorder(
                                                  borderSide: BorderSide(color: AppColors.cRed)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 35),
                            Padding(
                              padding: const EdgeInsets.only(left: 30, right: 30),
                              child: CustomButton(
                                title: "SIGN IN",
                                borderRadius: BorderRadius.circular(5),
                                splashBorderRadius: BorderRadius.circular(5),
                                buttonColor: Theme.of(context).buttonTheme.colorScheme?.primary,
                                onPressed: () => _authenticateWithEmailAndPassword(context),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 24, right: 24, top: 10),
                              child: Align(
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        // context.read<AuthBloc>().add(const AuthEventForgotPassword());
                                        Utilities.openNamedActivity(context, Routes.forgotPassword);
                                      },
                                      child: Text(
                                        "Forgot Password?",
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: Theme.of(context).colorScheme.background, fontWeight: semibold),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () => Utilities.openNamedActivity(context, Routes.register),
                                      child: Text(
                                        "Sign up",
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: Theme.of(context).colorScheme.background, fontWeight: semibold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 35),
                            Padding(
                              padding: const EdgeInsets.only(left: 30, right: 30),
                              child: CustomButton(
                                title: "SIGN IN WITH GOOGLE",
                                borderRadius: BorderRadius.circular(5),
                                splashBorderRadius: BorderRadius.circular(5),
                                buttonColor: AppColors.cRed,
                                prefixIcon: const FaIcon(FontAwesomeIcons.google, color: AppColors.cWhite),
                                onPressed: () => _authenticateWithGoogle(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  void _authenticateWithGoogle(context) {
    FocusScope.of(context).unfocus();
    // If email is valid adding new Event [SignInRequested].
    BlocProvider.of<AuthBloc>(context).add(
      const AuthEventGoogleSignIn(),
    );
  }

  void _authenticateWithEmailAndPassword(context) {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      // If email is valid adding new Event [SignInRequested].
      BlocProvider.of<AuthBloc>(context).add(
        AuthEventLogin(_emailController.text, _passwordController.text),
      );
    }
  }
}
