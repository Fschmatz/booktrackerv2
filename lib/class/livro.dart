import 'dart:typed_data';

import '../db/livro_dao.dart';
import '../enum/situacao_livro.dart';

class Livro {
  int? id;
  String nome;
  int? numPaginas;
  String? autor;
  int? situacaoLivro;
  Uint8List? capa;
  String? criadoEm;
  String? finalizadoEm;

  Livro({
    this.id,
    required this.nome,
    this.numPaginas,
    this.autor,
    this.situacaoLivro,
    this.capa,
    this.criadoEm,
    this.finalizadoEm,
  });

  factory Livro.fromMap(Map<String, dynamic> map) {
    return Livro(
      id: map[LivroDao.columnIdLivro] as int?,
      nome: map[LivroDao.columnNome] as String,
      numPaginas: map[LivroDao.columnNumPaginas] as int?,
      autor: map[LivroDao.columnAutor] as String?,
      situacaoLivro: map[LivroDao.columnSituacaoLivro] as int?,
      capa: map[LivroDao.columnCapa] as Uint8List?,
      criadoEm: map[LivroDao.columnCriadoEm] as String?,
      finalizadoEm: map[LivroDao.columnFinalizadoEm] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) LivroDao.columnIdLivro: id,
      LivroDao.columnNome: nome,
      LivroDao.columnNumPaginas: numPaginas,
      LivroDao.columnAutor: autor,
      LivroDao.columnSituacaoLivro: situacaoLivro,
      LivroDao.columnCapa: capa,
      LivroDao.columnCriadoEm: criadoEm,
      LivroDao.columnFinalizadoEm: finalizadoEm,
    };
  }

  Livro copyWith({
    int? id,
    String? nome,
    int? numPaginas,
    String? autor,
    int? situacaoLivro,
    Uint8List? capa,
    String? criadoEm,
    String? finalizadoEm,
  }) {
    return Livro(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      numPaginas: numPaginas ?? this.numPaginas,
      autor: autor ?? this.autor,
      situacaoLivro: situacaoLivro ?? this.situacaoLivro,
      capa: capa ?? this.capa,
      criadoEm: criadoEm ?? this.criadoEm,
      finalizadoEm: finalizadoEm ?? this.finalizadoEm,
    );
  }

  SituacaoLivro get getSituacaoLivroAsEnum {
    return SituacaoLivro.fromId(situacaoLivro!);
  }

  bool isFinalizado() {
    return situacaoLivro != null && SituacaoLivro.fromId(situacaoLivro!) == SituacaoLivro.LIDO;
  }
}
