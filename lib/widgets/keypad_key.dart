import 'package:flutter/material.dart';

class KeypadKey extends StatelessWidget {
  const KeypadKey({
    super.key,
    required this.value,
    required this.onPressed
  });

  final int value;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) =>
    Center(
      child: Container(
        width: 60,
        height: 60,
        child: FloatingActionButton(
          onPressed: onPressed,
          backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
          child: Text(
            '$value',
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
}
