import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'app_state.dart';

extension BuildContextExtension on BuildContext {
  AppState get state => getState<AppState>();
}