import 'package:booktrackerv2/pages/configs/pgConfigs.dart';
import 'package:booktrackerv2/pages/pgEstatisticas.dart';
import 'package:booktrackerv2/pages/pgLendo.dart';
import 'package:booktrackerv2/pages/pgLidos.dart';
import 'package:booktrackerv2/pages/pgParaLer.dart';
import 'package:booktrackerv2/pages/pgNovoLivro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  bool verFab = true;
  List<Widget> _pageList = [PgLendo(),PgParaLer(),PgLidos(),PgEstatisticas()];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    TextStyle styleFontNavBar =
    TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600, color: Theme.of(context).accentColor);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'BookTracker',
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.settings_outlined,
                color: Theme.of(context)
                    .textTheme
                    .headline6!
                    .color!
                    .withOpacity(0.8),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => PgConfigs(),
                      fullscreenDialog: true,
                    ));
              }),
        ],
      ),
      body: _pageList[_currentIndex],

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).bottomNavigationBarTheme.backgroundColor!,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Theme.of(context).accentColor.withOpacity(0.4),
              hoverColor: Theme.of(context).accentColor.withOpacity(0.4),
              color: Theme.of(context)
                  .textTheme
                  .headline6!
                  .color!
                  .withOpacity(0.8),
              gap: 5,
              activeColor: Theme.of(context).accentColor,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor:
                  Theme.of(context).accentColor.withOpacity(0.3),
              backgroundColor:
                  Theme.of(context).bottomNavigationBarTheme.backgroundColor!,
              tabs: [
                GButton(
                  icon: Icons.book_outlined,
                  text: 'Lendo',
                  textStyle: styleFontNavBar,
                ),
                GButton(
                  icon: Icons.bookmark_outline,
                  text: 'Para Ler',
                  textStyle: styleFontNavBar,
                ),
                GButton(
                  icon: Icons.done_outlined,
                  text: 'Lidos',
                  textStyle: styleFontNavBar,
                ),
                GButton(
                  icon: Icons.bar_chart_outlined,
                  text: 'Estatísticas',
                  textStyle: styleFontNavBar,
                ),
              ],
              selectedIndex: _currentIndex,
              onTabChange: (index) {
                setState(() {
                  _currentIndex = index;
                  if (index == 3) {
                    verFab = false;
                  } else {
                    verFab = true;
                  }
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
