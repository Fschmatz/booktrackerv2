import 'package:flutter/material.dart';

import 'app_details.dart';
import 'backup_utils.dart';

class DialogBackup extends StatefulWidget {

  bool isCreateBackup;
  Function()? reloadHomeFunction;

  DialogBackup({Key? key, required this.isCreateBackup, required this.reloadHomeFunction}) : super(key: key);

  @override
  _DialogBackupState createState() => _DialogBackupState();
}

class _DialogBackupState extends State<DialogBackup> {

  Future<void> _createBackup() async {
    await BackupUtils().backupData(AppDetails.backupFileName);
  }

  Future<void> _restoreFromBackup() async {
    await BackupUtils().restoreBackupData(AppDetails.backupFileName);
    widget.reloadHomeFunction!();
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: const Text(
        "Confirmar",
      ),
      content:  Text(
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
