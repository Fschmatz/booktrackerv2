import 'package:booktrackerv2/class/livro.dart';
import 'package:booktrackerv2/service/livro_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/livro_form.dart';

class EditarLivro extends StatefulWidget {
  final Livro livro;

  EditarLivro({Key? key, required this.livro}) : super(key: key);

  @override
  State<EditarLivro> createState() => _EditarLivroState();
}

class _EditarLivroState extends State<EditarLivro> {
  BorderRadius _capaBorder = BorderRadius.circular(12);
  late int _situacaoLivroSelecionado;
  TextEditingController _controllerNomeLivro = TextEditingController();
  TextEditingController _controllerPaginas = TextEditingController();
  TextEditingController _controllerAutor = TextEditingController();
  bool _nomeValido = true;
  final _imagePicker = ImagePicker();
  Uint8List? _capa;
  bool _capaFoiEditada = false;

  pickGallery() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    Uint8List? compressedFile = await FlutterImageCompress.compressWithFile(pickedFile!.path, quality: 90, minWidth: 325, minHeight: 475);

    if (compressedFile == null) {
      return;
    } else {
      setState(() {
        _capaFoiEditada = true;
        _capa = compressedFile;
        widget.livro.capa = _capa;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _controllerNomeLivro.text = widget.livro.nome;
    _controllerPaginas.text = widget.livro.numPaginas.toString();
    _controllerAutor.text = widget.livro.autor!;
    _situacaoLivroSelecionado = widget.livro.situacaoLivro!;
  }

  void _atualizarLivro() async {
    await LivroService().atualizar(widget.livro.id, _controllerNomeLivro.text, _controllerPaginas.text, _controllerAutor.text,
        _situacaoLivroSelecionado, _capaFoiEditada ? _capa! : widget.livro.capa ?? null);
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
      _capaFoiEditada = false;
      widget.livro.capa = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Livro'),
      ),
      body: LivroForm(
        capa: widget.livro.capa,
        capaBorder: _capaBorder,
        onPickCapa: pickGallery,
        onRemoveCapa: removerCapa,
        situacaoSelecionada: _situacaoLivroSelecionado,
        onSituacaoChanged: (v) => setState(() => _situacaoLivroSelecionado = v),
        nomeController: _controllerNomeLivro,
        autorController: _controllerAutor,
        paginasController: _controllerPaginas,
        nomeValido: _nomeValido,
        onSalvar: () {
          if (validarTextFields()) {
            _atualizarLivro();
            Navigator.pop(context);
          }
        },
        onEditingComplete: null,
      ),
    );
  }
}
