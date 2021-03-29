import 'package:flutter/material.dart';
import '../util/versaoNomeChangelog.dart';

class Changelog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Changelog"),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: ListView(children: <Widget>[
          Card(
            margin: EdgeInsets.fromLTRB(15, 12, 15, 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: Colors.grey[600].withOpacity(0.3),
                width: 1,
              ),
            ),
            elevation: 2,
            child: Container(
              padding: EdgeInsets.fromLTRB(18, 0, 18, 5),
              child: Text(
                versaoNomeChangelog.changelogUltimaVersao,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),

          Divider(thickness: 2,),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Versões Anteriores: ",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  versaoNomeChangelog.changelogsAntigos,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ]));
  }
}
