import 'package:flutter/material.dart';

import 'laporanTab.dart';

class Perbaikan extends StatefulWidget {
  const Perbaikan({Key? key}) : super(key: key);

  @override
  State<Perbaikan> createState() => _PerbaikanState();
}

class _PerbaikanState extends State<Perbaikan> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: LaporanTab(),
    );
  }
}
