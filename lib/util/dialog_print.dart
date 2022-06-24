import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../db/livro_dao.dart';

class DialogPrint extends StatefulWidget {
  DialogPrint({Key? key}) : super(key: key);

  @override
  _DialogPrintState createState() => _DialogPrintState();
}

class _DialogPrintState extends State<DialogPrint> {
  List<Map<String, dynamic>> listaLivros = [];
  final dbLivro = LivroDao.instance;
  bool loading = true;
  String listaFormatada = '';

  @override
  void initState() {
    getNotes();
    super.initState();
  }

  void getNotes() async {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista'),
        actions: [
          TextButton(
            child: const Text(
              "Copiar",
            ),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: listaFormatada));
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        children: [
          loading
              ? const SizedBox.shrink()
              : SelectableText(
            listaFormatada,
                  style: const TextStyle(fontSize: 16),
                ),
        ],
      ),
    );
  }
}
