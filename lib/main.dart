import 'package:flutter/material.dart';
import 'package:gokai/gokai.dart';
import 'package:provider/provider.dart';

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
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => BatteryModel(snapshot.data!)),
              Provider(create: (context) => snapshot.data!),
            ],
            child: MaterialApp(
              title: 'Serface',
              theme: _buildTheme(),
              darkTheme: _buildTheme(brightness: Brightness.dark),
              routes: {
                '/': (_) => const SerfaceHomeView(),
              },
            ),
          );
        }
        return const SizedBox();
      },
    );
}
