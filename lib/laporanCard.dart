import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';

class LaporanCard extends StatelessWidget {
  const LaporanCard(
      {Key? key,
      required this.nama,
      required this.jenisKerusakan,
      required this.levelKerusakan,
      required this.tindakan,
      required this.lamaWaktu,
      required this.lastUpdated,
      this.foto})
      : super(key: key);
  final String nama;
  final String jenisKerusakan;
  final String levelKerusakan;
  final String tindakan;
  final String lamaWaktu;
  final DateTime lastUpdated;
  final XFile? foto;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
            child: Text(
              nama,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Row(
              children: [
                Container(
                  width: 140,
                  child: Text('Jenis kerusakan'),
                ),
                Text(
                  jenisKerusakan,
                  style: TextStyle(backgroundColor: Colors.amber),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Row(
              children: [
                Container(width: 140, child: Text('Level Kerusakan')),
                Text(
                  levelKerusakan,
                  style: TextStyle(backgroundColor: Colors.amber),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Row(
              children: [
                Container(width: 140, child: Text('Tindakan')),
                Text(
                  tindakan,
                  style: TextStyle(backgroundColor: Colors.amber),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Row(
              children: [
                Container(width: 140, child: Text('Lama waktu')),
                Text(
                  lamaWaktu,
                  style: TextStyle(backgroundColor: Colors.amber),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Text(
              'Last Updated : $lastUpdated',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          // Container(
          //   child: Image.file(File(foto!.path)),
          //   height: 200,
          //   color: Colors.blueGrey,
          // ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Text('Keterangan'),
          ),
          Container(
            height: 1,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
