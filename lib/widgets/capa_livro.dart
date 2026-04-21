import 'dart:typed_data';
import 'package:flutter/material.dart';

class CapaLivro extends StatelessWidget {
  final Uint8List? capa;
  final BorderRadius borderRadius;
  final double width;
  final double height;

  const CapaLivro({
    Key? key,
    required this.capa,
    required this.borderRadius,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (capa == null) {
      return SizedBox(
        height: height,
        width: width,
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
          margin: EdgeInsets.zero,
          child: Icon(
            Icons.book_outlined,
            size: 35,
            color: theme.hintColor,
          ),
        ),
      );
    }

    return SizedBox(
      height: height,
      width: width,
      child: ClipRRect(
        borderRadius: borderRadius,
        clipBehavior: Clip.antiAlias,
        child: Image.memory(
          capa!,
          fit: BoxFit.fill,
          filterQuality: FilterQuality.medium,
          gaplessPlayback: true,
        ),
      ),
    );
  }
}
