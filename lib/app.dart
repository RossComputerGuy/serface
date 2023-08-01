import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'apps.dart';
import 'settings.dart';
import 'views.dart';

class SerfaceApp extends StatefulWidget {
  const SerfaceApp({ super.key });

  @override
  State<SerfaceApp> createState() => SerfaceAppState();

  static SerfaceAppState of(BuildContext context) => context.findAncestorStateOfType<SerfaceAppState>()!;
}

class SerfaceAppState extends State<SerfaceApp> {
  UniqueKey _key = UniqueKey();

  ThemeData _buildTheme({Brightness brightness = Brightness.light})
    => ThemeData(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.green,
        accentColor: Colors.white,
        brightness: brightness,
      ),
      useMaterial3: true,
    );

  void reload() {
    setState(() {
      _key = UniqueKey();
    });
  }

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    final prefs = Provider.of<SharedPreferences>(context)!;
    final prefTheme = SerfaceSettings.theme.valueFor(prefs);
    return MaterialApp(
      key: _key,
      title: 'Serface',
      theme: _buildTheme(),
      darkTheme: _buildTheme(brightness: Brightness.dark),
      themeMode: ThemeMode.values.firstWhere((v) => v.name == prefTheme),
      routes: <String, WidgetBuilder>{
        '/': (_) => const SerfaceHomeView(),
      }..addEntries(SerfaceApplications.values
        .map((app) => MapEntry('/${app.name}', app.builder)).toList()
      ),
    );
  }
}
