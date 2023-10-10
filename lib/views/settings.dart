import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:nextcloud/nextcloud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:serface/apps.dart';
import 'package:serface/app.dart';
import 'package:serface/dialogs.dart';
import 'package:serface/layouts.dart';
import 'package:serface/settings.dart';

class SerfaceSettingsView extends StatefulWidget {
  const SerfaceSettingsView({ super.key });

  @override
  State<SerfaceSettingsView> createState() => _SerfaceSettingsViewState();
}

class _SerfaceSettingsViewState extends State<SerfaceSettingsView> {
  late bool unlocked;

  @override
  void initState() {
    super.initState();
    unlocked = false;
  }

  @override
  Widget build(BuildContext context) {
    if (context.mounted && !unlocked) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        showLockDialog(context: context).then((value) {
          if (!value) Navigator.pushReplacementNamed(context, '/');
          else setState(() {
            unlocked = true;
          });
        });
      });
    }

    final prefs = Provider.of<SharedPreferences>(context)!;
    return SerfaceMainLayout(
      child: ListTileTheme(
        tileColor: Colors.indigo,
        textColor: Colors.white,
        iconColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Ionicons.key),
              title: Text('Set admin code'),
              onTap: () {
                showPasscodeChangeDialog(context: context).then((value) {
                  if (value) setState(() {
                    unlocked = false;
                  });
                });
              }
            ),
            ListTile(
              leading: Icon(Ionicons.list),
              title: Text('Set theme mode'),
              onTap: () => showDialog(
                context: context,
                builder: (context) =>
                  AlertDialog(
                    title: const Text('Set theme mode'),
                    content: StatefulBuilder(
                      builder: (context, setState) {
                        final prefTheme = SerfaceSettings.theme.valueFor(prefs);
                        return Column(
                          children: ThemeMode.values.map(
                            (mode) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: RadioListTile<ThemeMode>(
                                title: Text(mode.name.substring(0, 1).toUpperCase() + mode.name.substring(1)),
                                value: mode,
                                groupValue: ThemeMode.values.firstWhere((v) => v.name == prefTheme),
                                onChanged: (value) {
                                  setState(() {
                                    if (value != null) {
                                      prefs.setString(SerfaceSettings.theme.name, value!.name);
                                      SerfaceApp.of(context).reload();
                                    }
                                  });
                                },
                              ),
                            )
                          ).toList()
                        );
                      },
                    ),
                  ),
              ),
            ),
            ListTile(
              leading: Icon(Ionicons.alarm),
              title: Text('Set screen time limit'),
              onTap: () {
                final fullMinutes = SerfaceSettings.screenTimeLock.valueFor(prefs);
                showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(hour: fullMinutes ~/ 60, minute: fullMinutes % 60),
                ).then((duration) {
                  if (duration != null) {
                    prefs.setInt(SerfaceSettings.screenTimeLock.name, (duration!.hour * 60) + duration!.minute);
                    SerfaceApp.of(context).resetTimers();
                  }
                });
              },
            ),
            ListTile(
              leading: Icon(Ionicons.alarm),
              title: Text('Set duration of the screen time limit'),
              onTap: () {
                final fullMinutes = SerfaceSettings.screenTimeUnlock.valueFor(prefs);
                showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(hour: fullMinutes ~/ 60, minute: fullMinutes % 60),
                ).then((duration) {
                  if (duration != null) {
                    prefs.setInt(SerfaceSettings.screenTimeUnlock.name, (duration!.hour * 60) + duration!.minute);
                    SerfaceApp.of(context).resetTimers();
                  }
                });
              },
            ),
            ListTile(
              leading: Icon(Ionicons.person),
              title: Text('Set Nextcloud login'),
              onTap: () => showDialog(
                context: context,
                builder: (context) => const NextcloudLogin(),
              ),
            ),
            ListTile(
              leading: Icon(Ionicons.exit),
              title: Text('Exit to desktop'),
              onTap: () => appWindow.close(),
            ),
          ].map(
            (child) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: child,
            )
          ).toList(),
        ),
      ),
    );
  }
}
