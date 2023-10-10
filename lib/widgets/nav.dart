import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:serface/apps.dart';

import 'battery_bar.dart';
import 'clock.dart';
import 'network_bar.dart';

class SerfaceNavigation extends StatelessWidget {
  const SerfaceNavigation({
    super.key,
  });

  int _computeIndex(BuildContext context) {
    final routeName = ModalRoute.of(context)!.settings!.name;
    if (routeName == '/') return 0;
    return SerfaceApplications.values.indexWhere((app) => routeName == '/${app.name}') + 1;
  }

  @override
  Widget build(BuildContext context) =>
    Container(
      constraints: BoxConstraints.tightFor(width: 100),
      child: NavigationRail(
        selectedIndex: _computeIndex(context),
        trailing: Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              children: [
                const Spacer(),
                const BatteryBar(),
                const NetworkBar(),
                DigitalClock(
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        onDestinationSelected: (i) {
          if (i == 0) {
            Navigator.pushReplacementNamed(context, '/');
          } else {
            final app = SerfaceApplications.values[i - 1];
            Navigator.pushReplacementNamed(context, '/${app.name}');
          }
        },
        destinations: [
          NavigationRailDestination(
            icon: Icon(Ionicons.home, size: 60),
            selectedIcon: Icon(
              Ionicons.home,
              size: 60,
              color: Colors.blue,
            ),
            label: Text('Home'),
          ),
        ]..addAll(SerfaceApplications.values.map(
          (app) => app.buildNavigation(context)
        ).toList()),
      ),
    );
}
