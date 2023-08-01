import 'package:flutter/material.dart';
import 'package:serface/apps.dart';
import 'package:serface/dialogs.dart';
import 'package:serface/layouts.dart';

class SerfaceSettingsView extends StatefulWidget {
  const SerfaceSettingsView({ super.key });

  @override
  State<SerfaceSettingsView> createState() => _SerfaceSettingsViewState();
}

class _SerfaceSettingsViewState extends State<SerfaceSettingsView> {
  bool unlocked = false;

  @override
  Widget build(BuildContext context) {
    if (context.mounted && !unlocked) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        showLockDialog(context: context).then((value) {
          if (value == null) Navigator.pushReplacementNamed(context, '/');
          // TODO: check passcode
        });
      });
    }
    return SerfaceMainLayout(
      child: const SizedBox(),
    );
  }
}
