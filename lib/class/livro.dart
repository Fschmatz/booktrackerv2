import 'dart:typed_data';

import '../enum/situacao_livro.dart';

class Livro {
  int id;
  String nome;
  int? numPaginas;
  String? autor;
  int? situacaoLivro;
  Uint8List? capa;

  Livro({required this.id, required this.nome, this.numPaginas, this.autor, this.situacaoLivro, this.capa});

  factory Livro.fromMap(Map<String, dynamic> map) {
    return Livro(
      id: map['idLivro'] as int,
      nome: map['nome'] as String,
      numPaginas: map['numPaginas'] as int?,
      autor: map['autor'] as String?,
      situacaoLivro: map['situacaoLivro'] as int?,
      capa: map['capa'] as Uint8List?,
    );
  }

  SituacaoLivro get getSituacaoLivroAsEnum {
    return SituacaoLivro.fromId(situacaoLivro!);
  }
}
