import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ta/laporanCard.dart';
import 'api.dart';

class Reported extends StatefulWidget {
  const Reported({Key? key}) : super(key: key);

  @override
  State<Reported> createState() => _ReportedState();
}

class _ReportedState extends State<Reported> {
  List<String> data = [];
  void getData() {
    if (data.isEmpty) {
      fetchData().then((List<String> res) {
        setState(() {
          data = res;
        });
      });
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    getData();
    var todayData = {};
    List<dynamic> dataShown = [];
    DateTime todayDate = DateTime.now();
    for (var v in data) {
      var a = jsonDecode(v);
      var b = a.keys.first; //date
      todayDate = DateTime.parse(b); //put if (today == b) here
      var c = a[b];

      todayData = c;
      Iterable<String> nama = c.keys; // runway taxiway
      nama.forEach((bagian) {
        var dtemp = c[bagian];
        var acceptedFile;
        var d = jsonDecode(dtemp);
        Iterable<String> bagianKerusakan = d.keys; //permukaan perkerasan
        bagianKerusakan.forEach((kerusakan) {
          var h = d[kerusakan];
          if (h.keys.length == 5) {
            acceptedFile = h;
          }
        });
        print(acceptedFile.toString() == 'null');
        dataShown.add((acceptedFile.toString() != 'null')
            ? (LaporanCard(
                nama: bagian,
                jenisKerusakan: acceptedFile['jenisKerusakan'] ?? 'jk',
                levelKerusakan: acceptedFile['levelKerusakan'] ?? 'lk',
                tindakan: acceptedFile['tindakan'] ?? 'td',
                lamaWaktu: acceptedFile['lamaWaktuPerbaikan'] ?? 'lw',
                lastUpdated: todayDate,
                // foto: jsonDecode(file['foto'])
              ))
            : SizedBox.shrink());
      });
      // for (var w in c) {
      //   var d = w.keys.first; //nama (Runway, Taxiway,etc.)
      //   var e = w[d];
      //   var f = jsonDecode(e);
      //   Iterable<String> g = f.keys;

      //   g.forEach((element) {
      //     var h = f[element];
      //     Iterable<String> i = h.keys;
      //     i.forEach((elementa) {
      //       print(elementa);
      //     });
      //   });
      // }
    }
    return Column(
      children: [
        ...dataShown
        // ...todayData.map((elm) {
        //   String nama = elm.keys.first;
        //   var file = {};
        //   var e = elm[nama];
        //   var f = jsonDecode(e);
        //   Iterable<String> g = f.keys;
        //   // print(f);
        //   g.forEach((element) {
        //     var h = f[element];
        //     print(h.keys.length);
        //     if (h.keys.length == 5) {
        //       file = h;
        //     }
        //     Iterable<String> i = h.keys;
        //     i.forEach((elementa) {
        //       // print(elementa);
        //     });
        //   });
        //   print(file);
        //   return (file.toString() != '{}')
        //       ? (LaporanCard(
        //           nama: elm.keys.first,
        //           jenisKerusakan: file['jenisKerusakan'] ?? 'jk',
        //           levelKerusakan: file['levelKerusakan'] ?? 'lk',
        //           tindakan: file['tindakan'] ?? 'td',
        //           lamaWaktu: file['lamaWaktuPerbaikan'] ?? 'lw',
        //           lastUpdated: todayDate,
        //           // foto: jsonDecode(file['foto'])
        //         ))
        //       : SizedBox.shrink();
        //   ;
        //   // return Text('data');
        // })
      ],
    );
  }
}
