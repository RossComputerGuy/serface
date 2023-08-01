import 'package:serface/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'battery_indicator.dart';

class BatteryBar extends StatelessWidget {
  const BatteryBar({
    super.key,
    this.direction = Axis.vertical,
  });

  final Axis direction;

  @override
  Widget build(BuildContext context) =>
    Consumer<BatteryModel>(
      builder: (context, model, child) {
        if (model.integratedItems.isEmpty) {
          return const SizedBox();
        }

        return Flex(
          direction: direction,
          children: model.integratedItems.map(
            (device) => BatteryIndicator(device: device)
          ).toList(),
        );
      },
    );
}
