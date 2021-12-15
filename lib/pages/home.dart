import 'package:booktrackerv2/pages/pg_estatisticas.dart';
import 'package:booktrackerv2/pages/pg_book_list.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  EdgeInsetsGeometry navBarPadding =
      const EdgeInsets.symmetric(horizontal: 15, vertical: 10);
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
    TextStyle styleFontNavBar = TextStyle(
        fontSize: 14.5,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).accentColor);

    return Scaffold(
      body: _pageList[_currentIndex],
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        animationDuration: const Duration(seconds: 1),
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.book_outlined),
            selectedIcon: Icon(
              Icons.book,
              color: Colors.black87,
            ),
            label: 'Lendo',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_outline),
            selectedIcon: Icon(
              Icons.bookmark,
              color: Colors.black87,
            ),
            label: 'Para Ler',
          ),
          NavigationDestination(
            icon: Icon(Icons.done_outlined),
            selectedIcon: Icon(
              Icons.done,
              color: Colors.black87,
            ),
            label: 'Lidos',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(
              Icons.bar_chart,
              color: Colors.black87,
            ),
            label: 'Estatísticas',
          ),
        ],
      ),
    );
  }
}
