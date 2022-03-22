import 'dart:developer';

import 'package:custom_widgets/custom_widgets.dart';
import 'package:demo_app_bloc/bloc/authBloc/auth_bloc.dart';
import 'package:demo_app_bloc/bloc/authBloc/auth_event.dart';
import 'package:demo_app_bloc/bloc/authBloc/auth_state.dart';
import 'package:demo_app_bloc/provider/dark_theme_provider.dart';
import 'package:demo_app_bloc/utils/app_colors.dart';
import 'package:demo_app_bloc/utils/dialogs/logout_dialog.dart';
import 'package:demo_app_bloc/view/auth/login_screen.dart';
import 'package:demo_app_bloc/widgets/logo_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _light = false;

  onToggleDarkMode(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context, listen: false);

    setState(() {
      _light = !_light;
    });

    themeChange.darkTheme = _light;
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 4,
        shadowColor: Theme.of(context).colorScheme.shadow,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Settings"),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthStateLoggedOut) {
            Utilities.removeStackActivity(context, const LoginScreen());
          }
        },
        builder: (context, state) {
          return SizedBox(
            height: Utilities.screenHeight(context),
            width: Utilities.screenWidth(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(15)),
                            child: ListTile(
                              leading: Icon(
                                themeChange.darkTheme ? Icons.dark_mode : Icons.light_mode,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              onTap: () => onToggleDarkMode(context),
                              title: Text(
                                "Dark Mode",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              trailing: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Switch(
                                    value: themeChange.darkTheme,
                                    onChanged: (value) {
                                      themeChange.darkTheme = value;
                                    },
                                    activeColor: Theme.of(context).colorScheme.background,
                                  )),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(15)),
                            child: ListTile(
                              leading: Icon(
                                Icons.logout,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              onTap: () async {
                                final shouldLogOut = await showLogoutDialog(context);
                                log(shouldLogOut.toString());
                                if (shouldLogOut) {
                                  BlocProvider.of<AuthBloc>(context).add(const AuthEventLogout());
                                }
                              },
                              title: Text(
                                "Logout",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius:
                          const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                  child: ListTile(
                    leading: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: LogoWidget(height: 24),
                    ),
                    title: Text(
                      "NOTESTER",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).hintColor),
                    ),
                    subtitle: Text(
                      "Version 0.1",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
