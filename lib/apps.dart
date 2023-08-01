import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import 'views.dart';

Widget _buildPuzzles(BuildContext context) => const SerfacePuzzlesView();
Widget _buildYouTube(BuildContext context) => const SerfaceYouTubeView();
Widget _buildSettings(BuildContext context) => const SerfaceSettingsView();

enum SerfaceApplications {
  puzzles(icon: Ionicons.extension_puzzle, name: 'Puzzels', builder: _buildPuzzles),
  youtube(icon: Ionicons.logo_youtube, name: 'YouTube', builder: _buildYouTube),
  settings(icon: Ionicons.settings, name: 'Settings', isUnlocked: false, builder: _buildSettings);

  const SerfaceApplications({
    required this.icon,
    required this.name,
    this.isUnlocked = true,
    required this.builder,
  });

  final IconData icon;
  final String name;
  final bool isUnlocked;
  final WidgetBuilder builder;

  NavigationRailDestination buildNavigation(BuildContext context) =>
    NavigationRailDestination(
      icon: Icon(icon, size: 60),
      selectedIcon: Icon(
        icon,
        size: 60,
        color: Colors.blue,
      ),
      label: Text(name),
    );

  static List<SerfaceApplications> get unlockedValues =>
    values.toList()
      ..removeWhere((item) => !item.isUnlocked);
}
