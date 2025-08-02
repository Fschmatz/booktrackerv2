import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

import '../service/livro_service.dart';

class NovoLivro extends StatefulWidget {
  NovoLivro({
    Key? key,
  }) : super(key: key);

  @override
  State<NovoLivro> createState() => _NovoLivroState();
}

class _NovoLivroState extends State<NovoLivro> {
  BorderRadius _capaBorder = BorderRadius.circular(12);
  int _situacaoLivroSelecionado = 1;
  TextEditingController _controllerNomeLivro = TextEditingController();
  TextEditingController _controllerPaginas = TextEditingController();
  TextEditingController _controllerAutor = TextEditingController();
  bool _nomeValido = true;
  final _imagePicker = ImagePicker();
  Uint8List? _capa;

  pickGallery() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    Uint8List? compressedFile = await FlutterImageCompress.compressWithFile(pickedFile!.path, quality: 90, minWidth: 325, minHeight: 475);

    if (compressedFile == null) {
      return 0;
    } else {
      setState(() {
        _capa = compressedFile;
      });
    }
  }

  void _inserir() async {
    await LivroService()
        .inserir(_controllerNomeLivro.text, _controllerPaginas.text, _controllerAutor.text, _situacaoLivroSelecionado, _capa == null ? null : _capa);
  }

  bool validarTextFields() {
    if (_controllerNomeLivro.text.isEmpty) {
      _nomeValido = false;
      return false;
    }
    return true;
  }

  void removerCapa() {
    setState(() {
      _capa = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Livro'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: TextField(
              autofocus: true,
              minLines: 1,
              maxLines: 3,
              maxLength: 200,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.name,
              controller: _controllerNomeLivro,
              onEditingComplete: () => node.nextFocus(),
              decoration: InputDecoration(
                  border: const OutlineInputBorder(), helperText: "* Obrigatório", labelText: "Nome", errorText: _nomeValido ? null : "Nome vazio"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: TextField(
              minLines: 1,
              maxLines: 2,
              maxLength: 150,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.name,
              controller: _controllerAutor,
              onEditingComplete: () => node.nextFocus(),
              decoration: const InputDecoration(
                labelText: "Autor",
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: TextField(
              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\d{0,2}'))],
              maxLength: 5,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              keyboardType: const TextInputType.numberWithOptions(decimal: false),
              controller: _controllerPaginas,
              onEditingComplete: () => node.nextFocus(),
              decoration: const InputDecoration(
                labelText: "Nº de Páginas",
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 25, 5),
            child: Text(
              "Capa",
              style: TextStyle(fontSize: 16),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
            title: Card(
              margin: const EdgeInsets.all(0),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: BorderSide(
                  color: Colors.grey,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 5, 20),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: _capaBorder,
                    ),
                    elevation: 0,
                    child: _capa == null
                        ? Container(
                            decoration: BoxDecoration(borderRadius: _capaBorder),
                            width: 70,
                            height: 105,
                          )
                        : ClipRRect(
                            borderRadius: _capaBorder,
                            child: Image.memory(
                              _capa!,
                              width: 70,
                              height: 105,
                              fit: BoxFit.fill,
                            ),
                          ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: 175,
                        height: 40,
                        child: FilledButton(
                          onPressed: pickGallery,
                          child: const Text(
                            "Selecionar Capa",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                      _capa != null
                          ? const SizedBox(
                              height: 20,
                            )
                          : const SizedBox.shrink(),
                      _capa != null
                          ? SizedBox(
                              width: 175,
                              height: 40,
                              child: FilledButton(
                                onPressed: removerCapa,
                                child: const Text(
                                  "Remover Capa",
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 10, 25, 10),
            child: Text(
              "Situação",
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 5),
            child: SegmentedButton<int>(
              showSelectedIcon: false,
              segments: const <ButtonSegment<int>>[
                ButtonSegment<int>(value: 0, label: Text('Lendo'), icon: Icon(Icons.book_outlined)),
                ButtonSegment<int>(value: 1, label: Text('Para Ler'), icon: Icon(Icons.bookmark_outline_outlined)),
                ButtonSegment<int>(value: 2, label: Text('Lido'), icon: Icon(Icons.task_outlined)),
              ],
              selected: <int>{_situacaoLivroSelecionado},
              onSelectionChanged: (Set<int> newSelection) {
                setState(() {
                  _situacaoLivroSelecionado = newSelection.first;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: FilledButton.icon(
                onPressed: () {
                  if (validarTextFields()) {
                    _inserir();
                    Navigator.of(context).pop();
                  } else {
                    setState(() {
                      _nomeValido;
                    });
                  }
                },
                icon: Icon(Icons.save_outlined),
                label: Text('Salvar')),
          ),
        ],
      ),
    );
  }
}
