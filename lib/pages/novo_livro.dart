import 'dart:io';
import 'package:booktrackerv2/db/livro_dao.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

class NovoLivro extends StatefulWidget {
  @override
  _NovoLivroState createState() => _NovoLivroState();

  int paginaAtual;
  Function() refreshHome;

  NovoLivro({Key? key, required this.paginaAtual, required this.refreshHome}) : super(key: key);
}

class _NovoLivroState extends State<NovoLivro> {
  final dbLivro = LivroDao.instance;

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

    File? compressedFile = await FlutterNativeImage.compressImage(
        pickedFile!.path,
        quality: 95,
        targetWidth: 325,
        targetHeight: 475);

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
      LivroDao.columnNumPaginas: controllerPaginas.text.isEmpty
          ? 0
          : int.parse(controllerPaginas.text),
      LivroDao.columnAutor: controllerAutor.text,
      LivroDao.columnLido: widget.paginaAtual,
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
       /* actions: [
          IconButton(
            icon: const Icon(Icons.save_outlined),
            tooltip: 'Salvar',
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
          ),
        ],*/
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  helperText: "* Obrigatório",
                  labelText: "Nome",
                  errorText: nomeValido ? null : "Nome vazio"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextField(
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\d{0,2}'))
              ],
              maxLength: 5,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: false),
              controller: controllerPaginas,
              onEditingComplete: () => node.nextFocus(),
              decoration: const InputDecoration(
                labelText: "Nº de Páginas",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 5, 25, 10),
            child: Text(
              "Capa",
              style:
                  TextStyle(fontSize: 16, color: Theme.of(context).hintColor),
            ),
          ),
          ListTile(
            title: Card(
              margin: const EdgeInsets.all(0),
              elevation: 0,
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: BorderSide(
                  color: Colors.grey[800]!.withOpacity(0.9),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 5, 20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        elevation: 0,
                        child: capa == null
                            ? Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5)),
                                width: 70,
                                height: 105,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(5),
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
                            child: TextButton(
                              onPressed: pickGallery,
                              child: const Text(
                                "Selecionar Capa",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal),
                              ),
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                primary: Theme.of(context).cardTheme.color,
                                onPrimary: Theme.of(context)
                                    .textTheme
                                    .headline1!
                                    .color,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
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
                                  child: TextButton(
                                    onPressed: removerCapa,
                                    child: const Text(
                                      "Remover Capa",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      primary:
                                          Theme.of(context).cardTheme.color,
                                      onPrimary: Theme.of(context)
                                          .textTheme
                                          .headline1!
                                          .color,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
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
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: FilledButton.tonalIcon(
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
                icon: Icon(Icons.save_outlined,
                    color: Theme.of(context).colorScheme.onPrimary),
                label: Text(
                  'Save',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary),
                )),
          ),
        ],
      ),
    );
  }
}
