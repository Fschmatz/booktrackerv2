import 'package:flutter/material.dart';

import 'app_details.dart';
import 'backup_utils.dart';

class DialogBackup extends StatefulWidget {
  final bool isCreateBackup;

  DialogBackup({Key? key, required this.isCreateBackup}) : super(key: key);

  @override
  State<DialogBackup> createState() => _DialogBackupState();
}

class _DialogBackupState extends State<DialogBackup> {
  Future<void> _createBackup() async {
    await BackupUtils().backupData(AppDetails.backupFileName);
  }

  Future<void> _restoreFromBackup() async {
    await BackupUtils().restoreBackupData(AppDetails.backupFileName);
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
            if (widget.isCreateBackup) {
              Navigator.of(context).pop();
              _createBackup();
            } else {
              Navigator.of(context).pop();
              _restoreFromBackup();
            }
          },
        )
      ],
    );
  }
}
