import 'package:flutter/material.dart';

class EstatisticaGeralCard extends StatelessWidget {
  final String titulo;
  final IconData icon;
  final dynamic valor;

  const EstatisticaGeralCard({
    Key? key,
    required this.titulo,
    required this.icon,
    required this.valor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final valorStr = valor?.toString() ?? '-';

    return Card(
      clipBehavior: Clip.antiAlias,
      color: cs.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: cs.onSurface),
                const SizedBox(width: 16),
                Text(
                  titulo,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: cs.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                valorStr,
                textAlign: TextAlign.end,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: cs.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
