import 'package:flutter/material.dart';
import 'package:serface/widgets.dart';

class SerfaceMainLayout extends StatelessWidget {
  const SerfaceMainLayout({ super.key, required this.child });

  final Widget child;

  @override
  Widget build(BuildContext context) =>
    Scaffold(
      body: Row(
        children: [
          const SerfaceNavigation(),
          child
        ],
      ),
    );
}
