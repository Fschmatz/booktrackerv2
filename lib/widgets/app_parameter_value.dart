
import 'package:flutter/material.dart';

import '../redux/selectors.dart';
import '../redux/build_context_extension.dart';

class AppParameterValue extends StatelessWidget {
  final String parameterKey;
  final String defaultValue;

  const AppParameterValue({
    super.key,
    required this.parameterKey,
    this.defaultValue = '',
  });

  @override
  Widget build(BuildContext context) {
    final value = context.select((state) => selectParameterValueByKey(state, parameterKey));
    return Text(value ?? defaultValue);
  }
}

