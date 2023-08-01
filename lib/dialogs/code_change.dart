import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:serface/widgets.dart';
import 'package:serface/settings.dart';

class CodeChangeDialog extends StatefulWidget {
  const CodeChangeDialog({
    super.key
  });

  @override
  State<CodeChangeDialog> createState() => _CodeChangeDialogState();
}

class _CodeChangeDialogState extends State<CodeChangeDialog> {
  TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
    AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Text('Enter new passcode'),
      content: Column(
        children: [
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
          ),
          Keypad(
            onPressed: (value) {
              _controller.text = value;
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(_controller.text),
          child: const Text('Change'),
        ),
      ],
    );
}

Future<bool> showPasscodeChangeDialog({
  required BuildContext context
}) async {
  final code = await showDialog<String>(
    context: context,
    builder: (context) => CodeChangeDialog(),
  );

  if (code == null) return false;

  final prefs = Provider.of<SharedPreferences>(context, listen: false)!;
  prefs.setString(SerfaceSettings.adminCode.name, code!);
  return true;
}
