import 'package:flutter/material.dart';

class ModalInfoTile extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle labelStyle = const TextStyle(fontSize: 16);

  const ModalInfoTile({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: VisualDensity.compact,
      leading: Text(
        label,
        style: labelStyle,
      ),
      title: Text(
        value,
      ),
    );
  }
}
