import 'package:flutter/material.dart';

import 'estatistica_mini_card.dart';

class EstatisticaCard extends StatelessWidget {
  final String tituloCard;
  final int? valorLendo;
  final int? valorParaLer;
  final int? valorLidos;
  final Color accent;

  const EstatisticaCard({
    Key? key,
    required this.tituloCard,
    required this.valorLendo,
    required this.valorParaLer,
    required this.valorLidos,
    required this.accent,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    int soma = ((valorLidos ?? 0) + (valorParaLer ?? 0) + (valorLendo ?? 0));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Text(tituloCard, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: accent)),
          ),
          Row(
            children: [
              EstatisticaMiniCard(
                label: 'Lendo',
                icon: Icons.book_outlined,
                value: valorLendo,
                bg: cs.surfaceContainerHighest,
                fg: cs.onSurface,
              ),
              const SizedBox(width: 8),
              EstatisticaMiniCard(
                label: 'Para Ler',
                icon: Icons.bookmark_outline_outlined,
                value: valorParaLer,
                bg: cs.surfaceContainerHighest,
                fg: cs.onSurface,
              ),
              const SizedBox(width: 8),
              EstatisticaMiniCard(
                label: 'Lidos',
                icon: Icons.task_outlined,
                value: valorLidos,
                bg: cs.surfaceContainerHighest,
                fg: cs.onSurface,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Card(
            clipBehavior: Clip.antiAlias,
            color: cs.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.format_list_bulleted_outlined, color: cs.onPrimaryContainer),
                      const SizedBox(width: 16),
                      Text(
                        'Total',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: cs.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  Text(
                    soma.toString(),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: cs.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
