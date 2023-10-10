import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:media_kit/media_kit.dart';

import 'app.dart';
import 'widgets.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();

  runApp(const Serface());
}

class Serface extends StatelessWidget {
  const Serface({super.key});

  @override
  Widget build(BuildContext context) =>
    FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final prefs = snapshot.data!;
          return MultiProvider(
            providers: [
              Provider(create: (context) => prefs),
            ],
            child: const SerfaceApp(),
          );
        }
        return const SizedBox();
      },
    );
}
