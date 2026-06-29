import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LivroForm extends StatelessWidget {
  final Uint8List? capa;
  final BorderRadius capaBorder;
  final VoidCallback onPickCapa;
  final VoidCallback onRemoveCapa;
  final int situacaoSelecionada;
  final ValueChanged<int> onSituacaoChanged;
  final TextEditingController nomeController;
  final TextEditingController autorController;
  final TextEditingController paginasController;
  final bool nomeValido;
  final VoidCallback onSalvar;

  const LivroForm({
    super.key,
    required this.capa,
    required this.capaBorder,
    required this.onPickCapa,
    required this.onRemoveCapa,
    required this.situacaoSelecionada,
    required this.onSituacaoChanged,
    required this.nomeController,
    required this.autorController,
    required this.paginasController,
    required this.nomeValido,
    required this.onSalvar,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        // Padding(
        //   padding: const EdgeInsets.only(left: 8, bottom: 8),
        //   child: Text(
        //     "Capa",
        //     style: theme.textTheme.labelLarge?.copyWith(
        //       fontWeight: FontWeight.bold,
        //       color: theme.colorScheme.primary,
        //     ),
        //   ),
        // ),
        Card(
          color: theme.colorScheme.surfaceContainerHigh,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Card(
                  shape: RoundedRectangleBorder(borderRadius: capaBorder),
                  child: capa == null
                      ? Container(
                          width: 110,
                          height: 165,
                          decoration: BoxDecoration(
                            borderRadius: capaBorder,
                            color: theme.colorScheme.surfaceContainerHighest,
                          ),
                          child: Icon(Icons.image_outlined, color: theme.colorScheme.onSurfaceVariant, size: 36),
                        )
                      : ClipRRect(
                          borderRadius: capaBorder,
                          child: Image.memory(
                            capa!,
                            width: 110,
                            height: 165,
                            fit: BoxFit.fill,
                          ),
                        ),
                ),
                Column(
                  children: [
                    SizedBox(
                      width: 175,
                      height: 40,
                      child: FilledButton(
                        onPressed: onPickCapa,
                        child: const Text("Selecionar Capa"),
                      ),
                    ),
                    if (capa != null) const SizedBox(height: 12),
                    if (capa != null)
                      SizedBox(
                        width: 175,
                        height: 40,
                        child: FilledButton.tonal(
                          onPressed: onRemoveCapa,
                          child: const Text("Remover Capa"),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        DropdownMenu<int>(
          initialSelection: situacaoSelecionada,
          expandedInsets: EdgeInsets.zero,
          label: const Text('Situação'),
          onSelected: (int? value) {
            if (value != null) {
              onSituacaoChanged(value);
            }
          },
          dropdownMenuEntries: const [
            DropdownMenuEntry<int>(
              value: 0,
              label: 'Lendo',
              leadingIcon: Icon(Icons.book_outlined),
            ),
            DropdownMenuEntry<int>(
              value: 1,
              label: 'Para Ler',
              leadingIcon: Icon(Icons.bookmark_outline_outlined),
            ),
            DropdownMenuEntry<int>(
              value: 2,
              label: 'Lido',
              leadingIcon: Icon(Icons.task_outlined),
            ),
          ],
        ),
        const SizedBox(height: 28),
        TextField(
          controller: nomeController,
          maxLength: 200,
          decoration: InputDecoration(
            labelText: "Nome",
            helperText: "* Obrigatório",
            border: const OutlineInputBorder(),
            errorText: nomeValido ? null : "Nome vazio",
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: autorController,
          maxLength: 150,
          decoration: const InputDecoration(
            labelText: "Autor",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: paginasController,
          maxLength: 5,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: const InputDecoration(
            labelText: "Nº de Páginas",
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
