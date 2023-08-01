import 'package:flutter/material.dart';
import 'package:gokai/gokai.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'apps.dart';
import 'compat.dart';
import 'models.dart';
import 'views.dart';
import 'widgets.dart';

void main() {
  runApp(const SerfaceApp());
}

class SerfaceApp extends StatelessWidget {
  const SerfaceApp({super.key});

  ThemeData _buildTheme({Brightness brightness = Brightness.light})
    => ThemeData(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.green,
        accentColor: Colors.white,
        brightness: brightness,
      ),
      useMaterial3: true,
    );

  @override
  Widget build(BuildContext context) =>
    FutureBuilder(
      future: GokaiContext().init(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final gokaiContext = snapshot.data!;
          SharedPreferencesGokai.registerWith(context: gokaiContext);
          return FutureBuilder(
            future: SharedPreferences.getInstance(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final prefs = snapshot.data!;
                return MultiProvider(
                  providers: [
                    ChangeNotifierProvider(create: (context) => BatteryModel(gokaiContext)),
                    Provider(create: (context) => gokaiContext),
                    Provider(create: (context) => prefs),
                  ],
                  child: MaterialApp(
                    title: 'Serface',
                    theme: _buildTheme(),
                    darkTheme: _buildTheme(brightness: Brightness.dark),
                    routes: <String, WidgetBuilder>{
                      '/': (_) => const SerfaceHomeView(),
                    }..addEntries(SerfaceApplications.values
                      .map((app) => MapEntry('/${app.name}', app.builder)).toList()
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          );
        }
        return const SizedBox();
      },
    );
}
