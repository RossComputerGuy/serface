import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SerfaceSettings<T> {
  adminCode('0000'),
  theme('system');

  const SerfaceSettings(this.defaultValue);

  final T defaultValue;
  T valueFor(SharedPreferences prefs) => (prefs.get(name) as T?) ?? defaultValue;
  Future<T> get value async => valueFor(await SharedPreferences.getInstance());

  @override
  toString() => '$name:${T.toString()}';
}
