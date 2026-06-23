import 'package:flutter/material.dart';

class EstatisticaAutoresCard extends StatelessWidget {
  final String tituloCard;
  final int? valor;
  final Color accent;

  const EstatisticaAutoresCard({
    Key? key,
    required this.tituloCard,
    required this.valor,
    required this.accent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    //DB CONTA O VALOR VAZIO, QUE ESTÁ CONFIGURADO PARA O LIVRO SEM AUTOR
    int valorCalculado = (valor == null || valor == 0) ? 0 : (valor! - 1);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Text(tituloCard, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: accent)),
          ),
          Card(
            clipBehavior: Clip.antiAlias,
            color: cs.secondaryContainer,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person_outline_outlined, color: cs.onSecondaryContainer),
                      const SizedBox(width: 16),
                      Text(
                        'Autores',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: cs.onSecondaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  Text(
                    valorCalculado.toString(),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: cs.onSecondaryContainer,
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
