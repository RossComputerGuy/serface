import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:serface/apps.dart';
import 'package:serface/dialogs.dart';
import 'package:serface/layouts.dart';

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
              leading: Icon(
                Ionicons.key
              ),
              title: Text('Set admin code'),
              onTap: () {
                showPasscodeChangeDialog(context: context).then((value) {
                  if (value) setState(() {
                    unlocked = false;
                  });
                });
              }
            ),
          ],
        ),
      ),
    );
  }
}
