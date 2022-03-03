import 'package:custom_widgets/custom_widgets.dart';
import 'package:demo_app_bloc/bloc/authBloc/auth_bloc.dart';
import 'package:demo_app_bloc/bloc/authBloc/auth_event.dart';
import 'package:demo_app_bloc/bloc/authBloc/auth_state.dart';
import 'package:demo_app_bloc/helpers/loading/loading_screen.dart';
import 'package:demo_app_bloc/services/auth_exceptions.dart';
import 'package:demo_app_bloc/utils/app_colors.dart';
import 'package:demo_app_bloc/utils/custom_text_style.dart';
import 'package:demo_app_bloc/utils/dialogs/error_dialog.dart';
import 'package:demo_app_bloc/view/route/routes.dart';
import 'package:demo_app_bloc/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SingupScreen extends StatefulWidget {
  const SingupScreen({Key? key}) : super(key: key);

  @override
  _SingupScreenState createState() => _SingupScreenState();
}

class _SingupScreenState extends State<SingupScreen> {
  late ValueNotifier<bool> _obscureText;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void toggle() {
    // Add your super logic here!
    _obscureText.value = !_obscureText.value;
  }

  @override
  void initState() {
    _obscureText = ValueNotifier<bool>(true);
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
    return RemoveFocus(
      child: Scaffold(
        backgroundColor: AppColors.cDarkBlue,
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) async {
            if (state.isLoading) {
              LoadingScreen().show(context: context, text: state.loadingText ?? "Please wait a moment");
            } else {
              LoadingScreen().hide();
            }
            if (state is AuthStateRegistering) {
              if (state.exception is EmailInUseAuthException) {
                await showErrorDialog(context, "Email is already in use");
              } else if (state.exception is WrongPasswordAuthException) {
                await showErrorDialog(context, "Wrong password");
              } else if (state.exception is GenericAuthException) {
                await showErrorDialog(context, "Failed to register");
              }
            }

            if (state is AuthStateLoggedIn) {
              Utilities.replaceNamedActivity(context, Routes.index);
            }

            // if (state is AuthStateLoggedOut) {
            //   if (state.exception is EmailInUseAuthException) {
            //     await showErrorDialog(context, "Email already in use");
            //   } else if (state.exception is WrongPasswordAuthException) {
            //     await showErrorDialog(context, "Wrong credentials");
            //   } else if (state.exception is GenericAuthException) {
            //     await showErrorDialog(context, "Authentication Error");
            //   }
            // }
            // if (state is AuthStateLoginFailure) {
            //   // Displaying the error message if the user is not authenticated
            //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${state.exception}")));
            //   await showErrorDialog(context, "${state.exception}");
            // }
          },
          builder: (context, state) {
            if (state is AuthStateLoggedOut) {
              // Displaying the sign up form if the user is not authenticated

              return SizedBox(
                height: Utilities.screenHeight(context),
                width: Utilities.screenWidth(context),
                child: Container(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(10, 40, 10, 70),
                          child: Text("CREATE NEW ACCOUNT", style: CustomTextStyle.titleLight),
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 24, right: 24),
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: AppColors.cDarkBlueAccent,
                                        boxShadow: [
                                          BoxShadow(
                                              color: AppColors.cDarkBlueAccent.withAlpha(200),
                                              blurRadius: 8,
                                              offset: const Offset(0, 3)),
                                        ],
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                    ),
                                    CustomTextField(
                                      textEditingController: _emailController,
                                      label: const Text("Email Addresss", style: CustomTextStyle.hintTextLight),
                                      textInputType: TextInputType.emailAddress,
                                      hintStyle: CustomTextStyle.hintTextLight,
                                      style: CustomTextStyle.bodyTextLight,
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
                              const SizedBox(height: 12),
                              Padding(
                                padding: const EdgeInsets.only(left: 24, right: 24),
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: AppColors.cDarkBlueAccent,
                                        boxShadow: [
                                          BoxShadow(
                                              color: AppColors.cDarkBlueAccent.withAlpha(200),
                                              blurRadius: 8,
                                              offset: const Offset(0, 3)),
                                        ],
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                    ),
                                    ValueListenableBuilder(
                                      valueListenable: _obscureText,
                                      builder: (context, value, child) => CustomTextField(
                                        textEditingController: _passwordController,
                                        label: const Text("Password", style: CustomTextStyle.hintTextLight),
                                        style: CustomTextStyle.bodyTextLight,
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
                                                    : const Icon(Icons.visibility_off, color: AppColors.cDarkBlue),
                                              ),
                                        focusedBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(color: AppColors.cBlueShade)),
                                        enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                                        disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(0)),
                                        focusedErrorBorder:
                                            const OutlineInputBorder(borderSide: BorderSide(color: AppColors.cRed)),
                                        errorBorder:
                                            const OutlineInputBorder(borderSide: BorderSide(color: AppColors.cRed)),
                                      ),
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
                            title: "SIGN UP",
                            borderRadius: BorderRadius.circular(5),
                            splashBorderRadius: BorderRadius.circular(5),
                            buttonColor: AppColors.cBlueShade,
                            shadowColor: AppColors.cBlueShade,
                            onPressed: () => _createAccountWithEmailAndPassword(context),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 24, right: 24, top: 10),
                          child: Align(
                            alignment: Alignment.center,
                            child: TextButton(
                              onPressed: () {
                                Utilities.closeActivity(context);
                                // context.read<AuthBloc>().add(const AuthEventLogout());
                              },
                              child: Text("Go Back",
                                  style: CustomTextStyle.bodyText.copyWith(color: AppColors.cDarkBlueLight)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  void _createAccountWithEmailAndPassword(context) {
    if (_formKey.currentState!.validate()) {
      // If email is valid adding new event [SignUpRequested].
      BlocProvider.of<AuthBloc>(context).add(
        AuthEventSignUp(_emailController.text, _passwordController.text),
      );
    }
  }

  void _sendEmailVerification(context) {
    BlocProvider.of<AuthBloc>(context).add(AuthEventSendEmailVerification());
  }
}
