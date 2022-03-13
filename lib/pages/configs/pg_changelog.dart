import 'package:flutter/material.dart';
import '../../util/app_details.dart';

class PgChangelog extends StatelessWidget {
  const PgChangelog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Changelog"),
        ),
        body: ListView(children: <Widget>[
          ListTile(
            title: Text("Versão Atual",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary)),
          ),
          ListTile(
            leading: const Icon(
              Icons.article_outlined,
            ),
            title: Text(
              AppDetails.changelogUltimaVersao,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          ListTile(
            title: Text("Versões Anteriores",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary)),
          ),
          ListTile(
            leading: const Icon(
              Icons.article_outlined,
            ),
            title: Text(
              AppDetails.changelogsAntigos,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ]));
  }
}
