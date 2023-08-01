import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

enum SerfaceApplications {
  puzzles(icon: Ionicons.extension_puzzle, name: 'Puzzels'),
  youtube(icon: Ionicons.logo_youtube, name: 'YouTube'),
  settings(icon: Ionicons.settings, name: 'Settings');

  const SerfaceApplications({
    required this.icon,
    required this.name
  });

  final IconData icon;
  final String name;

  NavigationRailDestination buildNavigation(BuildContext context) =>
    NavigationRailDestination(
      icon: Icon(icon),
      label: Text(name),
    );
}
