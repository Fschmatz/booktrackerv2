import 'package:flutter/material.dart';

class EstatisticaLivrosPaginasCard extends StatelessWidget {
  final int livrosLendo;
  final int livrosParaLer;
  final int livrosLidos;
  final int paginasLendo;
  final int paginasParaLer;
  final int paginasLidos;
  final Color accent;

  const EstatisticaLivrosPaginasCard({
    Key? key,
    required this.livrosLendo,
    required this.livrosParaLer,
    required this.livrosLidos,
    required this.paginasLendo,
    required this.paginasParaLer,
    required this.paginasLidos,
    required this.accent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final int totalLivros = livrosLendo + livrosParaLer + livrosLidos;
    final int totalPaginas = paginasLendo + paginasParaLer + paginasLidos;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Text(
              'Livros e páginas',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: accent,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: _buildColunaCard(
                  context,
                  titulo: 'Lendo',
                  icon: Icons.book_outlined,
                  livros: livrosLendo,
                  paginas: paginasLendo,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildColunaCard(
                  context,
                  titulo: 'Para ler',
                  icon: Icons.bookmark_outline_outlined,
                  livros: livrosParaLer,
                  paginas: paginasParaLer,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildColunaCard(
                  context,
                  titulo: 'Lidos',
                  icon: Icons.task_outlined,
                  livros: livrosLidos,
                  paginas: paginasLidos,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildTotalCard(
            context,
            totalLivros: totalLivros,
            totalPaginas: totalPaginas,
          ),
        ],
      ),
    );
  }

  Widget _buildColunaCard(
    BuildContext context, {
    required String titulo,
    required IconData icon,
    required int livros,
    required int paginas,
  }) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Card(
      color: cs.surfaceContainerHighest,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Topo: Ícone + Título
            Row(
              children: [
                Icon(icon, size: 18, color: cs.onSurface),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    titulo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Livros
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                livros.toString(),
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: cs.onSurface,
                  height: 1.1,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'livros',
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 14),

            // Páginas
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                paginas.toString(),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: cs.onSurface,
                  height: 1.1,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'páginas',
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalCard(
    BuildContext context, {
    required int totalLivros,
    required int totalPaginas,
  }) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Card(
      color: cs.primaryContainer,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.notes_rounded,
                  size: 20,
                  color: cs.onPrimaryContainer,
                ),
                const SizedBox(width: 8),
                Text(
                  'Total',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.onPrimaryContainer,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    totalLivros.toString(),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: cs.onPrimaryContainer,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'livros',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: cs.onPrimaryContainer.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    '•',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: cs.onPrimaryContainer.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    totalPaginas.toString(),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: cs.onPrimaryContainer,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'páginas',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: cs.onPrimaryContainer.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
