import 'package:flutter/material.dart';
import 'package:serface/apps.dart';
import 'package:serface/layouts.dart';

class SerfaceHomeView extends StatelessWidget {
  const SerfaceHomeView({ super.key });

  Widget build(BuildContext context) =>
    SerfaceMainLayout(
      child: Expanded(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: SerfaceApplications.unlockedValues.map(
              (app) => IconButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/${app.name}'),
                icon: Icon(app.icon, size: 180)
              )
            ).toList()
          )
        ),
      ),
    );
}
