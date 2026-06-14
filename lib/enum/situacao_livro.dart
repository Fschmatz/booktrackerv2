import 'package:flutter/material.dart';

enum SituacaoLivro {
  LENDO(
    0,
    "Lendo",
    Icons.book_outlined,
    Icons.book,
  ),
  PARA_LER(
    1,
    "Para Ler",
    Icons.bookmark_outline_outlined,
    Icons.bookmark,
  ),
  LIDO(
    2,
    "Lido",
    Icons.task_outlined,
    Icons.task,
  );

  const SituacaoLivro(this.id, this.nome, this.icon, this.selectedIcon);

  final int id;
  final String nome;
  final IconData icon;
  final IconData selectedIcon;

  static SituacaoLivro fromId(int id) {
    return SituacaoLivro.values.firstWhere((e) => e.id == id);
  }
}
