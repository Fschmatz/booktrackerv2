import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../db/livro_dao.dart';

class DialogListaLidos extends StatefulWidget {
  const DialogListaLidos({Key? key}) : super(key: key);

  @override
  _DialogListaLidosState createState() => _DialogListaLidosState();
}

class _DialogListaLidosState extends State<DialogListaLidos> {
  List<Map<String, dynamic>> listaLivros = [];
  final dbLivro = LivroDao.instance;
  bool loading = true;
  String listaFormatada = '';

  @override
  void initState() {
    getLivrosLidos();
    super.initState();
  }

  void getLivrosLidos() async {
    listaLivros = await dbLivro.queryNomeAllLivrosLidos();

    for (int i = 0; i < listaLivros.length; i++) {
      listaFormatada += "• " + listaLivros[i]['nome'].toString() + "\n";
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: const Text('Lista de livros lidos'),
      scrollable: true,
      content: SizedBox(
          height: 220.0,
          width: 350.0,
          child: loading
              ? const SizedBox.shrink()
              : SelectableText(listaFormatada)),
      actions: [
        TextButton(
          child: const Text(
            "Fechar",
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text(
            "Copiar lista",
          ),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: listaFormatada));
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
