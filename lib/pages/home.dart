import 'package:booktrackerv2/pages/pg_estatisticas.dart';
import 'package:booktrackerv2/pages/pg_book_list.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _currentIndex = 0;

  final List<Widget> _pageList = [
    PgBookList(
      key: UniqueKey(),
      bookState: 1,//lendo
    ),
    PgBookList(
      key: UniqueKey(),
      bookState: 0,//para ler
    ),
    PgBookList(
      key: UniqueKey(),
      bookState: 2,//lido
    ),
    const PgEstatisticas()
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: _pageList[_currentIndex],
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
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
            ),
            label: 'Lendo',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_outline_outlined),
            selectedIcon: Icon(
              Icons.bookmark,
            ),
            label: 'Para Ler',
          ),
          NavigationDestination(
            icon: Icon(Icons.done_outlined),
            selectedIcon: Icon(
              Icons.done,
            ),
            label: 'Lidos',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(
              Icons.bar_chart,
            ),
            label: 'Estatísticas',
          ),
        ],
      ),
    );
  }
}
