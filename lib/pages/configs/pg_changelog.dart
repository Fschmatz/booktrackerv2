import 'package:flutter/material.dart';
import '../../util/changelog.dart';

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
            leading: const SizedBox(
              height: 0.1,
            ),
            title: Text("Versão Atual".toUpperCase(),
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.primary)),
          ),
          ListTile(
            leading: const Icon(
              Icons.article_outlined,
            ),
            title: Text(
              Changelog.changelogUltimaVersao,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const SizedBox(
              height: 0.1,
            ),
            title: Text("Versões Anteriores".toUpperCase(),
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.primary)),
          ),
          ListTile(
            leading: const Icon(
              Icons.article_outlined,
            ),
            title: Text(
              Changelog.changelogsAntigos,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ]));
  }
}
