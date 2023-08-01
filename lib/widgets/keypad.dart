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

  Widget _buildRow(BuildContext context, int y) =>
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
        (x) {
          final i = (y * 3) + x;
          return Padding(
            padding: const EdgeInsets.all(8),
            child: KeypadKey(
              value: i,
              onPressed: () => setState(() {
                _value += '$i';
                if (widget.onPressed != null) widget.onPressed!(_value);
              }),
            ),
          );
        },
      ),
    );

  @override
  Widget build(BuildContext context) =>
    Column(
      children: [
        ...List.generate(
          3,
          (y) => _buildRow(context, y),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            KeypadKey(
              value: 9,
              onPressed: () => setState(() {
                _value += '9';
                if (widget.onPressed != null) widget.onPressed!(_value);
              }),
            ),
          ].map(
            (child) => Padding(
              padding: const EdgeInsets.all(8),
              child: child,
            )
          ).toList(),
        ),
      ],
    );
}
