import 'package:flutter/material.dart';
import 'package:serface/widgets.dart';

class SerfaceMainLayout extends StatelessWidget {
  const SerfaceMainLayout({
    super.key,
    required this.child,
    this.scaffoldKey,
  });

  final Widget child;
  final Key? scaffoldKey;

  @override
  Widget build(BuildContext context) =>
    Scaffold(
      key: scaffoldKey,
      body: Row(
        children: [
          const SerfaceNavigation(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: child,
            ),
          ),
        ],
      ),
    );
}
