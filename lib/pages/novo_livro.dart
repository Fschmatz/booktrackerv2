import 'dart:io';
import 'package:booktrackerv2/db/livro_dao.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

class NovoLivro extends StatefulWidget {
  @override
  _NovoLivroState createState() => _NovoLivroState();

  Function() refreshHome;

  NovoLivro({Key? key, required this.refreshHome}) : super(key: key);
}

class _NovoLivroState extends State<NovoLivro> {
  BorderRadius capaBorder = BorderRadius.circular(12);
  final dbLivro = LivroDao.instance;
  int stateLivroSelecionado = 1;
  TextEditingController controllerNomeLivro = TextEditingController();
  TextEditingController controllerPaginas = TextEditingController();
  TextEditingController controllerAutor = TextEditingController();
  late FocusNode inputFieldNode;
  bool nomeValido = true;

  //IMAGEM
  final imagePicker = ImagePicker();
  File? capa;

  pickGallery() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    File? compressedFile = await FlutterNativeImage.compressImage(pickedFile!.path, quality: 90, targetWidth: 325, targetHeight: 475);

    if (compressedFile == null) {
      return 0;
    } else {
      setState(() {
        capa = compressedFile;
      });
    }
  }

  //AUTOR, PAGINAS E CAPA PODEM SER NULO
  void _salvarLivro() async {
    Map<String, dynamic> row = {
      LivroDao.columnNome: controllerNomeLivro.text,
      LivroDao.columnNumPaginas: controllerPaginas.text.isEmpty ? 0 : int.parse(controllerPaginas.text),
      LivroDao.columnAutor: controllerAutor.text,
      LivroDao.columnLido: stateLivroSelecionado,
      LivroDao.columnCapa: capa == null ? null : capa!.readAsBytesSync(),
    };
    final id = await dbLivro.insert(row);
  }

  bool validarTextFields() {
    if (controllerNomeLivro.text.isEmpty) {
      nomeValido = false;
      return false;
    }
    return true;
  }

  void removerCapa() {
    setState(() {
      capa = null;
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
              controller: controllerNomeLivro,
              onEditingComplete: () => node.nextFocus(),
              decoration: InputDecoration(
                  border: const OutlineInputBorder(), helperText: "* Obrigatório", labelText: "Nome", errorText: nomeValido ? null : "Nome vazio"),
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
              controller: controllerAutor,
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
              controller: controllerPaginas,
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
                      borderRadius: capaBorder,
                    ),
                    elevation: 0,
                    child: capa == null
                        ? Container(
                            decoration: BoxDecoration(borderRadius: capaBorder),
                            width: 70,
                            height: 105,
                          )
                        : ClipRRect(
                            borderRadius: capaBorder,
                            child: Image.file(
                              capa!,
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
                      capa != null
                          ? const SizedBox(
                              height: 20,
                            )
                          : const SizedBox.shrink(),
                      capa != null
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
              selected: <int>{stateLivroSelecionado},
              onSelectionChanged: (Set<int> newSelection) {
                setState(() {
                  stateLivroSelecionado = newSelection.first;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: FilledButton.icon(
                onPressed: () {
                  if (validarTextFields()) {
                    _salvarLivro();
                    widget.refreshHome();
                    Navigator.of(context).pop();
                  } else {
                    setState(() {
                      nomeValido;
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
