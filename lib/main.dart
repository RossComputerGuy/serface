import 'package:flutter/material.dart';
import 'package:gokai/gokai.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'compat.dart';
import 'models.dart';
import 'widgets.dart';

void main() {
  runApp(const Serface());
}

class Serface extends StatelessWidget {
  const Serface({super.key});

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
                  child: const SerfaceApp(),
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
