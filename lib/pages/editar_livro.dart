import 'dart:io';
import 'package:booktrackerv2/class/livro.dart';
import 'package:booktrackerv2/db/livro_dao.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

class EditarLivro extends StatefulWidget {
  @override
  _EditarLivroState createState() => _EditarLivroState();

  Function() refreshLista;
  Livro livro;

  EditarLivro({Key? key, required this.refreshLista, required this.livro})
      : super(key: key);
}

class _EditarLivroState extends State<EditarLivro> {
  final dbLivro = LivroDao.instance;

  TextEditingController controllerNomeLivro = TextEditingController();
  TextEditingController controllerPaginas = TextEditingController();
  TextEditingController controllerAutor = TextEditingController();
  bool nomeValido = true;

  //IMAGEM
  final imagePicker = ImagePicker();
  File? capa;
  bool capaFoiEditada = false;

  pickGallery() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    File compressedFile = await FlutterNativeImage.compressImage(
        pickedFile!.path,
        quality: 95,
        targetWidth: 325,
        targetHeight: 475);

    if (compressedFile == null) {
      return;
    } else {
      setState(() {
        capaFoiEditada = true;
        capa = compressedFile;
        widget.livro.capa = capa!.readAsBytesSync();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    controllerNomeLivro.text = widget.livro.nome;
    controllerPaginas.text = widget.livro.numPaginas.toString();
    controllerAutor.text = widget.livro.autor!;
  }

  void _atualizarLivro(int id) async {
    final dbLivro = LivroDao.instance;
    Map<String, dynamic> row = {
      LivroDao.columnIdLivro: id,
      LivroDao.columnNome: controllerNomeLivro.text,
      LivroDao.columnNumPaginas: controllerPaginas.text,
      LivroDao.columnAutor: controllerAutor.text,
      LivroDao.columnCapa:
          capaFoiEditada ? capa!.readAsBytesSync() : widget.livro.capa,
    };
    final atualizar = await dbLivro.update(row);
  }

  bool validarTextFields() {
    String errors = "";
    if (controllerNomeLivro.text.isEmpty) {
      errors += "Nome";
      nomeValido = false;
    }
    return errors.isEmpty ? true : false;
  }

  void removerCapa() {
    setState(() {
      capaFoiEditada = false;
      widget.livro.capa = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Livro'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_outlined),
            tooltip: 'Salvar',
            onPressed: () {
              if (validarTextFields()) {
                _atualizarLivro(widget.livro.id);
                widget.refreshLista();
                Navigator.of(context).pop();
              } else {
                setState(() {
                  nomeValido;
                });
              }
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextField(
              minLines: 1,
              maxLines: 3,
              maxLength: 200,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.name,
              controller: controllerNomeLivro,
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
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: Colors.grey[800]!.withOpacity(0.9),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 3, 20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        elevation: 0,
                        child: widget.livro.capa == null
                            ? Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5)),
                                width: 70,
                                height: 105,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.memory(
                                  widget.livro.capa!,
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
                          widget.livro.capa != null
                              ? const SizedBox(
                                  height: 20,
                                )
                              : const SizedBox.shrink(),
                          widget.livro.capa != null
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
        ],
      ),
    );
  }
}