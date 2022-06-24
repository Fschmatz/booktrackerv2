import 'package:flutter/material.dart';
import '../../util/app_details.dart';

class Changelog extends StatelessWidget {
  const Changelog({Key? key}) : super(key: key);

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
            ),
          ),
        ]));
  }
}
