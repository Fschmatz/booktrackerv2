import 'package:flutter/material.dart';

import 'backup_utils.dart';

class DialogBackup extends StatefulWidget {
  final bool isCreateBackup;

  DialogBackup({Key? key, required this.isCreateBackup}) : super(key: key);

  @override
  State<DialogBackup> createState() => _DialogBackupState();
}

class _DialogBackupState extends State<DialogBackup> {
  Future<void> _createBackup() async {
    await BackupUtils().backupData();
  }

  Future<void> _restoreFromBackup() async {
    await BackupUtils().restoreBackupData();
  }

  Future<void> _executarBackup() async {
    Navigator.of(context).pop();

    if (widget.isCreateBackup) {
      _createBackup();
    } else {
      _restoreFromBackup();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Confirmar",
      ),
      content: Text(
        widget.isCreateBackup ? "Criar backup ?" : "Restaurar backup ?",
      ),
      actions: [
        TextButton(
          child: const Text(
            "Sim",
          ),
          onPressed: () {
            _executarBackup();
          },
        )
      ],
    );
  }
}
