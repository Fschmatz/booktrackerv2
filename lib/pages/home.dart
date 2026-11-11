import 'package:animations/animations.dart';
import 'package:booktrackerv2/pages/estatisticas.dart';
import 'package:booktrackerv2/pages/lista_livro_home.dart';
import 'package:booktrackerv2/util/app_constants.dart';
import 'package:flutter/material.dart';

import '../enum/situacao_livro.dart';
import '../main.dart';
import '../redux/actions.dart';
import '../redux/build_context_extension.dart';
import '../redux/selectors.dart';
import 'historico.dart';
import 'novo_livro.dart';
import 'settings.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final List<SituacaoLivro> _activeDestinations = const [
    SituacaoLivro.LENDO,
    SituacaoLivro.PARA_LER,
    SituacaoLivro.LIDO,
  ];

  void _executeOnDestinationSelected(BuildContext context, SituacaoLivro selectedDestination) async {
    await store.dispatch(ChangeTabAction(selectedDestination));
    await store.dispatch(LoadListLivroAction(selectedDestination));
  }

  @override
  Widget build(BuildContext context) {
    final currentDestination = context.select((state) => selectCurrentTab(state));
    final currentTabIndex = _activeDestinations.indexOf(currentDestination);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.appNameHomePage),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_outlined),
            tooltip: "Mais opções",
            onSelected: (value) {
              if (value == 'adicionar') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => NovoLivro(),
                  ),
                );
              } else if (value == 'historico') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const Historico(),
                  ),
                );
              } else if (value == 'estatisticas') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const Estatisticas(),
                  ),
                );
              } else if (value == 'configuracoes') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => Configs(),
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'adicionar',
                child: Row(
                  children: [
                    Icon(Icons.add_outlined),
                    SizedBox(width: 12),
                    Text('Adicionar Livro'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'historico',
                child: Row(
                  children: [
                    Icon(Icons.history_outlined),
                    SizedBox(width: 12),
                    Text('Histórico'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'estatisticas',
                child: Row(
                  children: [
                    Icon(Icons.leaderboard_outlined),
                    SizedBox(width: 12),
                    Text('Estatísticas'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'configuracoes',
                child: Row(
                  children: [
                    Icon(Icons.settings_outlined),
                    SizedBox(width: 12),
                    Text('Configurações'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              children: _activeDestinations.asMap().entries.map((entry) {
                final int index = entry.key;
                final SituacaoLivro dest = entry.value;
                final bool isSelected = currentTabIndex == index;
                final colorscheme = Theme.of(context).colorScheme;

                return Padding(
                  padding: EdgeInsets.only(right: index == _activeDestinations.length - 1 ? 0 : 8),
                  child: FilterChip(
                    label: Text(dest.nome),
                    selected: isSelected,
                    showCheckmark: false,
                    avatar: IconTheme(
                      data: IconThemeData(
                        color: isSelected ? colorscheme.onSecondaryContainer : colorscheme.onSurfaceVariant,
                        size: 18,
                      ),
                      child: Icon(isSelected ? dest.selectedIcon : dest.icon),
                    ),
                    selectedColor: colorscheme.secondaryContainer,
                    onSelected: (bool selected) {
                      if (!isSelected) {
                        _executeOnDestinationSelected(context, dest);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          PageTransitionSwitcher(
            duration: const Duration(milliseconds: 450),
            transitionBuilder: (child, animation, secondaryAnimation) => SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              fillColor: Colors.transparent,
              child: child,
            ),
            layoutBuilder: (List<Widget> entries) {
              return Stack(
                alignment: Alignment.topCenter,
                children: entries,
              );
            },
            child: ListaLivroHome(
              key: ValueKey(currentDestination.id),
              situacaoLivro: currentDestination,
            ),
          ),
        ],
      ),
    );
  }
}
