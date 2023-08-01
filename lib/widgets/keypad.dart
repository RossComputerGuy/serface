import 'package:flutter/material.dart';

import 'keypad_key.dart';

class Keypad extends StatefulWidget {
  const Keypad({
    super.key,
    this.onPressed,
  });

  final void Function(String value)? onPressed;

  @override
  State<Keypad> createState() => _KeypadState();
}

class _KeypadState extends State<Keypad> {
  String _value = '';

  @override
  Widget build(BuildContext context) =>
    GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      padding: const EdgeInsets.all(8),
      children: List.generate(
        10,
        (i) => KeypadKey(
          value: i,
          onPressed: () => setState(() {
            _value += '$i';
            if (widget.onPressed != null) widget.onPressed!(_value);
          }),
        )
      ),
    );
}
