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
          IconButton(
            tooltip: "Adicionar Livro",
            icon: const Icon(Icons.add_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => NovoLivro(),
                ),
              );
            },
          ),
          IconButton(
            tooltip: "Estatísticas",
            icon: const Icon(Icons.leaderboard_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => Estatisticas(),
                ),
              );
            },
          ),
          IconButton(
            tooltip: "Configurações",
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => Configs(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                        color: isSelected ? colorscheme.onPrimaryContainer : colorscheme.onSurfaceVariant,
                        size: 18,
                      ),
                      child: Icon(isSelected ? dest.selectedIcon : dest.icon),
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    side: BorderSide.none,
                    selectedColor: colorscheme.primaryContainer,
                    backgroundColor: colorscheme.surfaceContainerHigh,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? colorscheme.onPrimaryContainer : colorscheme.onSurfaceVariant,
                    ),
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
