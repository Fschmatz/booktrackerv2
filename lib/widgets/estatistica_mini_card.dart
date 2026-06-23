import 'package:flutter/material.dart';

class EstatisticaMiniCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final int? value;
  final Color bg;
  final Color fg;

  const EstatisticaMiniCard({
    Key? key,
    required this.label,
    required this.icon,
    required this.value,
    required this.bg,
    required this.fg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: bg,
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 22, color: fg),
              const SizedBox(height: 12),
              Text(
                (value ?? 0).toString(),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: fg,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(color: fg.withValues(alpha: 0.75)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
