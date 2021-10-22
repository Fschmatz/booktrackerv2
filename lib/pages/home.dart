import 'package:booktrackerv2/pages/configs/pg_configs.dart';
import 'package:booktrackerv2/pages/pg_estatisticas.dart';
import 'package:booktrackerv2/pages/pg_book_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  EdgeInsetsGeometry navBarPadding = const EdgeInsets.symmetric(horizontal: 15, vertical: 10);
  int _currentIndex = 0;

  final List<Widget> _pageList = [
    PgBookList(
      key: UniqueKey(),
      bookState: 1,
    ),
    PgBookList(
      key: UniqueKey(),
      bookState: 0,
    ),
    PgBookList(
      key: UniqueKey(),
      bookState: 2,
    ),
    const PgEstatisticas()
  ];

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
        title: const Text(
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
                      builder: (BuildContext context) => const PgConfigs(),
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
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
            child: GNav(
              rippleColor: Theme.of(context).accentColor.withOpacity(0.4),
              hoverColor: Theme.of(context).accentColor.withOpacity(0.4),
              color: Theme.of(context)
                  .textTheme
                  .headline6!
                  .color!
                  .withOpacity(0.8),
              gap: 8,
              activeColor: Theme.of(context).accentColor,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              duration: const Duration(milliseconds: 500),
              tabBackgroundColor:
                  Theme.of(context).cardTheme.color!,
              backgroundColor:
                  Theme.of(context).bottomNavigationBarTheme.backgroundColor!,
              tabs: [
                GButton(
                  icon: Icons.book_outlined,
                  text: 'Lendo',
                  textStyle: styleFontNavBar,
                  padding: navBarPadding,
                ),
                GButton(
                  icon: Icons.bookmark_outline,
                  text: 'Para Ler',
                  textStyle: styleFontNavBar,
                  padding: navBarPadding,
                ),
                GButton(
                  icon: Icons.done_outlined,
                  text: 'Lidos',
                  textStyle: styleFontNavBar,
                  padding: navBarPadding,
                ),
                GButton(
                  icon: Icons.bar_chart_outlined,
                  text: 'Estatísticas',
                  textStyle: styleFontNavBar,
                  padding: navBarPadding,
                ),
              ],
              selectedIndex: _currentIndex,
              onTabChange: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
