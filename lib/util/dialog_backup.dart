import 'package:flutter/material.dart';

class DialogBackup extends StatelessWidget {
  final bool isCreateBackup;

  const DialogBackup({Key? key, required this.isCreateBackup}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Confirmar",
      ),
      content: Text(
        isCreateBackup ? "Criar backup ?" : "Restaurar backup ?",
      ),
      actions: [
        TextButton(
          child: const Text(
            "Não",
          ),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        TextButton(
          child: const Text(
            "Sim",
          ),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}
