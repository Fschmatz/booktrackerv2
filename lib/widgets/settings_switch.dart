import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';

import '../class/app_parameter.dart';
import '../redux/actions.dart';

import '../redux/selectors.dart';
import '../redux/build_context_extension.dart';

class SettingsSwitch extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String parameterKey;
  final bool defaultValue;

  const SettingsSwitch({
    super.key,
    required this.title,
    this.subtitle,
    required this.parameterKey,
    this.defaultValue = true,
  });

  @override
  Widget build(BuildContext context) {
    final value = context.select((state) => selectParameterValueByKeyAsBoolean(state, parameterKey, defaultValue: defaultValue));

    return SwitchListTile(
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      value: value,
      onChanged: (newValue) {
        StoreProvider.dispatch(
          context,
          SaveAppParameterAction(
            AppParameter(
              key: parameterKey,
              value: newValue.toString(),
            ),
          ),
        );
      },
    );
  }
}
