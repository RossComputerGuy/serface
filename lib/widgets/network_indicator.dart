import 'dart:async';
import 'package:nm/nm.dart';
import 'package:flutter/material.dart';

class NetworkIndicator extends StatefulWidget {
  const NetworkIndicator({
    super.key,
    required this.device,
  });

  final NetworkManagerDevice device;

  @override
  State<NetworkIndicator> createState() => _NetworkIndicatorState();
}

class _NetworkIndicatorState extends State<NetworkIndicator> {
  late Timer timer;

  @override
  void initState() {
    super.initState();

    _update();
    timer = Timer.periodic(const Duration(minutes: 5), (timer) {
      _update();
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  void _update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.device.wireless != null) {
      if (widget.device.state == NetworkManagerDeviceState.activated) {
        if (widget.device.wireless!.activeAccessPoint != null) {
          final ap = widget.device.wireless!.activeAccessPoint!;
          if (ap.strength < 100) return Icon(Icons.network_wifi_3_bar);
          if (ap.strength < 60) return Icon(Icons.network_wifi_2_bar);
          if (ap.strength < 30) return Icon(Icons.network_wifi_1_bar);
        }
        return Icon(Icons.wifi, size: 60);
      }

      return Icon(Icons.signal_wifi_statusbar_null, size: 60);
    }
    return const SizedBox();
  }
}
