import 'package:flutter/material.dart';
import '../util/versaoNomeChangelog.dart';

class Changelog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Changelog"),
          elevation: 0.0,
        ),
        body: ListView(children: <Widget>[
          ListTile(
            leading: SizedBox(
              height: 0.1,
            ),
            title: Text("Versão Atual".toUpperCase(),
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).accentColor)),
          ),
          ListTile(
            leading: Icon(
              Icons.article_outlined,
            ),
            title: Text(
              VersaoNomeChangelog.changelogUltimaVersao,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Divider(),
          ListTile(
            leading: SizedBox(
              height: 0.1,
            ),
            title: Text("Versões Anteriores".toUpperCase(),
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).accentColor)),
          ),
          ListTile(
            leading: Icon(
              Icons.article_outlined,
            ),

            title: Text(
              VersaoNomeChangelog.changelogsAntigos,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ]));
  }
}
