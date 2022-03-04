import 'package:custom_widgets/custom_widgets.dart';
import 'package:flutter/material.dart';

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
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          elevation: 0,
          title: const Text("Settings"),
        ),
        body: SizedBox(
          height: Utilities.screenHeight(context),
          width: Utilities.screenWidth(context),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background, borderRadius: BorderRadius.circular(15)),
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
                        color: Theme.of(context).colorScheme.background, borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      leading: Icon(
                        Icons.logout,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onTap: () {},
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
        ));
  }
}
