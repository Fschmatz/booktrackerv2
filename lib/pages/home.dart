import 'package:animations/animations.dart';
import 'package:booktrackerv2/pages/estatisticas.dart';
import 'package:booktrackerv2/pages/book_list.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _currentIndex = 0;
  final List<Widget> _pageList = [
    BookList(
      key: UniqueKey(),
      bookState: 1,//lendo
    ),
    BookList(
      key: UniqueKey(),
      bookState: 0,//para ler
    ),
    BookList(
      key: UniqueKey(),
      bookState: 2,//lido
    ),
    const Estatisticas()
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: PageTransitionSwitcher(
          transitionBuilder: (child, animation, secondaryAnimation) =>
              FadeThroughTransition(
                fillColor: Theme.of(context).scaffoldBackgroundColor,
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                child: child,
              ),
          child: _pageList[_currentIndex]),
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
            icon: Icon(Icons.task_outlined),
            selectedIcon: Icon(
              Icons.task,
            ),
            label: 'Lidos',
          ),
          NavigationDestination(
            icon: Icon(Icons.insert_chart_outlined),
            selectedIcon: Icon(
              Icons.insert_chart,
            ),
            label: 'Estatísticas',
          ),
        ],
      ),
    );
  }
}
