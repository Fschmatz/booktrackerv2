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
  final VoidCallback? onEditingComplete;

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
    required this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(18, 0, 25, 5),
          child: Text("Capa", style: TextStyle(fontSize: 14)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Card(
            elevation: 0,
            color: theme.colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: const BorderSide(color: Colors.grey),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 5, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: capaBorder),
                    child: capa == null
                        ? Container(
                            width: 70,
                            height: 105,
                            decoration: BoxDecoration(borderRadius: capaBorder),
                          )
                        : ClipRRect(
                            borderRadius: capaBorder,
                            child: Image.memory(
                              capa!,
                              width: 70,
                              height: 105,
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
                      if (capa != null) const SizedBox(height: 20),
                      if (capa != null)
                        SizedBox(
                          width: 175,
                          height: 40,
                          child: FilledButton(
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
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(18, 15, 25, 5),
          child: Text("Situação", style: TextStyle(fontSize: 14)),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 5),
          child: SegmentedButton<int>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(value: 0, label: Text('Lendo'), icon: Icon(Icons.book_outlined)),
              ButtonSegment(value: 1, label: Text('Para Ler'), icon: Icon(Icons.bookmark_outline_outlined)),
              ButtonSegment(value: 2, label: Text('Lido'), icon: Icon(Icons.task_outlined)),
            ],
            selected: {situacaoSelecionada},
            onSelectionChanged: (s) => onSituacaoChanged(s.first),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          child: TextField(
            controller: nomeController,
            maxLength: 200,
            onEditingComplete: onEditingComplete,
            decoration: InputDecoration(
              labelText: "Nome",
              helperText: "* Obrigatório",
              border: const OutlineInputBorder(),
              errorText: nomeValido ? null : "Nome vazio",
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: TextField(
            controller: autorController,
            maxLength: 150,
            onEditingComplete: onEditingComplete,
            decoration: const InputDecoration(
              labelText: "Autor",
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: TextField(
            controller: paginasController,
            maxLength: 5,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            onEditingComplete: onEditingComplete,
            decoration: const InputDecoration(
              labelText: "Nº de Páginas",
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 5, 16, 12),
          child: FilledButton.icon(
            onPressed: onSalvar,
            icon: const Icon(Icons.save_outlined),
            label: const Text('Salvar'),
          ),
        ),
      ],
    );
  }
}
