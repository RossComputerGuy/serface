import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upower/upower.dart';
import 'battery_indicator.dart';

class BatteryBar extends StatefulWidget {
  const BatteryBar({
    super.key,
    this.direction = Axis.vertical,
  });

  final Axis direction;

  @override
  State<BatteryBar> createState() => _BatteryBarState();
}

class _BatteryBarState extends State<BatteryBar> {
  var _client = UPowerClient();
  List<UPowerDevice> _devices = [];

  @override
  void initState() {
    super.initState();

    _client.connect().then((_) {
      setState(() {
        _devices = _client.devices
          ..removeWhere((d) => d.type != UPowerDeviceType.battery);
      });
    });
  }

  @override
  void dispose() {
    _client.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
    Flex(
      direction: widget.direction,
      children: _devices.map((device) =>
        BatteryIndicator(device: device)
      ).toList(),
    );
}
