import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

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
  final _navigatorKey = GlobalKey<NavigatorState>();
  late bool _locked;
  Timer? _lockTimer;
  Timer? _unlockTimer;

  ThemeData _buildTheme({Brightness brightness = Brightness.light})
    => ThemeData.from(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.green,
        accentColor: Colors.white,
        brightness: brightness,
      ),
      textTheme: GoogleFonts.notoSansTextTheme(),
      useMaterial3: true,
    );

  void reload() {
    resetTimers();

    setState(() {
      _key = UniqueKey();
    });
  }

  void resetTimers() {
    _setLockTimer();
    _setUnlockTimer();
  }

  @override
  void initState() {
    super.initState();

    _locked = false;
    resetTimers();
  }

  @override
  void dispose() {
    if (_lockTimer != null) _lockTimer!.cancel();
    if (_unlockTimer != null) _unlockTimer!.cancel();
    super.dispose();
  }

  void lock() {
    if (!_locked) {
      _navigatorKey.currentState!.pushNamed('/locked');
      _locked = true;
    }
  }

  void unlock() {
    if (_locked) {
      _navigatorKey.currentState!.pop();
      _locked = false;
    }
  }

  void _setLockTimer() {
    SerfaceSettings.screenTimeLock.value.then((screenTime) {
      if (_lockTimer != null) {
        _lockTimer!.cancel();
      }

      _lockTimer = Timer.periodic(Duration(minutes: screenTime), (timer) {
        lock();
      });
    });
  }

  void _setUnlockTimer() {
    SerfaceSettings.screenTimeUnlock.value.then((screenTime) {
      if (_unlockTimer != null) {
        _unlockTimer!.cancel();
      }

      _unlockTimer = Timer.periodic(Duration(minutes: screenTime), (timer) {
        unlock();
      });
    });
  }

  Widget build(BuildContext context) {
    final prefs = Provider.of<SharedPreferences>(context)!;
    final prefTheme = SerfaceSettings.theme.valueFor(prefs);
    return MaterialApp(
      key: _key,
      navigatorKey: _navigatorKey,
      title: 'Serface',
      theme: _buildTheme(),
      darkTheme: _buildTheme(brightness: Brightness.dark),
      themeMode: ThemeMode.values.firstWhere((v) => v.name == prefTheme),
      routes: <String, WidgetBuilder>{
        '/': (_) => const SerfaceHomeView(),
        '/locked': (_) => const SerfaceLockedView(),
      }..addEntries(SerfaceApplications.values
        .map((app) => MapEntry('/${app.name}', app.builder)).toList()
      ),
    );
  }
}
