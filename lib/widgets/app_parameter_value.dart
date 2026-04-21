import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import '../redux/app_state.dart';
import '../redux/selectors.dart';

class AppParameterValue extends StatelessWidget {
  final String parameterKey;

  const AppParameterValue({
    super.key,
    required this.parameterKey,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, String?>(
      converter: (store) => selectParameterValueByKey(parameterKey),
      builder: (context, value) {
        return Text(value ?? '');
      },
    );
  }
}
