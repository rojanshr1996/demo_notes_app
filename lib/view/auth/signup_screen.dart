import 'package:custom_widgets/custom_widgets.dart';
import 'package:demo_app_bloc/bloc/authBloc/auth_bloc.dart';
import 'package:demo_app_bloc/bloc/authBloc/auth_event.dart';
import 'package:demo_app_bloc/bloc/authBloc/auth_state.dart';
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
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) async {
            if (state is Authenticated) {
              // _sendEmailVerification(context);
              Utilities.replaceNamedActivity(context, Routes.index);
            }
            if (state is AuthError) {
              // Displaying the error message if the user is not authenticated
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
              await showErrorDialog(context, state.error);
            }
          },
          builder: (context, state) {
            if (state is Loading) {
              // Displaying the loading indicator while the user is signing up
              return const Center(child: CircularProgressIndicator());
            }
            if (state is UnAuthenticated) {
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
                          child: Text("CREATE NEW ACCOUNT", style: CustomTextStyle.title),
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
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: AppColors.cWhite,
                                        boxShadow: [
                                          BoxShadow(
                                              color: AppColors.cBlackShadow, blurRadius: 8, offset: const Offset(0, 3)),
                                        ],
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                    ),
                                    CustomTextField(
                                      textEditingController: _emailController,
                                      label: const Text("Email Address"),
                                      textInputType: TextInputType.emailAddress,
                                      hintStyle: CustomTextStyle.hintText,
                                      validator: (value) => validateEmail(context: context, value: value!),
                                      focusedBorder:
                                          const OutlineInputBorder(borderSide: BorderSide(color: AppColors.cDarkBlue)),
                                      enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                                      disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(0)),
                                      focusedErrorBorder:
                                          const OutlineInputBorder(borderSide: BorderSide(color: AppColors.cRed)),
                                      errorBorder:
                                          const OutlineInputBorder(borderSide: BorderSide(color: AppColors.cRed)),
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
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: AppColors.cWhite,
                                        boxShadow: [
                                          BoxShadow(
                                              color: AppColors.cBlackShadow, blurRadius: 8, offset: const Offset(0, 3)),
                                        ],
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                    ),
                                    ValueListenableBuilder(
                                      valueListenable: _obscureText,
                                      builder: (context, value, child) => CustomTextField(
                                        textEditingController: _passwordController,
                                        label: const Text("Password"),
                                        textInputType: TextInputType.visiblePassword,
                                        obscureText: _obscureText.value,
                                        hintStyle: CustomTextStyle.hintText,
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
                                            borderSide: BorderSide(color: AppColors.cDarkBlue)),
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
                            buttonColor: AppColors.cBlue,
                            shadowColor: AppColors.cBlueShadow,
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
                              },
                              child: Text("Go Back", style: CustomTextStyle.bodyText.copyWith(color: AppColors.cBlue)),
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
        SignUpRequested(_emailController.text, _passwordController.text),
      );
    }
  }

  void _sendEmailVerification(context) {
    BlocProvider.of<AuthBloc>(context).add(EmailVerificationRequested());
  }
}
