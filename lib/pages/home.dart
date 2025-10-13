import 'package:animations/animations.dart';
import 'package:booktrackerv2/pages/estatisticas.dart';
import 'package:booktrackerv2/pages/lista_livro_home.dart';
import 'package:booktrackerv2/util/app_details.dart';
import 'package:flutter/material.dart';

import '../enum/situacao_livro.dart';
import '../main.dart';
import '../redux/actions.dart';
import 'configs/configs.dart';
import 'novo_livro.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  ScrollController _scrollController = ScrollController();

  List<Widget> _destinations = [
    ListaLivroHome(key: ValueKey(SituacaoLivro.LENDO.id), situacaoLivro: SituacaoLivro.LENDO),
    ListaLivroHome(key: ValueKey(SituacaoLivro.PARA_LER.id), situacaoLivro: SituacaoLivro.PARA_LER),
    ListaLivroHome(key: ValueKey(SituacaoLivro.LIDO.id), situacaoLivro: SituacaoLivro.LIDO),
  ];

  void _executeOnDestinationSelected(int index) async {
    await store.dispatch(LoadListLivroAction(SituacaoLivro.fromId(index)));

    setState(() {
      _currentIndex = index;
    });

    _scrollController.jumpTo(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Text(AppDetails.appNameHomePage),
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
                            builder: (BuildContext context) => NovoLivro(),
                          ));
                    }),
                IconButton(
                    tooltip: "Estatísticas",
                    icon: const Icon(
                      Icons.insert_chart_outlined,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => Estatisticas(),
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
                            builder: (BuildContext context) => Configs(),
                          ));
                    }),
              ],
            ),
          ];
        },
        body: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: PageTransitionSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation, secondaryAnimation) => FadeThroughTransition(
                    animation: animation,
                    secondaryAnimation: secondaryAnimation,
                    child: child,
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                  ),
              child: _destinations[_currentIndex]),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          _executeOnDestinationSelected(index);
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
            label: 'Lido',
          ),
        ],
      ),
    );
  }
}
