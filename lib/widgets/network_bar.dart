import 'package:nm/nm.dart';
import 'package:flutter/material.dart';

import 'network_indicator.dart';

class NetworkBar extends StatefulWidget {
  const NetworkBar({
    super.key,
    this.direction = Axis.vertical,
  });

  final Axis direction;

  @override
  State<NetworkBar> createState() => _NetworkBarState();
}

class _NetworkBarState extends State<NetworkBar> {
  UniqueKey _key = UniqueKey();
  late NetworkManagerClient _client;
  late bool _connected;

  @override
  void initState() {
    super.initState();

    _client = NetworkManagerClient();
    _connected = false;
    _connect();
  }

  void _connect() async {
    try {
      await _client.connect();
      setState(() {
        _connected = true;
      });
    } catch (e) {
      setState(() {
        _connected = false;
      });
    }
  }

  @override
  void dispose() {
    if (_connected) {
      _client.close();
      _connected = false;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
    _connected ?
      Flex(
        key: _key,
        direction: widget.direction,
        children: (_client.devices..removeWhere(
          (dev) =>
            dev.deviceType != NetworkManagerDeviceType.wifi
        )).map((dev) => NetworkIndicator(device: dev)).toList(),
      )
    : const SizedBox();
}
