import 'package:animations/animations.dart';
import 'package:booktrackerv2/pages/estatisticas.dart';
import 'package:booktrackerv2/pages/lista_livro_home.dart';
import 'package:booktrackerv2/util/app_details.dart';
import 'package:flutter/material.dart';

import 'configs/configs.dart';
import 'novo_livro.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  ScrollController scrollController = ScrollController();
  List<Widget> _pageList = [
    ListaLivroHome(
      key: UniqueKey(),
      bookState: 0, //lendo
    ),
    ListaLivroHome(
      key: UniqueKey(),
      bookState: 1, //para ler
    ),
    ListaLivroHome(
      key: UniqueKey(),
      bookState: 2, //lido
    ),
    const Estatisticas()
  ];

  void refreshHome() {
    setState(() {
      _pageList = [
        ListaLivroHome(
          key: UniqueKey(),
          bookState: 0, //lendo
        ),
        ListaLivroHome(
          key: UniqueKey(),
          bookState: 1, //para ler
        ),
        ListaLivroHome(
          key: UniqueKey(),
          bookState: 2, //lido
        ),
        const Estatisticas()
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title:  Text(AppDetails.appNameHomePage),
              pinned: false,
              floating: true,
              snap: true,
              actions: [
                IconButton(
                    tooltip: "Adicionar Livro",
                    icon: const Icon(
                      Icons.add_outlined,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => NovoLivro(
                              refreshHome: refreshHome,
                            ),
                          ));
                    }),
                IconButton(
                    tooltip: "Configurações",
                    icon: const Icon(
                      Icons.settings_outlined,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => Configs(
                              refresh: refreshHome,
                            ),
                          ));
                    }),
              ],
            ),
          ];
        },
        body:  MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: PageTransitionSwitcher(
              duration: const Duration(milliseconds: 700),
              transitionBuilder: (child, animation, secondaryAnimation) =>
                  FadeThroughTransition(
                    animation: animation,
                    secondaryAnimation: secondaryAnimation,
                    child: child,
                  ),
              child: _pageList[_currentIndex]),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
          scrollController.jumpTo(0);
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
