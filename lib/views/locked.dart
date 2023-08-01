import 'package:flutter/material.dart';
import 'package:serface/app.dart';
import 'package:serface/dialogs.dart';
import 'package:serface/widgets.dart';

class SerfaceLockedView extends StatelessWidget {
  const SerfaceLockedView({ super.key });

  @override
  Widget build(BuildContext context) =>
    Scaffold(
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            ...[
              DigitalClock(
                style: Theme.of(context).textTheme.displayLarge,
              ),
              Row(
                children: [
                  BatteryBar(direction: Axis.horizontal),
                  NetworkBar(direction: Axis.horizontal),
                ],
              ),
              OutlinedButton(
                child: Text(
                  'Unlock',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                onPressed: () {
                  showLockDialog(context: context).then((passed) {
                    if (passed) {
                      SerfaceApp.of(context).unlock();
                    }
                  });
                }
              ),
            ].map(
              (child) => Padding(
                padding: const EdgeInsets.all(4),
                child: child,
              )
            ).toList(),
            const Spacer(),
          ],
        ),
      ),
    );
}
