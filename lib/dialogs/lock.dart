import 'package:flutter/material.dart';
import 'package:serface/widgets.dart';

class LockDialog extends StatefulWidget {
  const LockDialog({
    super.key
  });

  @override
  State<LockDialog> createState() => _LockDialogState();
}

class _LockDialogState extends State<LockDialog> {
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
      title: const Text('Application requires code'),
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
          child: const Text('Unlock'),
        ),
      ],
    );
}

Future<String?> showLockDialog({
  required BuildContext context
}) => showDialog(
  context: context,
  builder: (context) => LockDialog(),
  barrierDismissible: false,
);
