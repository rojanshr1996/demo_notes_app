import 'package:custom_widgets/custom_widgets.dart';
import 'package:demo_app_bloc/bloc/authBloc/auth_bloc.dart';
import 'package:demo_app_bloc/bloc/authBloc/auth_event.dart';
import 'package:demo_app_bloc/bloc/authBloc/auth_state.dart';
import 'package:demo_app_bloc/provider/dark_theme_provider.dart';
import 'package:demo_app_bloc/view/auth/login_screen.dart';
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Container(
                      decoration:
                          BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(15)),
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
                            )

                            //  Text(
                            //   themeChange.darkTheme ? "ON" : "OFF",
                            //   style: Theme.of(context).textTheme.bodyLarge,
                            // ),
                            ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration:
                          BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        leading: Icon(
                          Icons.logout,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        onTap: () {
                          BlocProvider.of<AuthBloc>(context).add(const AuthEventLogout());
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
          );
        },
      ),
    );
  }
}
