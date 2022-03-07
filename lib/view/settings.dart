import 'package:custom_widgets/custom_widgets.dart';
import 'package:demo_app_bloc/bloc/authBloc/auth_bloc.dart';
import 'package:demo_app_bloc/bloc/authBloc/auth_event.dart';
import 'package:demo_app_bloc/bloc/authBloc/auth_state.dart';
import 'package:demo_app_bloc/view/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _light = false;

  bool onToggleDarkMode() {
    setState(() {
      _light = !_light;
    });
    return _light;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
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
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary, borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        leading: Icon(
                          Icons.dark_mode,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onTap: onToggleDarkMode,
                        title: Text(
                          "Dark Mode",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        trailing: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _light ? "ON" : "OFF",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary, borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        leading: Icon(
                          Icons.logout,
                          color: Theme.of(context).colorScheme.primary,
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
